// ...existing code...
import 'package:dartz/dartz.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/payment/cf_payment_order.dart';
import '../../domain/repositories/payment_repository.dart';
import '../data_sources/remote/payment_remote_data_source.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource remote;

  PaymentRepositoryImpl({required this.remote});

  @override
  Future<Either<Failure, CfPaymentOrder>> createCashfreeOrder({
    required String customerId,
    required String customerName,
    required String customerPhone,
    required String customerEmail,
    required double amount,
    String currency = 'INR',
    String? returnUrl,
    Map<String, dynamic>? meta,
  }) async {
    try {
      final res = await remote.createCfOrder(
        customerId: customerId,
        customerName: customerName,
        customerPhone: customerPhone,
        customerEmail: customerEmail,
        amount: amount,
        currency: currency,
        returnUrl: returnUrl,
        meta: meta,
      );
      return Right(res);
    } on Failure catch (f) {
      return Left(f);
    } on ServerException {
      return Left(ServerFailure());
    } catch (_) {
      return Left(ServerFailure());
    }
  }
}
