import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/material.dart';
import 'package:project/logic/calculation/calculation_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EnrollStudent extends StatefulWidget {
  const EnrollStudent({super.key});

  @override
  State<EnrollStudent> createState() => _EnrollStudentState();
}

class _EnrollStudentState extends State<EnrollStudent> {
  late CalculationBloc calculationBloc;
  late SharedPreferences? sharedPreferences;
  bool isStudent = false;
  String token = '';
  List enrollStudent = [];
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                calculationBloc.add(CoursesEvent(token));
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back)),
        ),
        body: BlocBuilder<CalculationBloc, CalculationState>(
          builder: (context, state) {
            if (state is EntrollStudentState) {
              enrollStudent = state.enrollStudent;
              return enrollStudent[0] == 'un'
                  ? Center(
                      child: Text("UnAuthorized Access"),
                    )
                  : ListView.builder(
                      itemCount: enrollStudent.length,
                      itemBuilder: (context, index) {
                        return Text("10");
                      },
                    );
            } else {
              return CircularProgressIndicator();
            }
          },
        ));
  }
}
