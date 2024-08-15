import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/logic/calculation/calculation_bloc.dart';
import 'package:project/screen/login.dart';
import 'package:shared_preferences/shared_preferences.dart';late CalculationBloc calculationBloc;
 

void showSpecialCourseDialog(
    BuildContext context, Map<String, dynamic> coursesDetails) {
      
  showDialog(
    context: context,
    builder: (
      BuildContext context,
    ) {
      return AlertDialog(
        title: Text(coursesDetails['title']),
        content: Text(coursesDetails['content']),
      );
    },
  );
}
