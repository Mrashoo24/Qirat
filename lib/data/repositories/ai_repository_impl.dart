import 'package:dartz/dartz.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/ai/recommendation.dart';
import '../../domain/entities/product/product.dart';
import '../../domain/repositories/ai_repository.dart';
import '../data_sources/remote/ai_remote_data_source.dart';
import '../models/ai/recommendation_model.dart';

class AiRepositoryImpl implements AiRepository {
  final AiRemoteDataSource remote;

  AiRepositoryImpl({required this.remote});

  @override
  Future<Either<Failure, Recommendation>> recommendAttar({
    required String prompt,
    required List<Product> catalog,
  }) async {
    try {
      final RecommendationModel model =
          await remote.recommendAttar(prompt, catalog);
      // Guardrail: ensure the attarName is in provided catalog
      final names = catalog.map((e) => e.name.trim()).toSet();
      if (!names.contains(model.attarName.trim())) {
        // Fallback to first in-stock product
        final fallback = catalog.firstWhere(
          (p) => p.priceTags.isNotEmpty,
          orElse: () => catalog.isNotEmpty
              ? catalog.first
              : Product(
                  id: '',
                  name: 'Qirat Attar',
                  description: '',
                  images: const [],
                  priceTags: const [],
                  categories: const [],
                  tags: const [],
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                ),
        );
        return Right(Recommendation(
          attarName: fallback.name,
          justification:
              'Based on availability and your brief, ${fallback.name} best matches your request from our live catalog.',
        ));
      }
      return Right(model);
    } on ServerException {
      return Left(ServerFailure());
    } on Exception {
      return Left(ServerFailure());
    }
  }
}
