import json
import logging
import os
import traceback
from typing import Any, Dict

import functions_framework
import requests
from flask import Request, jsonify, make_response


def _cashfree_base(env: str) -> str:
    return 'https://api.cashfree.com/pg' if env.upper() == 'PRODUCTION' else 'https://sandbox.cashfree.com/pg'


def _headers(client_id: str, client_secret: str, api_version: str) -> Dict[str, str]:
    return {
        'X-Client-Id': client_id,
        'X-Client-Secret': client_secret,
        'x-api-version': api_version,
        'Content-Type': 'application/json',
        'Accept': 'application/json',
    }


def _corsify(response):
    allowed_origin = os.getenv('ALLOWED_ORIGIN', '*')
    response.headers['Access-Control-Allow-Origin'] = allowed_origin
    response.headers['Access-Control-Allow-Methods'] = 'GET,POST,OPTIONS'
    response.headers['Access-Control-Allow-Headers'] = 'Content-Type,Authorization'
    response.headers['Access-Control-Max-Age'] = '3600'
    return response


def _json_response(payload: Dict[str, Any], code: int = 200):
    return _corsify(make_response(jsonify(payload), code))


def _error(message: str, code: int, extra: Dict[str, Any] | None = None):
    payload: Dict[str, Any] = {'error': message}
    if extra:
        payload['details'] = extra
    return _json_response(payload, code)


def _is_json(text: str) -> bool:
    try:
        json.loads(text)
        return True
    except Exception:
        return False


@functions_framework.http
def cashfree_http(request: Request):
    """
    Google Cloud Functions (Gen 2) HTTP entrypoint.
    Routes:
      - POST  /payment/cashfree/create-order
      - GET   /payment/cashfree/verify?order_id=...
      - POST  /payment/cashfree/verify  {"order_id":"..."}
      - GET   /health
    Set env vars: CASHFREE_CLIENT_ID, CASHFREE_CLIENT_SECRET, CASHFREE_ENV(SANDBOX|PRODUCTION), CASHFREE_API_VERSION (default 2025-01-01)
    """
    try:
        path = request.path or '/'
        method = request.method

        env = os.getenv('CASHFREE_ENV', 'SANDBOX')
        client_id = os.getenv('CASHFREE_CLIENT_ID', '')
        client_secret = os.getenv('CASHFREE_CLIENT_SECRET', '')
        api_version = os.getenv('CASHFREE_API_VERSION', '2025-01-01')

        if not client_id or not client_secret:
            return _error('Missing Cashfree client credentials', 500)

        base = _cashfree_base(env)

        # CORS preflight
        if method == 'OPTIONS':
            return _corsify(make_response('', 204))

        # Health check
        if path.endswith('/health'):
            return _json_response({'ok': True}, 200)

        # Create Order
        if '/payment/cashfree/create-order' in path and method == 'POST':
            data = request.get_json(silent=True) or {}

            order_amount = data.get('order_amount')
            order_currency = data.get('order_currency', 'INR')
            customer_details = data.get('customer_details', {})
            order_meta = data.get('order_meta')

            # Basic validation
            if not isinstance(order_amount, (int, float)) or float(order_amount) <= 0:
                return _error('Invalid order_amount', 400)
            if not isinstance(order_currency, str) or not order_currency:
                return _error('Invalid order_currency', 400)
            if not isinstance(customer_details, dict) or not customer_details.get('customer_id'):
                return _error('Missing customer_details.customer_id', 400)

            payload: Dict[str, Any] = {
                'order_amount': float(order_amount),
                'order_currency': order_currency,
                'customer_details': {
                    'customer_id': customer_details.get('customer_id'),
                    'customer_name': customer_details.get('customer_name', ''),
                    'customer_email': customer_details.get('customer_email', ''),
                    'customer_phone': customer_details.get('customer_phone', ''),
                },
            }
            if isinstance(order_meta, dict) and order_meta.get('return_url'):
                payload['order_meta'] = {'return_url': order_meta['return_url']}

            resp = requests.post(
                f'{base}/orders',
                headers=_headers(client_id, client_secret, api_version),
                data=json.dumps(payload),
                timeout=20,
            )

            if resp.status_code not in (200, 201):
                logging.error('Cashfree create order failed: %s %s', resp.status_code, resp.text)
                return _error(
                    'Cashfree create order failed',
                    502,
                    extra=resp.json() if _is_json(resp.text) else {'raw': resp.text},
                )

            body = resp.json()
            response = {
                'order_id': body.get('order_id') or body.get('orderId'),
                'payment_session_id': body.get('payment_session_id') or body.get('paymentSessionId'),
                'order_amount': body.get('order_amount') or body.get('amount'),
                'order_currency': body.get('order_currency') or body.get('currency', 'INR'),
                'raw': body,
            }
            return _json_response(response, 200)

        # Verify Order
        if '/payment/cashfree/verify' in path and method in ('GET', 'POST'):
            if method == 'GET':
                order_id = request.args.get('order_id')
            else:
                data = request.get_json(silent=True) or {}
                order_id = data.get('order_id')

            if not order_id:
                return _error('Missing order_id', 400)

            resp = requests.get(
                f'{base}/orders/{order_id}',
                headers=_headers(client_id, client_secret, api_version),
                timeout=20,
            )

            if resp.status_code != 200:
                logging.error('Cashfree verify failed: %s %s', resp.status_code, resp.text)
                return _error(
                    'Cashfree verify failed',
                    502,
                    extra=resp.json() if _is_json(resp.text) else {'raw': resp.text},
                )

            return _json_response(resp.json(), 200)

        return _error('Not Found', 404)

    except Exception as e:  # pragma: no cover
        logging.exception('Unhandled error in cashfree_http')
        return _error('Server error', 500, extra={'message': str(e), 'trace': traceback.format_exc()})
