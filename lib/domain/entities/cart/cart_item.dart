import 'package:equatable/equatable.dart';

import '../product/price_tag.dart';
import '../product/product.dart';

class CartItem extends Equatable {
  final String? id;
  final Product product;
  final PriceTag priceTag;
  final int quantity ;
  final double? total;
  final  String uid;

  const CartItem({this.id, required this.product, required this.priceTag,this.total,required this.quantity,required this.uid});

  @override
  List<Object?> get props => [id];
}
