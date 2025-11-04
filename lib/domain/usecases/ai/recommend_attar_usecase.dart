import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/ai/recommendation.dart';
import '../../entities/product/product.dart';
import '../../repositories/ai_repository.dart';

class RecommendAttarUseCase {
  final AiRepository repository;
  RecommendAttarUseCase(this.repository);

  Future<Either<Failure, Recommendation>> call(RecommendParams params) {
    return repository.recommendAttar(
        prompt: params.prompt, catalog: params.catalog);
  }
}

class RecommendParams {
  final String prompt;
  final List<Product> catalog;
  const RecommendParams({required this.prompt, required this.catalog});
}
