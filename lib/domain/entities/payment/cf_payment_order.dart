// ...existing code...
class CfPaymentOrder {
  final String orderId;
  final String paymentSessionId;
  final double amount;
  final String currency;

  const CfPaymentOrder({
    required this.orderId,
    required this.paymentSessionId,
    required this.amount,
    required this.currency,
  });
}
