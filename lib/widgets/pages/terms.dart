import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/style.dart';
import 'package:iraqibayt/modules/Statistic.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_html/flutter_html.dart';
import 'package:iraqibayt/widgets/chats/chats.dart';
import 'package:iraqibayt/widgets/firebase_agent.dart';
import 'package:iraqibayt/widgets/home/home.dart';
import 'package:iraqibayt/widgets/notifications.dart';
import 'package:iraqibayt/widgets/posts/add_post.dart';
import 'package:iraqibayt/widgets/posts/posts_home.dart';
import 'package:iraqibayt/widgets/profile.dart';

import '../ContactUs.dart';
import '../my_icons_icons.dart';
import '../ContactUs.dart';
import '../home/home.dart';
import '../my_icons_icons.dart';

class Terms extends StatefulWidget {
  @override
  _Terms createState() => _Terms();
}

class _Terms extends State<Terms> {
  List pages_list = List();

  Future<List<Statistic>> _getdata() async {
    var statisticsResponse = await http.get(Uri.parse('https://iraqibayt.com/api/pages_api'));
    var responce = json.decode(statisticsResponse.body);
    setState(() {
      pages_list = responce;
    });
  }

  void initState() {
    super.initState();
    _getdata();
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double screenHeight =
        MediaQuery.of(context).size.height - statusBarHeight - kToolbarHeight;
    int brIndex;

    return Scaffold(
      backgroundColor: Color(0XFFc4c4c4),
      appBar: AppBar(
        title: Text(
          'شروط الاستخدام',
          style: TextStyle(
            fontFamily: "CustomIcons",
          ),
        ),
        backgroundColor: Color(0xff275879),
        actions: [
          FirebaseAgent(),
        ],
      ),
      body: Container(
        height: screenHeight,
        padding: const EdgeInsets.only(top: 0),
        child:
        pages_list.isEmpty  ?
        Container(
          height: 100,
          child: Center(
            child: new CircularProgressIndicator(),
          ),
        ):SingleChildScrollView(
          child:Row(
            children: [
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(0),
                  onTap: () {},
                  child: Card(
                    shape: RoundedRectangleBorder(
                      side:
                      BorderSide(color: Colors.grey, width: 0.5),
                      borderRadius: BorderRadius.circular(0),
                    ),
                    clipBehavior: Clip.antiAlias,
                    margin: const EdgeInsets.only(top:0),
                    //color: Colors.grey,
                    elevation: 0,

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[

                        Padding(
                          padding: const EdgeInsets.all(0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(3.0),
                                  color: Colors.white,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Html(
                                        data:
                                        pages_list[0]["terms"],
                                        style: {
                                          'body': Style(
                                            fontSize: FontSize(16.0),
                                            fontFamily: "CustomIcons",
                                            textAlign: TextAlign.center,
                                          )
                                        },
                                      ),
                                    ],
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
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF335876),
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.white,
        onTap: onTabTapped, // new
        //currentIndex: 0,
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
              icon: Icon(MyIcons.user),
              label: 'حسابي'
          ),

          new BottomNavigationBarItem(
              icon: Icon(Icons.message),
              label: 'الرسائل'
          ),
          new BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'الإشعارات'
          ),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    if(index == 0){
      Navigator.of(context).push(
        new MaterialPageRoute(
            builder: (BuildContext context) => new Home()),
      );
    }else if(index == 1){
      Navigator.of(context).push(
        new MaterialPageRoute(
            builder: (BuildContext context) => new Posts_Home()),
      );
    }else if(index == 2){
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => new Profile()));
    }else if (index == 3) {
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => new Chats()));
    } else if (index == 4) {
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => new Notifications()));
    }
    /*setState(() {
      _currentIndex = index;
      print(index.toString());
    });*/
  }
}
