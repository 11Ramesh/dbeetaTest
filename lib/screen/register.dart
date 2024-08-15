import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project/constan/parttan.dart';
import 'package:project/constan/screensize.dart';
import 'package:project/screen/login.dart';
import 'package:project/widgets/button.dart';
import 'package:project/widgets/height.dart';
import 'package:project/widgets/textInputFild.dart';
import 'package:project/widgets/textshow.dart';
import 'package:http/http.dart' as http;

List<String> list = <String>['student', 'instructor'];

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _controllerUserName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  // final TextEditingController _controllerRole = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String dropdownValue = list.first;

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Empty';
    }

    final regExp = RegExp(emailpattern);

    if (!regExp.hasMatch(value)) {
      return 'Enter a valid email';
    }

    return null;
  }

  String? _validateUser(String? value) {
    if (value == null || value.isEmpty) {
      return 'Empty';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Empty';
    } else if (value.length < 8) {
      return 'Password character greter than 8';
    }

    return null;
  }

  Future<void> _register() async {
    try {
      var url = Uri.parse(
          'https://festive-clarke.93-51-37-244.plesk.page/api/v1/register');
      var response = await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            "name": _controllerUserName.text,
            "email": _controllerEmail.text,
            "password": _controllerPassword.text,
            "role": dropdownValue
          }));

      print(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Successfully Registered'),
          ),
        );
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Login()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Faild Registered'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$e'),
        ),
      );
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(ScreenUtil.screenHeight * 0.02),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextShow(
                  text: 'Register',
                  value: 25,
                  fontWeight: FontWeight.bold,
                ),
                Height(height: 0.03),
                Textinput(
                  controller: _controllerUserName,
                  validator: _validateUser,
                  hintText: 'User Name',
                ),
                Height(height: 0.01),
                Textinput(
                  controller: _controllerEmail,
                  validator: _validateEmail,
                  hintText: 'Email',
                ),
                Height(height: 0.01),
                Textinput(
                  controller: _controllerPassword,
                  validator: _validatePassword,
                  hintText: 'Password',
                ),
                Height(height: 0.01),
                Row(
                  children: [
                    TextShow(text: 'Choose you Role ?'),
                    SizedBox(
                      width: 10,
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: DropdownButton<String>(
                        value: dropdownValue,
                        icon: const Icon(Icons.arrow_downward),
                        elevation: 16,
                        style: const TextStyle(color: Colors.deepPurple),
                        onChanged: (String? value) {
                          // This is called when the user selects an item.
                          setState(() {
                            dropdownValue = value!;
                          });
                        },
                        items:
                            list.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                Height(height: 0.03),
                Button(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.validate();
                        _register();
                      }
                    },
                    text: 'Register')
              ],
            ),
          ),
        ),
      ),
    );
  }
}
