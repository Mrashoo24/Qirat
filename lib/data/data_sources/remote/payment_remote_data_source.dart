// ...existing code...
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../core/error/exceptions.dart';
import '../../models/payment/cf_payment_order_model.dart';

abstract class PaymentRemoteDataSource {
  Future<CfPaymentOrderModel> createCfOrder({
    required String customerId,
    required String customerName,
    required String customerPhone,
    required String customerEmail,
    required double amount,
    required String currency,
    String? returnUrl,
    Map<String, dynamic>? meta,
  });
}

/// This calls YOUR backend (server) endpoint which must securely talk to Cashfree
/// and return order_id + payment_session_id.
/// Never call Cashfree secret endpoints from the client.
class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  final http.Client httpClient;
  final String baseUrl; // e.g., https://your-api.example.com

  PaymentRemoteDataSourceImpl(
      {required this.httpClient, required this.baseUrl});

  @override
  Future<CfPaymentOrderModel> createCfOrder({
    required String customerId,
    required String customerName,
    required String customerPhone,
    required String customerEmail,
    required double amount,
    required String currency,
    String? returnUrl,
    Map<String, dynamic>? meta,
  }) async {
    // Prefer calling your backend (recommended). If configured for direct Cashfree call,
    // use dart-define flags to provide credentials and environment.
    final useDirect = false;
        // const String.fromEnvironment('CASHFREE_DIRECT',
        //     defaultValue: 'false') ==
        // 'true';

    if (useDirect) {
      final env =
          const String.fromEnvironment('CASHFREE_ENV', defaultValue: 'SANDBOX');
      final clientId =
          const String.fromEnvironment('CASHFREE_CLIENT_ID', defaultValue: '');
      final clientSecret = const String.fromEnvironment(
          'CASHFREE_CLIENT_SECRET',
          defaultValue: '');

      if (clientId.isEmpty || clientSecret.isEmpty) {
        throw ServerException();
      }

      final host = env.toUpperCase() == 'PRODUCTION'
          ? 'https://api.cashfree.com/pg/orders'
          : 'https://sandbox.cashfree.com/pg/orders';
      final uri = Uri.parse(host);

      final body = {
        'order_amount': amount,
        'order_currency': currency,
        'customer_details': {
          'customer_id': customerId,
          'customer_name': customerName,
          'customer_email': customerEmail,
          'customer_phone': customerPhone,
        },
        if (returnUrl != null) 'order_meta': {'return_url': returnUrl},
      };

      final resp = await httpClient.post(
        uri,
        headers: {
          'X-Client-Id': clientId,
          'X-Client-Secret': clientSecret,
          'x-api-version': '2025-01-01',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (resp.statusCode != 200 && resp.statusCode != 201) {
        throw ServerException();
      }
      final data = jsonDecode(resp.body) as Map<String, dynamic>;
      return CfPaymentOrderModel.fromJson(data);
    } else {
      // Backend path (recommended)
      final uri = Uri.parse('$baseUrl/payment/cashfree/create-order');
      final body = {
        'order_amount': amount,
        'order_currency': currency,
        'customer_details': {
          'customer_id': customerId,
          'customer_name': customerName,
          'customer_email': customerEmail,
          'customer_phone': customerPhone,
        },
        if (returnUrl != null) 'order_meta': {'return_url': returnUrl},
        if (meta != null) 'meta': meta,
      };

      final resp = await httpClient.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (resp.statusCode != 200) {
        throw ServerException();
      }
      final data = jsonDecode(resp.body) as Map<String, dynamic>;
      return CfPaymentOrderModel.fromJson(data);
    }
  }
}
