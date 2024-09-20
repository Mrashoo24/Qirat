import 'package:dartz/dartz.dart';
import 'package:eshop/data/models/product/product_model.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/product/product_response.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/usecases/product/get_product_usecase.dart';
import '../data_sources/local/product_local_data_source.dart';
import '../data_sources/remote/product_remote_data_source.dart';
import '../models/product/product_response_model.dart';

typedef _ConcreteOrProductChooser = Future<List<ProductModel>> Function();

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<ProductModel>>> getProducts(FilterProductParams params) async {
    return await _getProduct(() {
      return remoteDataSource.getProducts(params);
    });
  }

  Future<Either<Failure, List<ProductModel>>> _getProduct(
    _ConcreteOrProductChooser getConcreteOrProducts,
  ) async {
    final localProducts = await localDataSource.getLastProducts();

    if (localProducts.isEmpty) {
      try {
        final remoteProducts = await getConcreteOrProducts();
        localDataSource.saveProducts(remoteProducts);
        return Right(remoteProducts);
      } catch(e){
        print(e.toString());
        return Left(ServerFailure());
      }
      // on ServerException {
      //   return Left(ServerFailure());
      // }
    } 
    else {
      try {
        getRemoteProducts(getConcreteOrProducts);
        return Right(localProducts);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  getRemoteProducts(getConcreteOrProducts) async {
    try {
      final remoteProducts = await getConcreteOrProducts();
      localDataSource.saveProducts(remoteProducts);
    } catch(e){
      print(e.toString());
    }
  }

}