import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iraqibayt/widgets/posts/add_post.dart';
import 'package:iraqibayt/widgets/posts/my_post.dart';
import 'package:iraqibayt/widgets/posts/posts_home.dart';
import 'package:iraqibayt/widgets/profile.dart';
import 'package:iraqibayt/widgets/welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ContactUs.dart';
import 'favorites.dart';
import 'home/home.dart';
import 'my_icons_icons.dart';

class MyAccount extends StatefulWidget {
  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFF8e8d8d),
      appBar: AppBar(
        title: Text(
          'حسابي',
          style: TextStyle(
            fontFamily: "CustomIcons",
          ),
        ),
        backgroundColor: Color(0xff275879),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: RaisedButton(
              onPressed: () {
                Navigator.of(context).push(
                  new MaterialPageRoute(
                      builder: (BuildContext context) => new Add_Post()),
                );
              },
              color: Color(0xFFdd685f),
              elevation: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    Icons.add_box,
                    //color: Color(0xFF335876),
                    color: Colors.white,
                  ),
                  Text(
                    " أضف إعلان ",
                    style: TextStyle(
                      fontSize: 20,
                      //color: Color(0xFF335876),
                      color: Colors.white,
                      fontFamily: "CustomIcons",
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
      child: Column(
        children: [
          //profile
          InkWell(
            onTap: () {
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => new Profile()));
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(
                  top: 10.0, right: 10.0, left: 10.0, bottom: 10),
              padding: EdgeInsets.symmetric(vertical: 10),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                Icon(MyIcons.user, color:Color(0xff275879)),
                SizedBox(width: 5,),
                Text(
                  'الملف الشخصي',
                  style: TextStyle(
                      fontSize: 18, color: Colors.black, fontFamily: "CustomIcons"),
                ),

              ],)
            ),
          ),

          //favorite
          InkWell(
            onTap: () {
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => new Favorites()));
            },
            child: Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(
                    top: 10.0, right: 10.0, left: 10.0, bottom: 10),
                padding: EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Icon(Icons.favorite, color:Color(0xff275879)),
                    SizedBox(width: 5,),
                    Text(
                      'المفضلة',
                      style: TextStyle(
                          fontSize: 18, color: Colors.black, fontFamily: "CustomIcons"),
                    ),

                  ],)
            ),
          ),

          //my posts
          InkWell(
            onTap: () {
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => new MyPosts()));
            },
            child: Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(
                    top: 10.0, right: 10.0, left: 10.0, bottom: 10),
                padding: EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Icon(Icons.menu_book, color:Color(0xff275879)),
                    SizedBox(width: 5,),
                    Text(
                      'اعلاناتي',
                      style: TextStyle(
                          fontSize: 18, color: Colors.black, fontFamily: "CustomIcons"),
                    ),

                  ],)
            ),
          ),

          //add post
          InkWell(
            onTap: () {
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => new Add_Post()));
            },
            child: Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(
                    top: 10.0, right: 10.0, left: 10.0, bottom: 10),
                padding: EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Color(0xFFdd685f),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Icon(Icons.add_box, color:Colors.white),
                    SizedBox(width: 5,),
                    Text(
                      'أضف إعلان',
                      style: TextStyle(
                          fontSize: 18, color: Colors.white, fontFamily: "CustomIcons"),
                    ),

                  ],)
            ),
          ),

          //log out
          InkWell(
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              final key = 'is_login';
              final value = "0";
              prefs.setString(key, value);
              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Welcome()));
            },
            child: Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(
                    top: 10.0, right: 10.0, left: 10.0, bottom: 10),
                padding: EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Icon(Icons.menu_book, color:Color(0xff275879)),
                    SizedBox(width: 5,),
                    Text(
                      'تسجيل الخروج',
                      style: TextStyle(
                          fontSize: 18, color: Colors.black, fontFamily: "CustomIcons"),
                    ),

                  ],)
            ),
          ),
        ],
      ),
    ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF335876),
        unselectedItemColor: Colors.white,
        selectedItemColor: Color(0xFFdd685f),
        onTap: onTabTapped, // new
        currentIndex: 3,
        type: BottomNavigationBarType.fixed, // new
        items: [
          new BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'الرئيسية',
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'الإعلانات',
          ),
          new BottomNavigationBarItem(
              icon: Icon(Icons.post_add), label: 'أضف إعلان'),
          new BottomNavigationBarItem(icon: Icon(MyIcons.user), label: 'حسابي'),
          new BottomNavigationBarItem(icon: Icon(Icons.mail), label: 'ملاحظات'),
        ],
      ),
    );

  }

  void onTabTapped(int index) {
    if (index == 1) {
      Navigator.of(context).push(
        new MaterialPageRoute(
            builder: (BuildContext context) => new Posts_Home()),
      );
    } else if (index == 2) {
      Navigator.of(context).push(
        new MaterialPageRoute(
            builder: (BuildContext context) => new Add_Post()),
      );
    } else if (index == 0) {
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => new Home()));
    } else if (index == 4) {
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => new ContactUs()));
    }
    /*setState(() {
      _currentIndex = index;
      print(index.toString());
    });*/
  }
}