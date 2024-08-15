import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/constan/api.dart';
import 'package:project/logic/calculation/calculation_bloc.dart';
import 'package:project/screen/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

void deleteDialog(BuildContext context, int id, String token) {
  late SharedPreferences sharedPreferences;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Delete'),
        content: Text('Are you sure you want to Delete the Record?'),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
          TextButton(
            child: Text('Delete'),
            onPressed: () async {
              sharedPreferences = await SharedPreferences.getInstance();
              _delete(id, context, token);

              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<void> _delete(int id, BuildContext context, String token) async {
  CalculationBloc calculationBloc = BlocProvider.of<CalculationBloc>(context);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');
  print(id);

  print(token);

  try {
    final url1 = Uri.parse(
        'https://festive-clarke.93-51-37-244.plesk.page/api/v1/courses/$id');
    final response = await http.delete(
      url1,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Add the token to the headers
      },
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      calculationBloc.add(CoursesEvent(token.toString()));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Course Deleted Successfully')),
      );
    } else {}
  } catch (e) {}
}
