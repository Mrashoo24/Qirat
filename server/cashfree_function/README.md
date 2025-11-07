# Cashfree Cloud Function (Python)

HTTP Cloud Function (Gen 2) that proxies Cashfree Payment Gateway create-order and verify endpoints.

## Endpoints

Base path is the function URL. These routes are handled:

- POST /payment/cashfree/create-order
  - Body (JSON):
    ```json
    {
      "order_amount": 123.45,
      "order_currency": "INR",
      "customer_details": {
        "customer_id": "user_123",
        "customer_name": "Jane Customer",
        "customer_email": "jane@example.com",
        "customer_phone": "+911234567890"
      },
      "order_meta": {
        "return_url": "https://your.site/checkout/return?order_id={order_id}"
      }
    }
    ```
  - Response (200):
    ```json
    {
      "order_id": "order_XXXXXXXX",
      "payment_session_id": "session_XXXXXXXX",
      "order_amount": 123.45,
      "order_currency": "INR",
      "raw": { "...": "full Cashfree response for debugging" }
    }
    ```

- GET /payment/cashfree/verify?order_id=order_XXXXXXXX
  - Response (200): Raw JSON from `GET /pg/orders/{order_id}` (includes order status and payments summary).

- POST /payment/cashfree/verify
  - Body: `{ "order_id": "order_XXXXXXXX" }`

- GET /health
  - Simple health check: `{ "ok": true }`

CORS is enabled for `GET, POST, OPTIONS`. Set `ALLOWED_ORIGIN` env var to your web origin to restrict it; defaults to `*`.

## Environment variables

- CASHFREE_ENV: `SANDBOX` (default) or `PRODUCTION`
- CASHFREE_CLIENT_ID: Your Cashfree Client ID
- CASHFREE_CLIENT_SECRET: Your Cashfree Client Secret
- CASHFREE_API_VERSION: API version (default `2025-01-01`)
- ALLOWED_ORIGIN: Web origin for CORS (default `*`)

## Run locally

PowerShell (Windows):

```powershell
# From server/cashfree_function
python -m venv .venv; . .venv/Scripts/Activate.ps1
pip install -r requirements.txt

$env:CASHFREE_ENV = "SANDBOX"
$env:CASHFREE_CLIENT_ID = "your_sandbox_client_id"
$env:CASHFREE_CLIENT_SECRET = "your_sandbox_client_secret"
$env:CASHFREE_API_VERSION = "2025-01-01"
$env:ALLOWED_ORIGIN = "http://localhost:5000"  # your Flutter web origin during dev

python -m functions_framework --target=cashfree_http --port=8080
```

Now test:

```powershell
# create order
curl -X POST "http://localhost:8080/payment/cashfree/create-order" `
  -H "Content-Type: application/json" `
  -d '{
    "order_amount": 1.00,
    "order_currency": "INR",
    "customer_details": {"customer_id": "test_user"},
    "order_meta": {"return_url": "https://example.com/return?order_id={order_id}"}
  }'

# verify
curl "http://localhost:8080/payment/cashfree/verify?order_id=order_XXXXXXXX"
```

## Deploy to Google Cloud Functions (2nd gen)

Replace placeholders and choose a region (e.g., `asia-south1`).

```powershell
$project = "YOUR_GCP_PROJECT_ID"
$region = "asia-south1"
$source = "server/cashfree_function"

# First deploy (create)
gcloud functions deploy cashfree-http `
  --gen2 `
  --runtime python312 `
  --region $region `
  --source $source `
  --entry-point cashfree_http `
  --trigger-http `
  --allow-unauthenticated `
  --set-env-vars "CASHFREE_ENV=SANDBOX,CASHFREE_CLIENT_ID=your_client_id,CASHFREE_CLIENT_SECRET=your_client_secret,CASHFREE_API_VERSION=2025-01-01,ALLOWED_ORIGIN=https://your.site"

# Update env vars later
gcloud functions deploy cashfree-http `
  --gen2 --region $region `
  --set-env-vars "CASHFREE_ENV=PRODUCTION,CASHFREE_CLIENT_ID=prod_id,CASHFREE_CLIENT_SECRET=prod_secret,ALLOWED_ORIGIN=https://your.site"
```

After deploy, you'll get a URL like:

```
https://<region>-<project>.cloudfunctions.net/cashfree-http
```

Use it as `BACKEND_BASE_URL` in your Flutter app; the client already calls:

- POST {BACKEND_BASE_URL}/payment/cashfree/create-order
- GET  {BACKEND_BASE_URL}/payment/cashfree/verify?order_id=...

## Notes

- Do NOT expose your Cashfree client secret to the Flutter app. Keep it only on the server via env vars.
- For production, consider removing the `raw` field in the create-order response to reduce payload surface.
- Timeouts are set to 20s for upstream calls; adjust if needed.
- Logs are emitted for failed upstream calls; check Cloud Logging for details.
