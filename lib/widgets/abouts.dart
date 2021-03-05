import 'package:flutter/material.dart';
import 'package:flutter_html/style.dart';
import 'package:iraqibayt/modules/About.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_html/flutter_html.dart';
import 'package:iraqibayt/widgets/chats/chats.dart';
import 'package:iraqibayt/widgets/firebase_agent.dart';
import 'package:iraqibayt/widgets/fullAbout.dart';
import 'package:iraqibayt/widgets/my_account.dart';
import 'package:iraqibayt/widgets/notifications.dart';
import 'package:iraqibayt/widgets/posts/add_post.dart';
import 'package:iraqibayt/widgets/posts/posts_home.dart';
import 'package:iraqibayt/widgets/profile.dart';

import 'ContactUs.dart';
import 'home/home.dart';
import 'my_icons_icons.dart';

class Abouts extends StatefulWidget {
  @override
  _AboutsState createState() => _AboutsState();
}

class _AboutsState extends State<Abouts> {
  List<About> abouts;

  Future<List<About>> _getAbouts() async {
    var aboutsResponse = await http.get('https://iraqibayt.com/getAbouts');
    var aboutsData = json.decode(aboutsResponse.body);
    About tAbout;
    abouts = [];

    for (var about in aboutsData) {
      tAbout = About.fromJson(about);

      abouts.add(tAbout);
      print('abouts length is : ' + abouts.length.toString());
    }
    return abouts;
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
          'عراقنا',
          style: TextStyle(
            fontFamily: "CustomIcons",
          ),
        ),
        backgroundColor: Color(0xff275879),
        actions: [
          FirebaseAgent(),
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
      body: Container(
        height: screenHeight,
        padding: const EdgeInsets.only(top: 20.0),
        child: FutureBuilder(
          future: _getAbouts(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Container(
                height: 100,
                child: Center(
                  child: new CircularProgressIndicator(),
                ),
              );
            } else
              return Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: screenHeight,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          brIndex = snapshot.data[index].body.indexOf('br');
                          print(brIndex);
                          return InkWell(
                            borderRadius: BorderRadius.circular(0),
                            onTap: () {},
                            child: Card(
                              shape: RoundedRectangleBorder(
                                side:
                                    BorderSide(color: Colors.grey, width: 0.5),
                                borderRadius: BorderRadius.circular(0),
                              ),
                              clipBehavior: Clip.antiAlias,
                              margin: const EdgeInsets.only(top:10.0),
                              //color: Colors.grey,
                              elevation: 0,

                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(0),
                                    child: Container(
                                      padding: const EdgeInsets.all(3.0),
                                      color: Color(0xff275879),
                                      child: Text(
                                        snapshot.data[index].title,
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontFamily: "CustomIcons",
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(0),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Container(
                                            padding: const EdgeInsets.all(3.0),
                                            color: Colors.white,
                                            child: Column(
                                              children: [
                                                Html(
                                                  data: snapshot
                                                          .data[index].body
                                                          .substring(
                                                              brIndex + 5,
                                                              brIndex + 105) +
                                                      '...',
                                                  style: {
                                                    'body': Style(
                                                      fontSize: FontSize(16.0),
                                                      fontFamily: "CustomIcons",
                                                    )
                                                  },
                                                ),
                                                FlatButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .push(
                                                        new MaterialPageRoute(
                                                          builder: (BuildContext
                                                                  context) =>
                                                              new FullAbout(
                                                            title: snapshot
                                                                .data[index]
                                                                .title,
                                                            body: snapshot
                                                                .data[index]
                                                                .body,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: Text(
                                                      'إقرأ المزيد',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.blue,
                                                        fontFamily:
                                                            "CustomIcons",
                                                      ),
                                                    ))
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
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
          },
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
              icon: Icon(Icons.post_add),
              label: 'أضف إعلان'
          ),
          new BottomNavigationBarItem(
              icon: Icon(MyIcons.user),
              label: 'حسابي'
          ),
          new BottomNavigationBarItem(
              icon: Icon(Icons.mail),
              label: 'ملاحظات'
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
      Navigator.of(context).push(
        new MaterialPageRoute(
            builder: (BuildContext context) => new Add_Post()),
      );
    }else if(index == 3){
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => new MyAccount()));
    }else if(index == 4){
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => new ContactUs()));
    }else if (index == 5) {
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => new Chats()));
    } else if (index == 6) {
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => new Notifications()));
    }
    /*setState(() {
      _currentIndex = index;
      print(index.toString());
    });*/
  }
}
