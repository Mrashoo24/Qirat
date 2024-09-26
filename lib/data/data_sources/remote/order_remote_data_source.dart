import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eshop/core/error/failures.dart';
import 'package:eshop/data/firebase/firebase_services.dart';
import 'package:eshop/data/models/order/order_item_model.dart';
import 'package:eshop/data/models/user/delivery_info_model.dart';
import 'package:http/http.dart' as http;

import '../../../../core/error/exceptions.dart';
import '../../../core/constant/strings.dart';
import '../../models/order/order_details_model.dart';

abstract class OrderRemoteDataSource {
  Future<OrderDetailsModel> addOrder(OrderDetailsModel params, String token);
  Future<List<OrderDetailsModel>> getOrders(String token);
}

class OrderRemoteDataSourceSourceImpl implements OrderRemoteDataSource {
  final FirebaseService client;
  OrderRemoteDataSourceSourceImpl({required this.client});

  @override
  Future<OrderDetailsModel> addOrder(params, token) async {
    try {
      var id = await client.setDocument(
          collectionPath: "orders", data: params.toJson());

      var newParam = OrderDetailsModel(
          id: id!,
          orderItems: params.orderItems
              .map((e) => OrderItemModel.fromEntity(e))
              .toList(),
          deliveryInfo: DeliveryInfoModel.fromEntity(params.deliveryInfo),
          discount: params.discount,
          uid: params.uid,
          total: params.total,
          status: params.status,
          info: params.info);

      await client.setDocument(
          collectionPath: "orders", data: newParam.toJson(), documentId: id);
      return params;
    } catch (e) {
      throw ServerException();
    }
    //
    // final response = await client.post(
    //   Uri.parse('$baseUrl/orders'),
    //   headers: {
    //     'Content-Type': 'application/json',
    //     'Authorization': 'Bearer $token',
    //   },
    //   body: orderDetailsModelToJson(params),
    // );
    // if (response.statusCode == 200) {
    //   return orderDetailsModelFromJson(response.body);
    // } else {
    //   throw ServerException();
    // }
  }

  @override
  Future<List<OrderDetailsModel>> getOrders(String token) async {
    try{
      // var docs = await client.getAllDocuments(
      //     collectionPath: "orders", arrayWhereConditions: {"uid": token});

     var check = await FirebaseFirestore.instance.collection("orders").where("uid",isEqualTo: token).get();


      var listOrders = check.docs.map((e) => OrderDetailsModel.fromJson(e.data())).toList();

      return listOrders;
    }catch(e){
      throw ServerFailure();
    }

    // final response = await client.get(
    //   Uri.parse('$baseUrl/orders'),
    //   headers: {
    //     'Content-Type': 'application/json',
    //     'Authorization': 'Bearer $token',
    //   },
    // );
    // if (response.statusCode == 200) {
    //   return orderDetailsModelListFromJson(response.body);
    // } else {
    throw ServerFailure();
    // }
  }
}
