// ...existing code...
import '../../../domain/entities/payment/cf_payment_order.dart';

class CfPaymentOrderModel extends CfPaymentOrder {
  const CfPaymentOrderModel({
    required super.orderId,
    required super.paymentSessionId,
    required super.amount,
    required super.currency,
  });

  factory CfPaymentOrderModel.fromJson(Map<String, dynamic> json) {
    return CfPaymentOrderModel(
      orderId: (json['order_id'] ?? json['orderId'] ?? '').toString(),
      paymentSessionId: (json['payment_session_id'] ?? json['paymentSessionId'] ?? '').toString(),
      amount: ((json['order_amount'] ?? json['amount']) as num).toDouble(),
      currency: (json['order_currency'] ?? json['currency'] ?? 'INR').toString(),
    );
  }
}