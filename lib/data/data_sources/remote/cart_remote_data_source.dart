import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eshop/data/firebase/firebase_services.dart';

import '../../../../core/error/exceptions.dart';
import '../../models/cart/cart_item_model.dart';

abstract class CartRemoteDataSource {
  Future<CartItemModel> addToCart(CartItemModel cartItem, String token);
  Future<CartItemModel> deleteCart(CartItemModel cartItem, String token);
  Future<List<CartItemModel>> syncCart(List<CartItemModel> cart, String token);
  Future<List<CartItemModel>> getCart(String token);
}

class CartRemoteDataSourceSourceImpl implements CartRemoteDataSource {
  final FirebaseService client;
  CartRemoteDataSourceSourceImpl({required this.client});

  @override
  Future<CartItemModel> addToCart(CartItemModel cartItem, String token) async {
    try {
      await client.setDocument(
          collectionPath: "cartlist",
          documentId: cartItem.id,
          data: cartItem.toBodyJson());

      return cartItem;
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<CartItemModel> deleteCart(CartItemModel cartItem, String token) async {
    try {
      await client.deleteDocument(
        collectionPath: "cartlist",
        documentId: cartItem.id.toString(),
      );

      return cartItem;
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<List<CartItemModel>> syncCart(
      List<CartItemModel> cart, String token) async {
    final WriteBatch batch = FirebaseFirestore.instance.batch();
    bool success = true;

    try {
      for (var element in cart) {
        // Use a stable document id. Fallback to derived id if missing
        final String docId = (element.id == null || element.id!.isEmpty)
            ? element.getCartId(token, element.product.id, element.priceTag.id)
            : element.id!;

        final DocumentReference docRef =
            FirebaseFirestore.instance.collection("cartlist").doc(docId);

        // Firestore requires Map<String,dynamic> data, not a model instance
        batch.set(docRef, element.toBodyJson(), SetOptions(merge: true));
      }

      // Commit the batch. If any operation fails, nothing will be committed.
      await batch.commit();
    } catch (e) {
      success = false;
      print("Error during batch commit: $e");
      // If the batch fails, handle rollback or other necessary actions
    }

    if (success) {
      print("All documents successfully written!");
      var list = cart;
      return list;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<CartItemModel>> getCart(String token) async {
    List<Map<String, dynamic>> val = await client.getAllDocuments(
        collectionPath: "cartlist", isEqualTowhereConditions: {"uid": token});

    return cartItemModelListFromRemoteJson(val);
  }
}
