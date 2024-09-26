import 'dart:convert';

import '../../../domain/entities/user/user.dart';
import '../../../domain/entities/user/delivery_info.dart';
import 'delivery_info_model.dart'; // Import DeliveryInfoModel

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel extends User {
  const UserModel({
    required String id,
    required String firstName,
    required String lastName,
    required String email,
    String? image,
    List<DeliveryInfoModel> deliveryInfos = const [], // Include deliveryInfos
  }) : super(
    id: id,
    firstName: firstName,
    lastName: lastName,
    email: email,
    image: image,
    deliveryInfos: deliveryInfos, // Assign deliveryInfos
  );

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json["_id"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    email: json["email"],
    image: json["image"],
    deliveryInfos: List<DeliveryInfoModel>.from(
      json["deliveryInfos"]?.map((x) => DeliveryInfoModel.fromJson(x)) ??
          [], // Parse deliveryInfos
    ),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "firstName": firstName,
    "lastName": lastName,
    "email": email,
    "image": image,
    "deliveryInfos": List<dynamic>.from(
        deliveryInfos.map((x) => (x as DeliveryInfoModel).toJson())), // Convert deliveryInfos to JSON
  };

  factory UserModel.fromEntity(User entity) => UserModel(
    id: entity.id,
    firstName: entity.firstName,
    lastName: entity.lastName,
    email: entity.email,
    image: entity.image,
    deliveryInfos: List<DeliveryInfoModel>.from(
      entity.deliveryInfos.map((e) => DeliveryInfoModel.fromEntity(e)),
    ),
  );
}
