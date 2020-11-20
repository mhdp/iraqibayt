import 'dart:convert';
import 'dart:io';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:iraqibayt/modules/api/callApi.dart';
import 'package:iraqibayt/modules/db_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:apple_sign_in/apple_sign_in.dart';


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
  int form = 0;

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
        'id': user.uid,
      };

      var res = await CallApi().postData(data, '/facebook_login');
      var body = json.decode(res.body);
      print(body);

      if (body['success'] == true) {
        _save_login_info(body['user']["id"], user.uid, user.displayName,
            user.email, body['user']["customToken"]);

        Navigator.pushReplacementNamed(context, '/home');
      }

      //return '$user';
    }

    return null;
  }

  _save_login_info(int userId, String pass, String name, String email, String token) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'is_login';
    final value = "1";
    prefs.setString(key, value);

    final key1 = 'user_id';
    final value1 = userId;
    prefs.setInt(key1, value1);

    final key2 = 'name';
    final value2 = name;
    prefs.setString(key2, value2);

    final key3 = 'pass';
    final value3 = pass;
    prefs.setString(key3, value3);

    final key4 = 'email';
    final value4 = email;
    prefs.setString(key4, value4);

    final key5 = 'token';
    final value5 = token;
    prefs.setString(key5, value5);
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
      'id': profile["id"],
    };

    var res = await CallApi().postData(data, '/facebook_login');
    var body = json.decode(res.body);
    print(body);

    if (body['success'] == true) {
      _save_login_info(body['user']['id'], profile["id"], profile["name"],
          profile["email"], body['user']["customToken"]);

      Navigator.pushReplacementNamed(context, '/home');
    }
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
                  //color: Color(0xff1959a9),
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(5),
                      topRight: Radius.circular(5)),
                ),
                alignment: Alignment.center,
                child: Icon(
                  FontAwesomeIcons.facebook,
                  color: Color(0xff1959a9),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                decoration: BoxDecoration(
                  //color: Color(0xdd1959a9),
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(5),
                      topLeft: Radius.circular(5)),
                ),
                alignment: Alignment.center,
                child: Text(' الإستمرار بإستخدام فيسبوك',
                    style: TextStyle(
                        color: Color(0xff1959a9),
                        fontSize: 18,
                        fontFamily: "CustomIcons",
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _appleButton() {
    return InkWell(
      onTap: appleLogIn,
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
                  color: Color(0xfffffeee),
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(5),
                      topRight: Radius.circular(5)),
                ),
                alignment: Alignment.center,
                child: Icon(
                  FontAwesomeIcons.apple,
                  color: Colors.black,
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xddffffff),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(5),
                      topLeft: Radius.circular(5)),
                ),
                alignment: Alignment.center,
                child: Text(' الإستمرار بإستخدام أبل',
                    style: TextStyle(
                        color: Colors.black,
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

  appleLogIn() async {
    //print('dd');
    if(await AppleSignIn.isAvailable()) {
      final AuthorizationResult result = await AppleSignIn.performRequests([
        AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
      ]);
      switch (result.status) {
        case AuthorizationStatus.authorized:
          print(result.credential.email);//All the required credentials
          print(result.credential.fullName.givenName);//All the required credentials
          print(result.credential.fullName.familyName);//All the required credentials
          print(result.credential.authorizationCode);
          String fullname ="${result.credential.fullName.givenName} ${result.credential.fullName.familyName}";
          /*_databaseHelper.registerApple(fullname.toString(),result.credential.email.toString(),result.credential.authorizationCode.toString()).whenComplete(() {
            if (_databaseHelper.apple_status == true){
              Navigator.pushReplacementNamed(context, '/GroceryHomePage');
            }else{
              print ('error');
            }
          });*/
          //All the required credentials
          break;//All the required credentials
        case AuthorizationStatus.error:
          print("Sign in failed: ${result.error.localizedDescription}");
          break;
        case AuthorizationStatus.cancelled:
          print('User cancelled');
          break;
      }
    }
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
    //check_login();

    if(Platform.isIOS){                                                      //check for ios if developing for both android & ios
      AppleSignIn.onCredentialRevoked.listen((_) {
        print("Credentials revoked");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        final height = MediaQuery.of(context).size.height;
        return Scaffold(
          backgroundColor: Color(0xFF335876),
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: height * 0.1),
                  //_title(),
                  Image.asset("assets/images/logo_white-old.png"),
                  SizedBox(height: 40.0),
                  choose_form(),

                  //android_or_ios(),
                  Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 30.0),
                      child: Row(children: <Widget>[
                        Expanded(
                            child: Divider(
                          color: Colors.white,
                          thickness: 1,
                        )),
                        Text(
                          "  أو  ",
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontFamily: "CustomIcons",
                          ),
                        ),
                        Expanded(
                            child: Divider(
                          color: Colors.white,
                          thickness: 1,
                        )),
                      ])),
                  _facebookButton(),
                  _googleButton(),
                  android_or_ios(),
                  //new_account_button(context),
                  SizedBox(height: 20),
                  FlatButton(
                    color: Color(0xFF335876),
                    textColor: Colors.white,
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
                        color: Colors.white,
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

  ///////////////////welcome form start/////////////////////

  Widget _signupButton(String text) {
    return InkWell(
      onTap: () => {
        setState(() {
          form = 2;
        })
      },
      child: Container(
        //width: MediaQuery.of(context).size.width/1.9,
        padding: EdgeInsets.symmetric(vertical: 10),
        margin: EdgeInsets.only(right: 5),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              /*BoxShadow(
                color: Colors.grey.shade200,
                offset: Offset(2, 4),
                blurRadius: 5,
                spreadRadius: 2)*/
            ],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xffdd685f), Color(0xffac3729)])),
        child: Text(
          text,
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontFamily: "CustomIcons"),
        ),
      ),
    );
  }

  Widget _loginButton(String text) {
    return InkWell(
      onTap: () => {
        setState(() {
          form = 1;
        })
      },
      child: Container(
        //width: MediaQuery.of(context).size.width/1.9,
        padding: EdgeInsets.symmetric(vertical: 10),
        margin: EdgeInsets.only(left: 5),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.grey.shade200,
                //offset: Offset(1, 1),
                //blurRadius: 2,
                //spreadRadius: 2,
              )
            ],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xffffffff), Color(0xffeeeeee)])),
        child: Text(
          text,
          style: TextStyle(
              fontSize: 20, color: Colors.black, fontFamily: "CustomIcons"),
        ),
      ),
    );
  }

  Widget welcome_form() {
    return ListTile(
      title: Row(
        children: <Widget>[
          Expanded(child: _loginButton('تسجيل دخول')),
          Expanded(child: _signupButton('حساب جديد')),
        ],
      ),
    );
  }

  //////////////////welcome form end///////////////////////

  Widget choose_form() {
    if (form == 0) {
      return welcome_form();
    } else if (form == 1) {
      return singin_form();
    } else if (form == 2) {
      return singup_form();
    }
  }

  ///////////////////sign in form start/////////////////////

  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();

  Widget _emailField(String title) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
              style: TextStyle(
                  color: Colors.white, fontSize: 16, fontFamily: "CustomIcons"),
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                  hintText: "الايميل",
                  hintStyle: TextStyle(
                      fontSize: 14.0,
                      color: Colors.white,
                      fontFamily: "CustomIcons"),
                  prefixIcon: const Icon(
                    Icons.email,
                    color: Colors.white,
                  ),
                  border: InputBorder.none,
                  fillColor: Color(0xff51637b),
                  filled: true))
        ],
      ),
    );
  }

  Widget _passwordField(String title) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          TextField(
              controller: _passwordController,
              style: TextStyle(
                  color: Colors.white, fontSize: 16, fontFamily: "CustomIcons"),
              obscureText: true,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                  hintText: "كلمة المرور",
                  hintStyle: TextStyle(
                      fontSize: 14.0,
                      color: Colors.white,
                      fontFamily: "CustomIcons"),
                  prefixIcon: const Icon(
                    Icons.security,
                    color: Colors.white,
                  ),
                  border: InputBorder.none,
                  fillColor: Color(0xff51637b),
                  filled: true))
        ],
      ),
    );
  }

  Widget _submitButton() {
    return InkWell(
      onTap: () {
        login_btn_tap();
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          /*boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.shade200,
                offset: Offset(2, 4),
                blurRadius: 5,
                spreadRadius: 2)
          ],*/
          /*gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xfffbb448), Color(0xfff7892b)])*/

          color: Color(0xFFdd685f),
        ),
        child: login_button_child(),
      ),
    );
  }

  int login_btn_child_index = 0;
  login_button_child() {
    if (login_btn_child_index == 0) {
      return Text(
        'تسجيل الدخول',
        style: TextStyle(
            fontSize: 20, color: Colors.white, fontFamily: "CustomIcons"),
      );
    } else {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    }
  }

  login_btn_tap() {
    if (login_btn_child_index == 0) {
      setState(() {
        login_btn_child_index = 1;
      });
      if (_emailController.text.trim().isEmpty) {
        alert_dialog('يرجى كتابة الإيميل ', 1, 'بيانات ناقصة');
        setState(() {
          login_btn_child_index = 0;
        });
      } else if (_passwordController.text.isEmpty) {
        alert_dialog('يرجى كتابة كلمةالمرور', 1, 'بيانات ناقصة');
        setState(() {
          login_btn_child_index = 0;
        });
      } else {
        print('ok');
        databaseHelper
            .loginData(_passwordController.text.toString(),
                _emailController.text.trim().toLowerCase().toString())
            .whenComplete(() {
          if (databaseHelper.login_status == false) {
            alert_dialog(
                'تأكد من صحة الإيميل أو كلمة المرور', 1, 'بيانات خاطئة');
            setState(() {
              login_btn_child_index = 0;
            });
          } else {
            _save_login_info(
                databaseHelper.user_id,
                _passwordController.text.toString(),
                databaseHelper.user_name,
                _emailController.text.trim().toLowerCase().toString(),
                databaseHelper.userToken);
            Navigator.pushReplacementNamed(context, '/home');
          }
        });
      }
    }
  }

  Widget _backButton() {
    return InkWell(
      onTap: () {
        setState(() {
          form = 0;
        });
      },
      child: Container(
        //padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(right: 0, top: 0, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.white),
            ),
            Text('عودة',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontFamily: "CustomIcons"))
          ],
        ),
      ),
    );
  }

  Widget singin_form() {
    return Column(
      children: <Widget>[
        _backButton(),
        _emailField("Email id"),
        _passwordField(
          "Password",
        ),
        SizedBox(height: 15),
        _submitButton(),
        /*SizedBox(height: 10,),
        InkWell(onTap: (){},child: Text('هل نسيت كلمة المرور؟',
    style: TextStyle(
    fontSize: 16, fontWeight: FontWeight.w500,color: Colors.orange,fontFamily: "CustomIcons")),
    ),*/
      ],
    );
  }

