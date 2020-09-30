import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Welcome extends StatelessWidget {
  static const routeName = '/';

  Widget _facebookButton() {
    return InkWell(
      //onTap: initiateFacebookLogin,
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
        //onTap: google_button_tap,
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

  Widget new_account_button() {
    return InkWell(
      //onTap: initiateFacebookLogin,
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
                  new_account_button(),
                  SizedBox(height: 20),

                  FlatButton(
                    color: Colors.white,
                    textColor: Colors.black,
                    disabledColor: Colors.grey,
                    disabledTextColor: Colors.grey,
                    padding: EdgeInsets.all(8.0),
                    splashColor: Colors.orange,
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/main_board');
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
