import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../data/models/product/product_model.dart';
import '../../entities/category/category.dart';
import '../../entities/product/product_response.dart';
import '../../repositories/product_repository.dart';

class GetProductUseCase
    implements UseCase< List<ProductModel>, FilterProductParams> {
  final ProductRepository repository;
  GetProductUseCase(this.repository);

  @override
  Future<Either<Failure,  List<ProductModel>>> call(
      FilterProductParams params) async {
    return await repository.getProducts(params);
  }

}

class FilterProductParams {
  final String? keyword;
  final List<Category> categories;
  final double minPrice;
  final double maxPrice;
  final int? limit;
  final int? pageSize;
  final Map<String, dynamic>? orderBy;
  final List<String>? lastFieldValues;
  const FilterProductParams({
    this.keyword = '',
    this.categories = const [],
    this.minPrice = 0,
    this.maxPrice = 10000,
    this.limit = 0,
    this.pageSize = 10,this.orderBy, this.lastFieldValues,
  });

  FilterProductParams copyWith({
    int? skip,
    String? keyword,
    List<Category>? categories,
    double? minPrice,
    double? maxPrice,
    int? limit,
    int? pageSize,   Map<String, dynamic>? orderBy,
     List<String>? lastFieldValues,
  }) =>
      FilterProductParams(
        keyword: keyword ?? this.keyword,
        categories: categories ?? this.categories,
        minPrice: minPrice ?? this.minPrice,
        maxPrice: maxPrice ?? this.maxPrice,
        limit: skip ?? this.limit,
        pageSize: pageSize ?? this.pageSize,
        lastFieldValues: lastFieldValues ?? this.lastFieldValues); }