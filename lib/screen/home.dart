import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project/logic/calculation/calculation_bloc.dart';
import 'package:project/screen/HomeScreen/cource/course.dart';
import 'package:project/screen/HomeScreen/addCourse/addCourse.dart';
import 'package:project/screen/logout.dart';
import 'package:project/widgets/textshow.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late SharedPreferences sharedPreferences;
  late String token;
  String userName = '';
  String userEmail = '';
  String userEmailRole = '';
  final List<Widget> screens = [Course(), AddCourse()];
  int currentTab = 0;
  late CalculationBloc calculationBloc;
  bool? isStudent = false;

  @override
  void initState() {
    initialization();
    super.initState();
  }

  initialization() async {
    calculationBloc = BlocProvider.of<CalculationBloc>(context);
    sharedPreferences = await SharedPreferences.getInstance();
    token = sharedPreferences.getString('token').toString();
    isStudent = sharedPreferences.getBool('isStudent');

    _getUserDetails();
    calculationBloc.add(CoursesEvent(token));
  }

  Future<void> _getUserDetails() async {
    try {
      var url = Uri.parse(
          'https://festive-clarke.93-51-37-244.plesk.page/api/v1/user');
      var response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          userName = data['name'];
          userEmail = data['email'];
          userEmailRole = data['role'];
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed get user details: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: TextShow(
            text: 'My Application',
            value: 20,
            fontWeight: FontWeight.bold,
          ),
          actions: [
            IconButton(
                onPressed: () {
                  showLogoutDialog(context);
                },
                icon: Icon(Icons.login_rounded)),
          ]),
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              color: Colors.blue,
              child: const Text(
                'User Profile',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.person),
                      SizedBox(width: 20),
                      TextShow(text: userName),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.mail),
                      SizedBox(width: 20),
                      TextShow(text: userEmail),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.admin_panel_settings_rounded),
                      SizedBox(width: 20),
                      TextShow(text: userEmailRole),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: screens[currentTab],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            currentTab = index;
            if (currentTab == 0) {
              calculationBloc.add(CoursesEvent(token));
            } else if (currentTab == 1) {
              calculationBloc.add(CoursesEvent(token));
            }
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add',
          ),
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: currentTab,
      ),
    );
  }
}
