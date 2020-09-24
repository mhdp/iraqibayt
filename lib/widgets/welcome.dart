import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Welcome extends StatelessWidget {
  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        return Scaffold(
          body: Column(
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              Container(
                margin: const EdgeInsets.only(top: 30.0),
                padding: const EdgeInsets.all(20.0),
                height: constraints.maxHeight * 0.2,
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10.0),
                child: Text(
                  'أهلا ً بك في البيت العراقي',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                child: RaisedButton(
                  padding: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 15.0),
                  child: Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'تسجيل الدخول باستخدام جوجل',
                          style: TextStyle(fontSize: 17, color: Colors.white),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Image.asset('assets/images/google.png'),
                      ),
                    ],
                  ),
                  onPressed: null,
                  color: Colors.blue,
                  disabledColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(5.0)),
                ),
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                child: RaisedButton(
                  padding: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 15.0),
                  child: Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'تسجيل الدخول باستخدام فيسبوك',
                          style: TextStyle(fontSize: 17, color: Colors.white),
                        ),
                      ),
                      Align(
                          alignment: Alignment.centerRight,
                          child: Image.asset('assets/images/facebook.png')),
                    ],
                  ),
                  onPressed: null,
                  color: Color(0xff345290),
                  disabledColor: Color(0xff345290),
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(5.0)),
                ),
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                child: InkWell(child: Container(
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
                                bottomLeft: Radius.circular(5),
                                topLeft: Radius.circular(5)),
                          ),
                          alignment: Alignment.center,
                          child: Icon(FontAwesomeIcons.facebook,color: Colors.white,),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xff2872ba),
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(5),
                                topRight: Radius.circular(5)),
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
              ),
              ),
              Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 30.0),
                  child: Row(children: <Widget>[
                    Expanded(child: Divider()),
                    Text(
                      "  أو  ",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Expanded(child: Divider()),
                  ])),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                child: OutlineButton(
                  padding: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 20.0),
                  child: Text(
                    'إنشاء حساب / تسجيل الدخول',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Color(0xff345290)),
                  ),
                  onPressed: null,
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(5.0),
                  ),
                  disabledBorderColor: Color(0xff345290),
                ),
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0),
                child: Text(
                  'شروط الاستخدام',
                  style: TextStyle(
                    color: Colors.black54,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
