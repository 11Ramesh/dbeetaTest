import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/constan/api.dart';
import 'package:project/constan/screensize.dart';
import 'package:project/logic/calculation/calculation_bloc.dart';
import 'package:project/screen/HomeScreen/addCourse/addLesson.dart';
import 'package:project/screen/HomeScreen/addCourse/deleteCourse.dart';
import 'package:project/screen/HomeScreen/addCourse/enrollStudent.dart';
import 'package:project/screen/HomeScreen/cource/course.dart';
import 'package:project/widgets/button.dart';
import 'package:project/widgets/height.dart';
import 'package:project/widgets/textInputFild.dart';
import 'package:project/widgets/textshow.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AddCourse extends StatefulWidget {
  const AddCourse({super.key});

  @override
  State<AddCourse> createState() => _AddCourseState();
}

class _AddCourseState extends State<AddCourse> {
  SharedPreferences? sharedPreferences;
  bool isStudent = false;
  String token = '';
  final TextEditingController _controllerTitle = TextEditingController();

  final TextEditingController _controllerDescription = TextEditingController();
  List<String> courses = ['Flutter', 'Laravel'];
  String? selectedCourse;
  List<dynamic> _courses = [];
  late CalculationBloc calculationBloc;

  String? _validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Empty';
    }

    return null;
  }

  @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    calculationBloc = BlocProvider.of<CalculationBloc>(context);
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      token = sharedPreferences?.getString('token') ?? '';
      isStudent = sharedPreferences?.getBool('isStudent') ?? false;
    });
  }

  Future<void> _createCourse() async {
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Add the token to the headers
      },
      body: json.encode({
        'title': _controllerTitle.text,
        'category': selectedCourse,
        'description': _controllerDescription.text,
      }),
    );
    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Course Created Successfully')),
      );

      _controllerTitle.clear();
      _controllerDescription.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isStudent
          ? Center(
              child: Column(
                children: [
                  Height(height: 0.4),
                  TextShow(
                    text: 'Welcome Student!',
                    fontWeight: FontWeight.bold,
                  ),
                  TextShow(
                    text: 'This Page Only Visible For Admins',
                  ),
                ],
              ),
            )
          : Padding(
              padding: EdgeInsets.all(ScreenUtil.screenWidth * 0.02),
              child: Form(
                child: Column(
                  children: [
                    TextShow(
                      text: 'Course Add',
                      fontWeight: FontWeight.bold,
                      value: 20,
                    ),
                    Height(height: 0.04),
                    Textinput(
                      controller: _controllerTitle,
                      hintText: 'Course Title',
                      validator: _validate,
                    ),
                    Height(height: 0.02),
                    DropdownButton<String>(
                      value: selectedCourse,
                      hint: Text('Choose a course'),
                      isExpanded: true,
                      items: courses.map((String course) {
                        return DropdownMenuItem<String>(
                          value: course,
                          child: Text(course),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedCourse = newValue;
                        });
                      },
                    ),
                    Height(height: 0.02),
                    Textinput(
                      controller: _controllerDescription,
                      hintText: 'Course description',
                      validator: _validate,
                    ),
                    Height(height: 0.05),
                    Button(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      onPressed: () {
                        _createCourse();
                        calculationBloc.add(CoursesEvent(token));
                      },
                      text: "Create",
                    ),
                    Expanded(
                      child: BlocBuilder<CalculationBloc, CalculationState>(
                        builder: (context, state) {
                          if (state is CoursesState) {
                            final courses = state.courses;
                            return ListView.builder(
                              itemCount: courses.length,
                              itemBuilder: (context, index) {
                                final course = courses[index];
                                return ListTile(
                                  // tileColor: Colors.grey,
                                  subtitle: Column(
                                    children: [
                                      Text(course['title']),
                                      Row(
                                        children: [
                                          TextButton(
                                              onPressed: () {},
                                              child: Text("Edit")),
                                          TextButton(
                                              onPressed: () {
                                                deleteDialog(context,
                                                    course['id'], token);
                                              },
                                              child: Text("Delete")),
                                          TextButton(
                                              onPressed: () {
                                                calculationBloc.add(
                                                    EntrollStudentEvent(
                                                        token, course['id']));
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            EnrollStudent()));
                                              },
                                              child: Text("Enroll Student")),
                                          TextButton(
                                              onPressed: () {
                                                calculationBloc.add(lessonEvent(
                                                    token, course['id']));
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            AddLesson(
                                                                mainid: course[
                                                                    'id'])));
                                              },
                                              child: Text("Add Lesson")),
                                        ],
                                      ),
                                    ],
                                  ),
                                  title: Column(
                                    children: [
                                      Text(course['category']),
                                    ],
                                  ),
                                );
                              },
                            );
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
