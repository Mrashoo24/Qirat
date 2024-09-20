import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/error/exceptions.dart';
import '../../models/product/product_model.dart';
import '../../models/product/product_response_model.dart';

abstract class ProductLocalDataSource {
  Future<List<ProductModel>> getLastProducts();
  Future<void> saveProducts(List<ProductModel> productsToCache);
}

const cachedProducts = 'CACHED_PRODUCTS';

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final SharedPreferences sharedPreferences;
  ProductLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<ProductModel>> getLastProducts() {
    final jsonString = sharedPreferences.getString(cachedProducts);
    if (jsonString != null) {
      return Future.value( List<ProductModel>.from(jsonDecode(jsonString).map((e) => ProductModel.fromJson(e))));
    } else {
     return  Future.value([]);
    }
  }

  @override
  Future<void> saveProducts(List<ProductModel> productsToCache) {
    return sharedPreferences.setString(
      cachedProducts,
      json.encode(productsToCache),
    );
  }
}
