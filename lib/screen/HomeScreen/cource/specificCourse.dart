import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/logic/calculation/calculation_bloc.dart';
import 'package:project/screen/HomeScreen/cource/specificcourseDetails.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SpecialCourse extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}



class _HomeScreenState extends State<SpecialCourse> {
  
 late CalculationBloc calculationBloc;
 SharedPreferences? sharedPreferences;
 String token = '';
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
          if (state is SpecialCoursesDetailsState) {
            List coursesDetails = state.coursesDetails;
            return ListView.builder(
              itemCount: coursesDetails.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.label),
                  title: Text(coursesDetails[index]['title']),

                  /// subtitle: Text(''),
                  onTap: () {
                    showSpecialCourseDialog(context,coursesDetails[index]);
                  },
                );
              },
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
