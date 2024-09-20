import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../data/models/product/product_model.dart';
import '../entities/product/product_response.dart';
import '../usecases/product/get_product_usecase.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<ProductModel>>> getProducts(FilterProductParams params);
}