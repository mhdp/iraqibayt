import 'package:flutter/material.dart';

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
                    fontSize: 20,
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
                  child: Row(
                    children: <Widget>[
                      Text(
                        'تسجيل الدخول باستخدام جوجل',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 20.0),
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
                  child: Row(
                    children: <Widget>[
                      Text(
                        'تسجيل الدخول باستخدام فيسبوك',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      Image.asset('assets/images/facebook.png'),
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
                child: RaisedButton(
                  padding: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 15.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        'تسجيل الدخول باستخدام واتساب',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      Container(
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Image.asset('assets/images/whatsapp.png')),
                    ],
                  ),
                  onPressed: null,
                  color: Color.fromARGB(255, 86, 240, 116),
                  disabledColor: Color(0xff25D366),
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(5.0)),
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
                        fontSize: 20,
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
                    style: TextStyle(fontSize: 20, color: Color(0xff345290)),
                  ),
                  onPressed: null,
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(5.0),
                  ),
                  disabledBorderColor: Color(0xff345290),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}