import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../entities/ai/recommendation.dart';
import '../entities/product/product.dart';

abstract class AiRepository {
  Future<Either<Failure, Recommendation>> recommendAttar({
    required String prompt,
    required List<Product> catalog,
  });
}
