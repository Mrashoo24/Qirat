import 'package:equatable/equatable.dart';

import '../user/delivery_info.dart';
import 'order_item.dart';

class OrderDetails extends Equatable {
  final String id;
  final List<OrderItem> orderItems;
  final DeliveryInfo deliveryInfo;
  final num discount;
  final String uid;
  final double total;
  final String status;
  final String info;

  const OrderDetails({
    required this.id,
    required this.orderItems,
    required this.deliveryInfo,
    required this.discount,
    required this.uid, required this.total,required this.status,required this.info,
  });

  @override
  List<Object> get props => [
        id,
      ];
}
