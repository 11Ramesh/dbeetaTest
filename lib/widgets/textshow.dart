import 'package:flutter/material.dart';

class TextShow extends StatelessWidget {
  TextShow({required this.text, this.value, this.fontWeight, super.key});
  String text;
  double? value;
  FontWeight? fontWeight;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: value, fontWeight: fontWeight),
    );
  }
}
