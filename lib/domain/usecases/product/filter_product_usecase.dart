import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../entities/product.dart';
import '../../repositories/product_repository.dart';

class FilterProductUseCase
    implements UseCase<List<Product>, FilterProductParams> {
  final ProductRepository repository;
  FilterProductUseCase(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call(
      FilterProductParams params) async {
    return await repository.filterProducts(params);
  }
}

class FilterProductParams extends Equatable {
  final String title;
  final String category;
  final double minPrice;
  final double maxPrice;

  const FilterProductParams({
    required this.title,
    required this.category,
    required this.minPrice,
    required this.maxPrice,
  });

  @override
  List<Object> get props => [title, category, minPrice, maxPrice];
}
