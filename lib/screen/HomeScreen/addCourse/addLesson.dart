import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/constan/api.dart';
import 'package:project/logic/calculation/calculation_bloc.dart';
import 'package:project/widgets/button.dart';
import 'package:project/widgets/textInputFild.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AddLesson extends StatefulWidget {
  AddLesson({required this.mainid, super.key});
  final int mainid;
  @override
  State<AddLesson> createState() => _AddLessonState(mainid: mainid);
}

class _AddLessonState extends State<AddLesson> {
  _AddLessonState({required this.mainid});
  final int mainid;
  SharedPreferences? sharedPreferences;
  bool isStudent = false;
  String token = '';
  final TextEditingController _controllerTitle = TextEditingController();
  final TextEditingController _controllerDescription = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<dynamic> lessons = [];

  late CalculationBloc calculationBloc;

  @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      token = sharedPreferences?.getString('token') ?? '';
      isStudent = sharedPreferences?.getBool('isStudent') ?? false;
    });
    calculationBloc = BlocProvider.of<CalculationBloc>(context);
  }

  String? _validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field cannot be empty';
    }
    return null;
  }

  Future<void> _createLesson() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final url1 = Uri.parse('$url/${mainid}/lessons');
    var response = await http.post(
      url1,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'title': _controllerTitle.text,
        'content': _controllerDescription.text,
      }),
    );
    //print(response.statusCode);

    if (response.statusCode == 201 || response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lesson created successfully')),
      );
      _controllerTitle.clear();
      _controllerDescription.clear();
      calculationBloc.add(lessonEvent(token, mainid));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create lesson')),
      );
    }
  }

  void deleteDialog(BuildContext context, int id) {
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
                _delete(id);

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _delete(int id) async {
    CalculationBloc calculationBloc = BlocProvider.of<CalculationBloc>(context);

    try {
      final url1 = Uri.parse(
          'https://festive-clarke.93-51-37-244.plesk.page/api/v1/lessons/${id}');
      final response = await http.delete(
        url1,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Add the token to the headers
        },
      );

      if (response.statusCode == 200) {
        calculationBloc.add(lessonEvent(token, mainid));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Course Deleted Successfully')),
        );
      } else {}
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Lesson"),
        leading: IconButton(
            onPressed: () {
              calculationBloc.add(CoursesEvent(token));
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: isStudent
          ? Center(child: Text('You are a student, not an instructor!'))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text('Add Lesson', style: TextStyle(fontSize: 20)),
                    SizedBox(height: 20),
                    Textinput(
                      controller: _controllerTitle,
                      hintText: 'Lesson Title',
                      validator: _validate,
                    ),
                    SizedBox(height: 20),
                    Textinput(
                      controller: _controllerDescription,
                      hintText: 'Lesson Description',
                      validator: _validate,
                    ),
                    SizedBox(height: 20),
                    Button(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      onPressed: () {
                        calculationBloc.add(lessonEvent(token, mainid));
                        _createLesson();
                      },
                      text: "Create",
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: BlocBuilder<CalculationBloc, CalculationState>(
                        builder: (context, state) {
                          if (state is lessonState) {
                            lessons = state.lesson;
                            int mainid = state.mainid;
                            print(mainid);

                            if (lessons.isEmpty) {
                              return Center(
                                  child: Text('No lessons available'));
                            }

                            return ListView.builder(
                              itemCount: lessons.length,
                              itemBuilder: (context, index) {
                                final lesson = lessons[index];
                                return ListTile(
                                  title: Text(lesson['title']),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(lesson['content']),
                                      Row(
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              // Edit logic here
                                            },
                                            child: Text("Edit"),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              deleteDialog(
                                                  context, lesson['id']);
                                            },
                                            child: Text("Delete"),
                                          ),
                                        ],
                                      ),
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
