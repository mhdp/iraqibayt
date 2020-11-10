import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iraqibayt/widgets/posts/add_post.dart';
import 'package:iraqibayt/widgets/profile.dart';
import 'package:iraqibayt/widgets/welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavDrawer extends StatefulWidget {
  @override
  NavDrawerState createState() => NavDrawerState();
}

class NavDrawerState extends State<NavDrawer> {
  String user_name;
  var gust = false;
  check_if_gust() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'is_login';
    final value = prefs.get(key);
    print('$value');
    if (value != '1') {
      setState(() {
        gust = true;
      });
    } else {
      final key = 'name';
      final value = prefs.get(key);
      setState(() {
        user_name = value;
      });
    }
  }

  void initState() {
    super.initState();

    user_name = 'زائر';
    check_if_gust();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/images/logo_white.png',
                  width: 125.0,
                  height: 50.0,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  user_name,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: "CustomIcons",
                      fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            decoration: BoxDecoration(
              color: Color(0xFF335876),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.verified_user,
              color: Color(0xFF335876),
            ),
            title: Text(
              'الملف الشخصي',
              style: TextStyle(fontFamily: 'CustomIcons'),
            ),
            onTap: () => {
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => new Profile()))
            },
          ),
          ListTile(
            leading: Icon(
              Icons.add_box,
              color: Color(0xFF335876),
            ),
            title: Text(
              'أضف إعلان',
              style: TextStyle(fontFamily: 'CustomIcons'),
            ),
            onTap: () => {
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => new Add_Post()))
            },
          ),
          /*ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () => {Navigator.of(context).pop()},
          ),*/
          ListTile(
            leading: Icon(
              Icons.post_add,
              color: Color(0xFF335876),
            ),
            title: Text(
              'إعلاناتي',
              style: TextStyle(fontFamily: 'CustomIcons'),
            ),
            onTap: () => {
              /*Navigator.of(context).push(
                new MaterialPageRoute(
                    builder: (BuildContext context) => new about_us()))*/
            },
          ),
          ListTile(
            leading: Icon(
              Icons.favorite,
              color: Color(0xFF335876),
            ),
            title: Text(
              'المفضلة',
              style: TextStyle(fontFamily: 'CustomIcons'),
            ),
            onTap: () => {
              /*Navigator.of(context).push(
                new MaterialPageRoute(
                    builder: (BuildContext context) => new favouritetab()))*/
            },
          ),
          ListTile(
            leading: Icon(
              Icons.message,
              color: Color(0xFF335876),
            ),
            title: Text(
              'الرسائل',
              style: TextStyle(fontFamily: 'CustomIcons'),
            ),
            onTap: () => {
              /*Navigator.of(context).push(
                new MaterialPageRoute(
                    builder: (BuildContext context) => new feedbacks()))*/
            },
          ),
          ListTile(
            leading: Icon(
              Icons.exit_to_app,
              color: Color(0xFF335876),
            ),
            title: gust
                ? Text(
                    'تسجيل الدخول',
                    style: TextStyle(fontFamily: 'CustomIcons'),
                  )
                : Text(
                    'تسجيل خروج',
                    style: TextStyle(fontFamily: 'CustomIcons'),
                  ),
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              final key = 'is_login';
              final value = "0";
              prefs.setString(key, value);
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => new Welcome()));
            },
          ),
        ],
      ),
    );
  }

  Widget login_text() {
    return Text(
      "تسجيل الدخول",
      style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontFamily: "CustomIcons",
          fontSize: 20),
      textAlign: TextAlign.center,
    );
  }
}
