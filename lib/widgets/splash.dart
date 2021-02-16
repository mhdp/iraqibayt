import 'dart:io';
import 'package:flutter/material.dart';
import 'package:iraqibayt/modules/db_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  @override
  _Splash createState() => _Splash();
}

class _Splash extends State<Splash> {

  DatabaseHelper databaseHelper = new DatabaseHelper();

  check_login() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'is_login';
    final is_login_value = prefs.get(key) ?? 0;

    if (is_login_value == "1") {
      /*Navigator.of(context).push(
        new MaterialPageRoute(
            builder: (BuildContext context) => new Home()),
      );*/
      var userID = prefs.getInt('user_id');
      print('user id: ' + userID.toString());

      databaseHelper.updateFirebaseToken(userID).then((value) {
        //print(value);
        Navigator.pushReplacementNamed(context, '/home');
      });
    }else{
      Navigator.pushReplacementNamed(context, '/Welcome');
    }
    //print("is_login value: $is_login_value");
  }

  @override
  initState() {
    super.initState();
    // read();
    check_login();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF335876),

      body: Column(
          // mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Center(child: Image.asset("assets/images/logo_white-old.png")),
        Padding(
          padding: const EdgeInsets.only(top:20.0),
          child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),

          ),
        ),
      ]),
    );
  }
}