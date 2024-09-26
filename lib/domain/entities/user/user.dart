import 'package:equatable/equatable.dart';
import '../../../data/models/user/delivery_info_model.dart';
import 'delivery_info.dart'; // Import the DeliveryInfo entity

class User extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String? image;
  final String email;
  final List<DeliveryInfoModel> deliveryInfos; // Add list of DeliveryInfo

  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.image,
    required this.email,
    this.deliveryInfos = const [], // Default empty list
  });

  @override
  List<Object?> get props => [
    id,
    firstName,
    lastName,
    email,
    deliveryInfos, // Include deliveryInfos in the props list
  ];
}
