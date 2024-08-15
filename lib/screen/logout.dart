import 'package:flutter/material.dart';
import 'package:project/screen/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

void showLogoutDialog(BuildContext context) {
  late SharedPreferences sharedPreferences;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Log Out'),
        content: Text('Are you sure you want to log out?'),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
          TextButton(
            child: Text('Log Out'),
            onPressed: () async {
              sharedPreferences = await SharedPreferences.getInstance();

              await sharedPreferences.setString('token', '');
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Login()));
            },
          ),
        ],
      );
    },
  );
}

Future<void> _logOut() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('api_token');
}
