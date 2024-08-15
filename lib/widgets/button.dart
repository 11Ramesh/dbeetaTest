import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  VoidCallback onPressed;
  String text;
  final Color? backgroundColor;
  final Color? foregroundColor;

  Button(
      {required this.onPressed,
      required this.text,
      this.backgroundColor,
      this.foregroundColor,
      super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
