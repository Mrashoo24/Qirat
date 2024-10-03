import 'package:flutter/material.dart';

class CartCounter extends StatefulWidget {
  final int initialQuantity;
  final Function(int) onQuantityIncrease;
  final Function(int) onQuantityDecrease;
  final Color textColor;

  const CartCounter({
    Key? key,
    this.initialQuantity = 1,
    required this.onQuantityIncrease,
    required this.onQuantityDecrease,this.textColor = Colors.white
  }) : super(key: key);

  @override
  _CartCounterState createState() => _CartCounterState();
}

class _CartCounterState extends State<CartCounter> {
  late int quantity;

  @override
  void initState() {
    super.initState();
    quantity = widget.initialQuantity;
  }

  @override
  void didUpdateWidget(CartCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check if the initialQuantity has changed
    if (oldWidget.initialQuantity != widget.initialQuantity) {
      setState(() {
        quantity = widget.initialQuantity;
      });
    }
  }

  void _increaseQuantity() {
    setState(() {
      quantity++;
    });
    widget.onQuantityIncrease(quantity);
  }

  void _decreaseQuantity() {
    if (quantity > 0) {
      setState(() {
        quantity--;
      });
      widget.onQuantityDecrease(quantity);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildIconButton(Icons.remove, _decreaseQuantity),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            quantity.toString(),
            style:  TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: widget.textColor
            ),
          ),
        ),
        _buildIconButton(Icons.add, _increaseQuantity),
      ],
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black, // Background color
          borderRadius: BorderRadius.circular(8),
        ),
        width: 36,
        height: 36,
        child: Icon(
          icon,
          color: Colors.white, // Icon color
        ),
      ),
    );
  }
}
