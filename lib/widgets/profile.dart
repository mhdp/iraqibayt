import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:getwidget/getwidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iraqibayt/modules/api/callApi.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController _usernameController;
  TextEditingController _emailController;
  TextEditingController _passwordController;
  TextEditingController _newPasswordController;

  String _username;
  String _password;
  String _newPassword;
  String _email;

  var _guest = false;
  bool _isLoading = false;

  _checkIfGuest() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'is_login';
    final value = prefs.get(key);
    print('$value');
    if (value != '1') {
      setState(() {
        _guest = true;
        _username = 'زائر';
      });
    } else {
      final key = 'name';
      final value = prefs.get(key);
      setState(() {
        _username = value;
      });
    }
  }

  _getUserdata() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'is_login';
    final value = prefs.get(key);
    print('$value');
    if (value == '1') {
      final key = 'name';
      final key2 = 'email';
      final key3 = 'pass';
      final value = prefs.get(key);
      print(value);
      final value2 = prefs.get(key2);
      print(value2);
      final value3 = prefs.get(key3);
      print(value3);
      setState(() {
        _username = value;
        _email = value2;
        _password = value3;

        _usernameController.text = _username;
        _emailController.text = _email;
        _passwordController.text = _password;
      });
    }
  }

  _updatePrefs(String pass, String newPass, String name) async {
    final prefs = await SharedPreferences.getInstance();

    final key2 = 'name';
    final value2 = name;
    prefs.setString(key2, value2);

    if (newPass.isEmpty) {
      final key3 = 'pass';
      final value3 = pass;
      prefs.setString(key3, value3);
    } else {
      final key3 = 'pass';
      final value3 = newPass;
      prefs.setString(key3, value3);
    }
  }

  void _submitUserData() async {
    final _usernameInput = _usernameController.text;
    final _newPassInput = _newPasswordController.text;
    if (_usernameInput.isNotEmpty)
      _updatePrefs(_password, _newPassInput, _usernameInput);

    setState(() {
      _isLoading = true;
    });
    var data = {
      'name': _usernameInput,
      'email': _email,
      'password': _password,
      'new_password': _newPassInput,
    };

    if (_usernameInput.isNotEmpty) {
      var res = await CallApi().postData(data, '/users/update');
      var body = json.decode(res.body);
      print(body);

      if (body != 1) _updatePrefs(_password, _newPassInput, _usernameInput);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _newPasswordController = TextEditingController();

    _checkIfGuest();
    _getUserdata();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'الملف الشخصي',
          style: TextStyle(
            fontFamily: "CustomIcons",
          ),
        ),
        backgroundColor: Color(0xff275879),
      ),
      body: LayoutBuilder(
        builder: (ctx, constraints) {
          if (_guest) {
            return Row(
              children: [
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(4.0),
                    onTap: () {},
                    child: Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.grey, width: 0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      clipBehavior: Clip.antiAlias,
                      margin: const EdgeInsets.all(10.0),
                      //color: Colors.grey,
                      elevation: 0,

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(0),
                            child: Container(
                              padding: const EdgeInsets.all(3.0),
                              color: Color(0xff275879),
                              child: Text(
                                'معلومات المستخدم',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontFamily: "CustomIcons",
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Text(
                                            'الرجاء تسجيل الدخول لعرض معلومات الحساب',
                                            style: TextStyle(
                                              fontFamily: 'CustomIcons',
                                            ),
                                          ),
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
                                                    Navigator
                                                        .pushReplacementNamed(
                                                            context, '/');
                                                  },
                                            child: Text(
                                              'تسجيل الدخول',
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
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Row(
              children: [
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(4.0),
                    onTap: () {},
                    child: SingleChildScrollView(
                      child: Card(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.grey, width: 0.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        clipBehavior: Clip.antiAlias,
                        margin: const EdgeInsets.all(10.0),
                        //color: Colors.grey,
                        elevation: 0,

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(0),
                              child: Container(
                                padding: const EdgeInsets.all(3.0),
                                color: Color(0xff275879),
                                child: Text(
                                  'معلومات المستخدم',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontFamily: "CustomIcons",
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    top: 10.0),
                                                child: Text(
                                                  'الاسم',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontFamily: "CustomIcons",
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                child: TextFormField(
                                                  textAlign: TextAlign.center,
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        const EdgeInsets
                                                                .symmetric(
                                                            horizontal: 5.0),
                                                    fillColor: Colors.white,
                                                    border:
                                                        new OutlineInputBorder(
                                                      borderRadius:
                                                          new BorderRadius
                                                              .circular(5.0),
                                                      borderSide:
                                                          new BorderSide(),
                                                    ),
                                                  ),
                                                  controller:
                                                      _usernameController,
                                                  onChanged: null,
                                                ),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    top: 15.0),
                                                child: Text(
                                                  'البريد الالكتروني',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontFamily: "CustomIcons",
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                child: TextFormField(
                                                  textAlign: TextAlign.center,
                                                  enabled: false,
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        const EdgeInsets
                                                                .symmetric(
                                                            horizontal: 5.0),
                                                    fillColor: Colors.white,
                                                    border:
                                                        new OutlineInputBorder(
                                                      borderRadius:
                                                          new BorderRadius
                                                              .circular(5.0),
                                                      borderSide:
                                                          new BorderSide(),
                                                    ),
                                                  ),
                                                  controller: _emailController,
                                                  onChanged: null,
                                                ),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    top: 15.0),
                                                child: Text(
                                                  'كلمة المرور',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontFamily: "CustomIcons",
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                child: TextFormField(
                                                  textAlign: TextAlign.center,
                                                  enabled: false,
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        const EdgeInsets
                                                                .symmetric(
                                                            horizontal: 5.0),
                                                    fillColor: Colors.white,
                                                    border:
                                                        new OutlineInputBorder(
                                                      borderRadius:
                                                          new BorderRadius
                                                              .circular(5.0),
                                                      borderSide:
                                                          new BorderSide(),
                                                    ),
                                                  ),
                                                  controller:
                                                      _passwordController,
                                                  obscureText: true,
                                                  onChanged: null,
                                                ),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    top: 15.0),
                                                child: Text(
                                                  'تأكيد كلمة المرور',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontFamily: "CustomIcons",
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                child: TextFormField(
                                                  textAlign: TextAlign.center,
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        'اترك الحقل فارغاً في حال لم ترغب بتغيير كلمة المرور',
                                                    hintStyle: TextStyle(
                                                        fontSize: 16.0,
                                                        fontFamily:
                                                            'CustomIcons'),
                                                    contentPadding:
                                                        const EdgeInsets
                                                                .symmetric(
                                                            horizontal: 5.0),
                                                    fillColor: Colors.white,
                                                    border:
                                                        new OutlineInputBorder(
                                                      borderRadius:
                                                          new BorderRadius
                                                              .circular(5.0),
                                                      borderSide:
                                                          new BorderSide(),
                                                    ),
                                                  ),
                                                  controller:
                                                      _newPasswordController,
                                                  obscureText: true,
                                                  onChanged: null,
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5.0),
                                                margin: const EdgeInsets.only(
                                                    top: 25.0),
                                                child: GFButton(
                                                  onPressed: _submitUserData,
                                                  text: _isLoading
                                                      ? "جاري الحفظ"
                                                      : 'حفظ المعلومات',
                                                  textStyle: TextStyle(
                                                      fontSize: 18.0,
                                                      fontFamily:
                                                          'CustomIcons'),
                                                  blockButton: true,
                                                  color: Color(0xff65AECA),
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}