///////////////////sign in form end///////////////////////

  alert_dialog(String text, int image_index, String title) {
    String image_name;
    if (image_index == 1) {
      //alert image
      image_name = "assets/alert.png";
    }
    showDialog(
        context: context,
        builder: (_) => AssetGiffyDialog(
              onlyOkButton: true,
              buttonCancelText: Text('إلغاء',
                  style: TextStyle(fontFamily: "CustomIcons", fontSize: 16)),
              buttonOkText: Text('موافق',
                  style: TextStyle(
                      fontFamily: "CustomIcons",
                      fontSize: 16,
                      color: Colors.white)),
              buttonOkColor: Colors.orange,
              image: Image.asset(image_name, fit: BoxFit.cover),
              title: Text(
                title,
                style: TextStyle(
                    fontSize: 18.0,
                    fontFamily: "CustomIcons",
                    color: Colors.orange),
              ),
              description: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: "CustomIcons", fontSize: 16),
              ),
              onOkButtonPressed: () {
                Navigator.pop(context);
              },
            ));
  }

  //////////////////signup form start///////////////////////
  final TextEditingController _nameController = new TextEditingController();
  final TextEditingController _phoneController = new TextEditingController();

  Widget _nameField(String title) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
              controller: _nameController,
              style: TextStyle(
                  color: Colors.white, fontSize: 16, fontFamily: "CustomIcons"),
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                  hintText: "الاسم الكامل",
                  hintStyle: TextStyle(
                      fontSize: 14.0,
                      color: Colors.white,
                      fontFamily: "CustomIcons"),
                  prefixIcon: const Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  border: InputBorder.none,
                  fillColor: Color(0xff51637b),
                  filled: true))
        ],
      ),
    );
  }

  Widget _phoneField(String title) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
              keyboardType: TextInputType.phone,
              controller: _phoneController,
              style: TextStyle(
                  color: Colors.white, fontSize: 16, fontFamily: "CustomIcons"),
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                  hintText: "رقم الهاتف",
                  hintStyle: TextStyle(
                      fontSize: 14.0,
                      color: Colors.white,
                      fontFamily: "CustomIcons"),
                  prefixIcon: const Icon(
                    Icons.phone,
                    color: Colors.white,
                  ),
                  border: InputBorder.none,
                  fillColor: Color(0xff51637b),
                  filled: true))
        ],
      ),
    );
  }

  Widget _submit_signup_Button() {
    return InkWell(
      onTap: () {
        signup_btn_tap();
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          /*boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.shade200,
                offset: Offset(2, 4),
                blurRadius: 5,
                spreadRadius: 2)
          ],*/
          /*gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xfffbb448), Color(0xfff7892b)])*/
          color: Color(0xFFdd685f),
        ),
        child: signup_button_child(),
      ),
    );
  }

  int signup_btn_child_index = 0;
  signup_button_child() {
    if (signup_btn_child_index == 0) {
      return Text(
        'إنشاء حساب جديد',
        style: TextStyle(
            fontSize: 20, color: Colors.white, fontFamily: "CustomIcons"),
      );
    } else {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    }
  }

  signup_btn_tap() {
    if (signup_btn_child_index == 0) {
      setState(() {
        signup_btn_child_index = 1;
      });
      if (_emailController.text.trim().isEmpty) {
        alert_dialog('يرجى كتابة الإيميل', 1, 'بيانات ناقصة');
        setState(() {
          signup_btn_child_index = 0;
        });
      } else if (_passwordController.text.isEmpty) {
        alert_dialog('يرجى كتابة كلمةالمرور', 1, 'بيانات ناقصة');
        setState(() {
          signup_btn_child_index = 0;
        });
      } else if (_passwordController.text.length < 6) {
        alert_dialog('كلمة المرور قصيرة جداً', 1, 'بيانات ناقصة');
        setState(() {
          signup_btn_child_index = 0;
        });
      } else if (_nameController.text.isEmpty ||
          _nameController.text.length < 6) {
        alert_dialog('يرجى كتابة الاسم الكامل', 1, 'بيانات ناقصة');
        setState(() {
          signup_btn_child_index = 0;
        });
      } else {
        databaseHelper
            .registerData(
          _passwordController.text.trim(),
          _nameController.text.trim(),
          _emailController.text.trim().toLowerCase(),
        )
            .whenComplete(() {
          if (databaseHelper.register_status == false) {
            alert_dialog('حدثت مشكلة يرجى المحاولة لاحقاً', 1, 'رسالة خطأ');
            signup_btn_child_index = 0;
          } else {
            _save_login_info(
                databaseHelper.user_id,
                _passwordController.text.toString(),
                _nameController.text.trim(),
                _emailController.text.trim().toLowerCase().toString(),
                databaseHelper.userToken);

            Navigator.pushReplacementNamed(context, '/home');
          }
        });
      }
    }
  }

  Widget singup_form() {
    return Column(
      children: <Widget>[
        _backButton(),
        _nameField("Email id"),
        //_phoneField("Email id"),
        _emailField("Email id"),
        _passwordField(
          "Password",
        ),
        SizedBox(height: 15),
        _submit_signup_Button(),
      ],
    );
  }
//////////////////signup form end/////////////////////////
}
