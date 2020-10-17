import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

Future<String> signInWithGoogle() async {
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
  await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final AuthResult authResult = await _auth.signInWithCredential(credential);
  final FirebaseUser user = authResult.user;

  // Checking if email and name is null
  assert(user.email != null);
  assert(user.displayName != null);
  assert(user.photoUrl != null);

  /*name = user.displayName;
    email = user.email;
    imageUrl = user.photoUrl;
    uid = user.uid;

    // Only taking the first part of the name, i.e., First Name
    if (name.contains(" ")) {
      name = name.substring(0, name.indexOf(" "));
    }*/

  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  final FirebaseUser currentUser = await _auth.currentUser();
  assert(user.uid == currentUser.uid);

  /*if (uid != null){
      _databaseHelper.registerG(name, email, uid);
    }*/

  return 'signInWithGoogle succeeded: $user';
}

void signOutGoogle() async{
  await googleSignIn.signOut();

  print("User Sign Out");
}

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
