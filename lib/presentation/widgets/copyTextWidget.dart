import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For Clipboard functionality

class CopyableTextWidget extends StatelessWidget {
  final String text;

  const CopyableTextWidget({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        Clipboard.setData(ClipboardData(text: text)); // Copy text to clipboard
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Copied to clipboard')),
        );
      },
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
        ),
      ),
    );
  }
}
