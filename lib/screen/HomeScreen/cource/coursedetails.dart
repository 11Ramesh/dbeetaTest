import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/logic/calculation/calculation_bloc.dart';
import 'package:project/screen/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

void showLessonDialog(
  BuildContext context,
) {
  late Map<String, dynamic> coursesDetails;
  late SharedPreferences sharedPreferences;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return BlocBuilder<CalculationBloc, CalculationState>(
        builder: (context, state) {
          if (state is CoursesDetailsState) {
            coursesDetails = state.coursesDetails;

            return AlertDialog(
              title: Column(
                children: [
                  Text(coursesDetails['category']),
                  Text(coursesDetails['title']),
                ],
              ),
              content: Text(coursesDetails['description']),
              actions: <Widget>[
                TextButton(
                  child: Text('ok'),
                  onPressed: () async {
                    sharedPreferences = await SharedPreferences.getInstance();
                  },
                ),
              ],
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      );
    },
  );
}
