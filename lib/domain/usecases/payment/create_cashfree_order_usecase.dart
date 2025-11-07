// ...existing code...
import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/payment/cf_payment_order.dart';
import '../../repositories/payment_repository.dart';

class CreateCashfreeOrderUseCase {
  final PaymentRepository repo;
  CreateCashfreeOrderUseCase(this.repo);

  Future<Either<Failure, CfPaymentOrder>> call(Params params) {
    return repo.createCashfreeOrder(
      customerId: params.customerId,
      customerName: params.customerName,
      customerPhone: params.customerPhone,
      customerEmail: params.customerEmail,
      amount: params.amount,
      currency: params.currency,
      returnUrl: params.returnUrl,
      meta: params.meta,
    );
  }
}

class Params {
  final String customerId;
  final String customerName;
  final String customerPhone;
  final String customerEmail;
  final double amount;
  final String currency;
  final String? returnUrl;
  final Map<String, dynamic>? meta;
  const Params({
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
    required this.customerEmail,
    required this.amount,
    this.currency = 'INR',
    this.returnUrl,
    this.meta,
  });
}
