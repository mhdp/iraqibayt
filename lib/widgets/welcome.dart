import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:iraqibayt/modules/api/callApi.dart';
import 'package:iraqibayt/modules/db_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

DatabaseHelper databaseHelper = new DatabaseHelper();

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

final fbLogin = FacebookLogin();

class Welcome extends StatefulWidget {
  @override
  _Welcome createState() => _Welcome();
}

class _Welcome extends State<Welcome> {
  static const routeName = '/';

  Future<String> signInWithGoogle() async {
    await Firebase.initializeApp();

    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential authResult =
        await _auth.signInWithCredential(credential);
    final User user = authResult.user;

    if (user != null) {
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final User currentUser = _auth.currentUser;
      assert(user.uid == currentUser.uid);

      print('signInWithGoogle succeeded: $user');

      var data = {
        'name': user.displayName,
        'email': user.email,
      };

      var res = await CallApi().postData(data, '/facebook_login');
      var body = json.decode(res.body);
      print(body);

      _save_login_info(user.uid, user.displayName, user.email);

      Navigator.pushReplacementNamed(context, '/home');

      //return '$user';
    }

    return null;
  }

  _save_login_info(String pass, String name, String email) async {
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

  void signOutGoogle() async {
    await googleSignIn.signOut();

    print("User Sign Out");
  }

  Future signInFB() async {
    final FacebookLoginResult result = await fbLogin.logIn(["email"]);
    print(result.accessToken);
    final String token = result.accessToken.token;
    final response = await http.get(
        'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${token}');
    final profile = jsonDecode(response.body);
    print(profile);

    var data = {
      'name': profile["name"],
      'email': profile["email"],
    };

    var res = await CallApi().postData(data, '/facebook_login');
    var body = json.decode(res.body);
    print(body);

    _save_login_info(profile["id"], profile["name"], profile["email"]);

    Navigator.pushReplacementNamed(context, '/home');
  }

  check_login() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'is_login';
    final is_login_value = prefs.get(key) ?? 0;

    if (is_login_value == "1") {
      /*Navigator.of(context).push(
        new MaterialPageRoute(
            builder: (BuildContext context) => new Home()),
      );*/
      Navigator.pushReplacementNamed(context, '/home');
    }
    print("is_login value: $is_login_value");
  }

  Widget _facebookButton() {
    return InkWell(
      onTap: signInFB,
      child: Container(
        height: 50,
        margin: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xff1959a9),
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(5),
                      topRight: Radius.circular(5)),
                ),
                alignment: Alignment.center,
                child: Icon(
                  FontAwesomeIcons.facebook,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xdd1959a9),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(5),
                      topLeft: Radius.circular(5)),
                ),
                alignment: Alignment.center,
                child: Text(' الإستمرار بإستخدام فيسبوك',
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

  Widget _appleButton() {
    return InkWell(
      //onTap: appleLogIn,
      child: Container(
        height: 50,
        margin: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xff000000),
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(5),
                      topRight: Radius.circular(5)),
                ),
                alignment: Alignment.center,
                child: Icon(
                  FontAwesomeIcons.apple,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xdd000000),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(5),
                      topLeft: Radius.circular(5)),
                ),
                alignment: Alignment.center,
                child: Text(' الإستمرار بإستخدام أبل',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "CustomIcons",
                        fontSize: 18,
                        fontWeight: FontWeight.w400)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _googleButton() {
    return InkWell(
        onTap: signInWithGoogle,
        child: Container(
          height: 50,
          margin: EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xffdc3400),
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(5),
                        topRight: Radius.circular(5)),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    FontAwesomeIcons.google,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xdddc3400),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(5),
                        topLeft: Radius.circular(5)),
                  ),
                  alignment: Alignment.center,
                  child: Text('الاستمرار باستخدام جوجل',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: "CustomIcons",
                          fontSize: 18,
                          fontWeight: FontWeight.w400)),
                ),
              ),
            ],
          ),
        ));
  }

  Widget new_account_button(BuildContext context) {
    return InkWell(
      onTap: () => {Navigator.pushReplacementNamed(context, '/register')},
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
                child: Text(' إنشاء حساب / تسجيل الدخول',
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
  initState() {
    super.initState();
    // read();
    check_login();
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
                  //_title(),
                  Image.asset("assets/images/logo.png"),
                  SizedBox(height: 40.0),
                  _facebookButton(),
                  _googleButton(),
                  //android_or_ios(),
                  Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 30.0),
                      child: Row(children: <Widget>[
                        Expanded(
                            child: Divider(
                          color: Colors.black,
                          thickness: 1,
                        )),
                        Text(
                          "  أو  ",
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.black,
                            fontFamily: "CustomIcons",
                          ),
                        ),
                        Expanded(
                            child: Divider(
                          color: Colors.black,
                          thickness: 1,
                        )),
                      ])),
                  new_account_button(context),
                  SizedBox(height: 20),

                  FlatButton(
                    color: Colors.white,
                    textColor: Colors.black,
                    disabledColor: Colors.grey,
                    disabledTextColor: Colors.grey,
                    padding: EdgeInsets.all(8.0),
                    splashColor: Colors.orange,
                    onPressed: () {
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

  android_or_ios() {
    if (Platform.isIOS) {
      return _appleButton();
    } else if (Platform.isAndroid) {
      return null;
    }
  }
}
