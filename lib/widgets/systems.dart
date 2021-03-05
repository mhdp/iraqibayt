import 'package:flutter/material.dart';
import 'package:flutter_html/style.dart';
import 'package:iraqibayt/modules/System.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_html/flutter_html.dart';
import 'package:iraqibayt/widgets/chats/chats.dart';
import 'package:iraqibayt/widgets/firebase_agent.dart';
import 'package:iraqibayt/widgets/fullSystem.dart';
import 'package:iraqibayt/widgets/my_account.dart';
import 'package:iraqibayt/widgets/notifications.dart';
import 'package:iraqibayt/widgets/posts/add_post.dart';
import 'package:iraqibayt/widgets/posts/posts_home.dart';
import 'package:iraqibayt/widgets/profile.dart';

import 'ContactUs.dart';
import 'home/home.dart';
import 'my_icons_icons.dart';

class Systems extends StatefulWidget {
  @override
  _SystemsState createState() => _SystemsState();
}

class _SystemsState extends State<Systems> {
  List<System> systems;

  Future<List<System>> _getSystems() async {
    var systemsResponse = await http.get('https://iraqibayt.com/api/systems');
    var systemsData = json.decode(systemsResponse.body);
    System tSystem;
    systems = [];

    for (var tip in systemsData) {
      tSystem = System.fromJson(tip);

      systems.add(tSystem);
      print('systems length is : ' + systems.length.toString());
    }
    return systems;
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
          'قوانين العراق',
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
        padding: const EdgeInsets.only(top: 20.0),
        child: FutureBuilder(
          future: _getSystems(),
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
                          if (snapshot.data[index].description != '')
                            try {
                              brIndex = snapshot.data[index].description
                                  .indexOf('br');
                            } catch (e) {
                              brIndex = 0;
                            }
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
                                        snapshot.data[index].name,
                                        style: TextStyle(
                                          fontSize: 22,
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
                                                  data: brIndex != 0
                                                      ? snapshot.data[index]
                                                              .description
                                                              .substring(
                                                                  brIndex + 5,
                                                                  brIndex +
                                                                      105) +
                                                          '...'
                                                      : '....',
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
                                                              new FullSystem(
                                                            title: snapshot
                                                                .data[index]
                                                                .name,
                                                            description: snapshot
                                                                .data[index]
                                                                .description,
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
