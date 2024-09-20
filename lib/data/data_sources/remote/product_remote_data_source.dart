import 'dart:convert';

import 'package:eshop/data/firebase/firebase_services.dart';
import 'package:http/http.dart' as http;

import '../../../../core/error/exceptions.dart';
import '../../../core/constant/strings.dart';
import '../../../domain/usecases/product/get_product_usecase.dart';
import '../../models/product/product_model.dart';
import '../../models/product/product_response_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts(FilterProductParams params);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final FirebaseService client;
  ProductRemoteDataSourceImpl({required this.client});

  @override
  Future<List<ProductModel>> getProducts(params) => _getProductFromUrl(
      params,
      // '$baseUrl/products?keyword=${params.keyword}&pageSize=${params.pageSize}&page=${params.limit}&categories=${jsonEncode(params.categories.map((e) => e.id).toList())}'
  );

  Future<List<ProductModel>> _getProductFromUrl(FilterProductParams params) async {
    String productResponseJson = '''
{
  "meta": {
    "page": 1,
    "pageSize": 10,
    "total": 20
  },
  "data": [
    {
      "_id": "product123",
      "name": "Fresh Breeze",
      "description": "A refreshing fragrance perfect for summer days.",
      "priceTags": [
        {
          "_id": "priceTag123",
          "name": "Retail",
          "price": 29.99
        },
        {
          "_id": "priceTag124",
          "name": "Wholesale",
          "price": 24.99
        }
      ],
      "categories": [
        {
          "_id": "category123",
          "name": "Perfume",
          "image": "https://example.com/images/perfume.png"
        },
        {
          "_id": "category124",
          "name": "Summer Collection",
          "image": "https://example.com/images/summer_collection.png"
        }
      ],
      "images": [
        "https://example.com/images/product1.png",
        "https://example.com/images/product2.png"
      ],
      "createdAt": "2024-08-27T10:00:00Z",
      "updatedAt": "2024-08-27T12:00:00Z"
    },
    {
      "_id": "product124",
      "name": "Ocean Wave",
      "description": "A cool, aquatic scent for adventurers.",
      "priceTags": [
        {
          "_id": "priceTag125",
          "name": "Retail",
          "price": 34.99
        },
        {
          "_id": "priceTag126",
          "name": "Wholesale",
          "price": 29.99
        }
      ],
      "categories": [
        {
          "_id": "category125",
          "name": "Perfume",
          "image": "https://example.com/images/ocean_wave.png"
        },
        {
          "_id": "category126",
          "name": "Adventure Collection",
          "image": "https://example.com/images/adventure_collection.png"
        }
      ],
      "images": [
        "https://example.com/images/product3.png",
        "https://example.com/images/product4.png"
      ],
      "createdAt": "2024-08-26T09:00:00Z",
      "updatedAt": "2024-08-26T11:00:00Z"
    }
  ]
}
''';


    final response = await client.getAllDocuments(collectionPath: "products");

    // final response = await client.get(
    //   Uri.parse(url),
    //   headers: {
    //     'Content-Type': 'application/json',
    //   },
    // );
    // if (response.statusCode == 200) {
    var b = List<ProductModel>.from(response.map((e) => ProductModel.fromJson(e)));

      return b;
    // } else {
    //   throw ServerException();
    // }
  }
}
