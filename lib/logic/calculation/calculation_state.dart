part of 'calculation_bloc.dart';

@immutable
abstract class CalculationState {}

final class CalculationInitial extends CalculationState {}

class CoursesState extends CalculationState {
  List<dynamic> courses;

  CoursesState({required this.courses});
}

class CoursesDetailsState extends CalculationState {
  Map<String, dynamic> coursesDetails;

  CoursesDetailsState({required this.coursesDetails});
}

class SpecialCoursesDetailsState extends CalculationState {
  List<dynamic> coursesDetails;

  SpecialCoursesDetailsState({required this.coursesDetails});
}

class EntrollStudentState extends CalculationState {
  List<dynamic> enrollStudent;

  EntrollStudentState({required this.enrollStudent});
}

class lessonState extends CalculationState {
  List<dynamic> lesson;
  int mainid;

  lessonState({required this.lesson, required this.mainid});
}
