import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iraqibayt/modules/api/callApi.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  static const routeName = '/login';

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  _saveUserData(String pass, String name, String email) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'is_login';
    final value = "1";
    prefs.setString(key, value);

    final key2 = 'name';
    final value2 = name;
    prefs.setString(key2, value2);

    final key3 = 'pass';
    final value3 = pass;
    prefs.setString(key3, value3);

    final key4 = 'email';
    final value4 = email;
    prefs.setString(key4, value4);
  }

  void _handleLogin() async {
    setState(() {
      _isLoading = true;
    });
    var data = {
      'email': _emailController.text,
      'password': _passwordController.text,
    };

    var res = await CallApi().postData(data, '/login');
    var body = json.decode(res.body);
    print(body);
    setState(() {
      _isLoading = false;
    });
    if (body['success'] == true) {
      _saveUserData(
          _passwordController.text, body['user'].name, _emailController.text);
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  Widget loginButton() {
    return InkWell(
      onTap: _handleLogin,
      child: Container(
        height: 50,
        margin: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.indigo,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                alignment: Alignment.center,
                child: Text(_isLoading ? 'جاري التسجيل' : 'تسجيل الدخول',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: "CustomIcons",
                        fontWeight: FontWeight.w400)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        final height = MediaQuery.of(context).size.height;
        return Scaffold(
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: height * 0.1),
                  Image.asset("assets/images/logo.png"),
                  SizedBox(height: 40.0),
                  TextField(
                    decoration: InputDecoration(labelText: 'البريد الالكتروني'),
                    style: TextStyle(
                      fontFamily: 'CustomIcons',
                    ),
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'كلمة المرور'),
                    style: TextStyle(
                      fontFamily: 'CustomIcons',
                    ),
                    controller: _passwordController,
                    keyboardType: TextInputType.visiblePassword,
                  ),
                  loginButton(),
                  SizedBox(height: 20),
                  FlatButton(
                    color: Colors.white,
                    textColor: Colors.black,
                    disabledColor: Colors.grey,
                    disabledTextColor: Colors.grey,
                    padding: EdgeInsets.all(8.0),
                    splashColor: Colors.orange,
                    onPressed: _isLoading
                        ? null
                        : () {
                            Navigator.pushReplacementNamed(context, '/home');
                          },
                    child: Text(
                      'التسجيل لاحقاً',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                        fontFamily: "CustomIcons",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
