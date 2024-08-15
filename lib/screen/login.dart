import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project/constan/screensize.dart';
import 'package:project/screen/home.dart';
import 'package:project/screen/register.dart';
import 'package:project/widgets/button.dart';
import 'package:project/widgets/height.dart';
import 'package:project/widgets/textInputFild.dart';
import 'package:project/widgets/textshow.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  late SharedPreferences sharedPreferences;
  String? log_status;
  bool isStudent = true;

  //validate login
  String? _validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Empty';
    }

    return null;
  }

  @override
  void initState() {
    initialization();
    super.initState();
  }

  initialization() async {
    sharedPreferences = await SharedPreferences.getInstance();
    log_status = sharedPreferences.getString('token');

    print(log_status);
    if (log_status != '') {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
    }
  }

  Future<void> _login() async {
    try {
      var url = Uri.parse(
          'https://festive-clarke.93-51-37-244.plesk.page/api/v1/login');
      var response = await http.post(
        url,
        headers: <String, String>{'Content-Type': 'application/json'},
        body: json.encode({
          'email': _controllerEmail.text,
          'password': _controllerPassword.text,
        }),
      );
      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        await sharedPreferences.setString('token', data['token']);
        if (data['user']['role'] == 'student') {
          await sharedPreferences.setBool('isStudent', true);
        } else {
          await sharedPreferences.setBool('isStudent', false);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login Successful')),
        );
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Home()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login Failed: ${response.body}')),
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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(ScreenUtil.screenWidth * 0.02),
        child: Center(
          child: Column(
            children: [
              TextShow(
                text: "Login",
                fontWeight: FontWeight.bold,
                value: 25,
              ),
              Height(height: 0.02),
              Textinput(
                controller: _controllerEmail,
                validator: _validate,
                hintText: "Email",
              ),
              Height(height: 0.02),
              Textinput(
                controller: _controllerPassword,
                validator: _validate,
                hintText: "Password",
              ),
              Height(height: 0.05),
              Button(
                  onPressed: () {
                    _login();
                  },
                  text: 'Login'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextShow(text: 'I don' 't have an account'),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Register()));
                      },
                      child: Text('Register'))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
