import '../../domain/entities/cart/cart_item.dart';

class CartCalculator {
  static double getTotal(List<CartItem> cart) {
    var subtotal = cart.fold(
        0.0,
        (previousValue, element) =>
            ((element.priceTag.price * element.quantity) + previousValue));

    return subtotal;
  }

  static double getTotalWithoutTax(double subtotal) {
    var totalWithoutTax = subtotal / 1.18; // Divide by 1.18 to subtract 18% GST
    return subtotal - totalWithoutTax;
  }

}
