import 'package:flutter/material.dart';

class Textinput extends StatelessWidget {
  Textinput(
      {required this.controller, this.validator, this.hintText, super.key});

  TextEditingController controller;
  final String? Function(String?)? validator;
  String? hintText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );
  }
}
