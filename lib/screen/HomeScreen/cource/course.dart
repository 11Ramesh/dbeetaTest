import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/constan/api.dart';
import 'package:project/constan/screensize.dart';
import 'package:project/logic/calculation/calculation_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:project/screen/HomeScreen/cource/coursedetails.dart';

import 'package:project/screen/HomeScreen/cource/specificCourse.dart';
import 'package:project/widgets/button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Course extends StatefulWidget {
  const Course({super.key});

  @override
  State<Course> createState() => _CourseState();
}

class _CourseState extends State<Course> {
  List<dynamic> _courses = [];
  late CalculationBloc calculationBloc;
  late SharedPreferences sharedPreferences;
  late String token;

  void initState() {
    initialization();
    super.initState();
  }

  initialization() async {
    calculationBloc = BlocProvider.of<CalculationBloc>(context);
    sharedPreferences = await SharedPreferences.getInstance();
    token = sharedPreferences.getString('token').toString();
  }

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(ScreenUtil.screenWidth * 0.02),
      child: Scaffold(
        body: BlocBuilder<CalculationBloc, CalculationState>(
          builder: (context, state) {
            if (state is CoursesState) {
              _courses = state.courses;
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10),
                itemCount: _courses.length,
                itemBuilder: (context, index) {
                  return GridTile(
                    header: Container(
                      padding: EdgeInsets.all(8),
                      color: Colors.grey[300],
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          _courses[index]['category'],
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    footer: Container(
                      padding: EdgeInsets.all(8),
                      color: Colors.grey[300],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Button(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              onPressed: () {
                                calculationBloc.add(CoursesDetailsEvent(
                                    token, _courses[index]['id']));
                                showLessonDialog(context);
                              },
                              text: 'view'),
                          Button(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              onPressed: () {
                                calculationBloc.add(SpecificCourseEvent(
                                    token, _courses[index]['id']));
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SpecialCourse()));
                              },
                              text: 'Lesson')
                        ],
                      ),
                    ),
                    child: Container(
                      color: Colors.grey[300],
                      child: Center(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            _courses[index]['title'],
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
