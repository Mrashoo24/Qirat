import 'package:eshop/core/error/failures.dart';
import '../../../core/constant/strings.dart';
import '../../firebase/firebase_services.dart';
import '../../models/category/category_model.dart';

abstract class CategoryRemoteDataSource {
  Future<List<CategoryModel>> getCategories();
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final FirebaseService client;
  CategoryRemoteDataSourceImpl({required this.client});

  @override
  Future<List<CategoryModel>> getCategories() =>
      _getCategoryFromUrl('$baseUrl/categories');

  Future<List<CategoryModel>> _getCategoryFromUrl(String url) async {

    final response = await client.getAllDocuments(collectionPath: "categories",);


      return List<CategoryModel>.from(response.map((e) => CategoryModel.fromJson(e)));

  }
}
