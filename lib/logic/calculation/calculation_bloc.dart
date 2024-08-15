import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:project/constan/api.dart';

part 'calculation_event.dart';
part 'calculation_state.dart';

class CalculationBloc extends Bloc<CalculationEvent, CalculationState> {
  CalculationBloc() : super(CalculationInitial()) {
    on<CalculationEvent>((event, emit) async {
      if (event is CoursesEvent) {
        String token = event.token;
        List<dynamic> _courses = [];

        final response = await http.get(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
        print(response.statusCode);
        if (response.statusCode == 200) {
          _courses = json.decode(response.body);
        } else {}
        emit(CoursesState(courses: _courses));

        //
      } else if (event is CoursesDetailsEvent) {
        String token = event.token;
        int id = event.id;
        late Map<String, dynamic> coursesDetails;
        final url1 = Uri.parse('$url/${id}/');

        try {
          final response = await http.get(
            url1,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          );

          if (response.statusCode == 200) {
            coursesDetails = json.decode(response.body);
          } else {
            print('object');
          }
        } catch (e) {}

        emit(CoursesDetailsState(coursesDetails: coursesDetails));
      }

      ///
      else if (event is SpecificCourseEvent) {
        String token = event.token;
        int id = event.id;
        late List coursesDetails;
        final url1 = Uri.parse('$url/${id}/lessons');

        try {
          final response = await http.get(
            url1,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          );

          if (response.statusCode == 200) {
            coursesDetails = json.decode(response.body);
          } else {
            print('object');
          }
        } catch (e) {}

        emit(SpecialCoursesDetailsState(coursesDetails: coursesDetails));
      } else if (event is EntrollStudentEvent) {
        int id = event.id;
        String token = event.token;
        List enrollStudent = [];

        final url1 = Uri.parse('$url/${id}/students');

        try {
          final response = await http.get(
            url1,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          );
          // print(response.statusCode);
          if (response.statusCode == 200) {
            enrollStudent = json.decode(response.body);
          } else if (response.statusCode == 403) {
            enrollStudent = ['un'];
          }
        } catch (e) {}
        emit(EntrollStudentState(enrollStudent: enrollStudent));
      } else if (event is lessonEvent) {
        int id = event.id;
        String token = event.token;
        List lesson = [];
        final url1 = Uri.parse('$url/${id}/lessons');

        try {
          final response = await http.get(
            url1,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          );
          print(response.statusCode);
          if (response.statusCode == 200) {
            lesson = json.decode(response.body);
          } else if (response.statusCode == 403) {}
        } catch (e) {}
        //print(lesson[0]['title']);
        emit(lessonState(lesson: lesson,mainid:id));
      }
    });
  }
}
