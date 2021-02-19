import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iraqibayt/widgets/chats/chats.dart';
import 'package:iraqibayt/widgets/favorites.dart';
import 'package:iraqibayt/widgets/my_icons_icons.dart';
import 'package:iraqibayt/widgets/notifications.dart';
import 'package:iraqibayt/widgets/pages/Privcy.dart';
import 'package:iraqibayt/widgets/pages/about_us.dart';
import 'package:iraqibayt/widgets/pages/terms.dart';
import 'package:iraqibayt/widgets/posts/add_post.dart';
import 'package:iraqibayt/widgets/posts/my_favorits.dart';
import 'package:iraqibayt/widgets/posts/my_post.dart';
import 'package:iraqibayt/widgets/posts/spicial_page.dart';
import 'package:iraqibayt/widgets/profile.dart';
import 'package:iraqibayt/widgets/welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ContactUs.dart';

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
                  'assets/images/logo_white-old.png',
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
          //profile
          ListTile(
            leading: Icon(
              MyIcons.user,
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
              Icons.favorite,
              color: Color(0xFF335876),
            ),
            title: Text(
              'المفضلة',
              style: TextStyle(fontFamily: 'CustomIcons'),
            ),
            onTap: () => {
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => new Favorites()))
            },
          ),
          //add post
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

          //my post
          ListTile(
            leading: Icon(
              Icons.menu_book,
              color: Color(0xFF335876),
            ),
            title: Text(
              'إعلاناتي',
              style: TextStyle(fontFamily: 'CustomIcons'),
            ),
            onTap: () => {
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => new MyPosts()))
            },
          ),
          //spicial posts
          ListTile(
            leading: Icon(
              Icons.star,
              color: Color(0xFF335876),
            ),
            title: Text(
              'الإعلانات المميزة',
              style: TextStyle(fontFamily: 'CustomIcons'),
            ),
            onTap: () => {
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => new Spical_page()))
            },
          ),

          //Notifications
          ListTile(
            leading: Icon(
              Icons.notifications,
              color: Color(0xFF335876),
            ),
            title: Text(
              'الإشعارات',
              style: TextStyle(fontFamily: 'CustomIcons'),
            ),
            onTap: () => {
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => new Notifications()))
            },
          ),

          //Chats
          ListTile(
            leading: Icon(
              Icons.messenger,
              color: Color(0xFF335876),
            ),
            title: Text(
              'الرسائل',
              style: TextStyle(fontFamily: 'CustomIcons'),
            ),
            onTap: () => {
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => new Chats()))
            },
          ),

          Divider(color: Color(0xFF335876),),
          //about
          ListTile(
            leading: Icon(
              MyIcons.info,
              color: Color(0xFF335876),
            ),
            title: Text(
              'من نحن',
              style: TextStyle(fontFamily: 'CustomIcons'),
            ),
            onTap: () => {
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => new About_us_()))
            },
          ),
          //tirms
          ListTile(
            leading: Icon(
              MyIcons.book,
              color: Color(0xFF335876),
            ),
            title: Text(
              'شروط الاستخدام',
              style: TextStyle(fontFamily: 'CustomIcons'),
            ),
            onTap: () => {
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => new Terms()))
            },
          ),
          //privcy
          ListTile(
            leading: Icon(
              MyIcons.book,
              color: Color(0xFF335876),
            ),
            title: Text(
              'سياسة الخصوصية',
              style: TextStyle(fontFamily: 'CustomIcons'),
            ),
            onTap: () => {
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => new Privcy()))
            },
          ),
          Divider(color: Color(0xFF335876),),
          //countact us
          ListTile(
            leading: Icon(
              MyIcons.mail,
              color: Color(0xFF335876),
            ),
            title: Text(
              'أرسل ملاحظة',
              style: TextStyle(fontFamily: 'CustomIcons'),
            ),
            onTap: () => {
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => new ContactUs()))
            },
          ),
          //log out
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
              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Welcome()));

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
