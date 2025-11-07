// ...existing code...
import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/payment/cf_payment_order.dart';

abstract class PaymentRepository {
  Future<Either<Failure, CfPaymentOrder>> createCashfreeOrder({
    required String customerId,
    required String customerName,
    required String customerPhone,
    required String customerEmail,
    required double amount,
    String currency = 'INR',
    String? returnUrl,
    Map<String, dynamic>? meta,
  });
}
