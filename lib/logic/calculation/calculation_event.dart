part of 'calculation_bloc.dart';

@immutable
abstract class CalculationEvent {}

class CoursesEvent extends CalculationEvent {
  String token;

  CoursesEvent(this.token);
}

class CoursesDetailsEvent extends CalculationEvent {
  int id;
  String token;

  CoursesDetailsEvent(this.token, this.id);
}

class SpecificCourseEvent extends CalculationEvent {
  int id;
  String token;

  SpecificCourseEvent(this.token, this.id);
}


class EntrollStudentEvent extends CalculationEvent {
  int id;
  String token;

  EntrollStudentEvent(this.token, this.id);
}

class lessonEvent extends CalculationEvent {
  int id;
  String token;

  lessonEvent(this.token, this.id);
}
