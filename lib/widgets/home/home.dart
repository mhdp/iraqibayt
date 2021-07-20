import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:iraqibayt/modules/db_helper.dart';
import 'package:iraqibayt/widgets/chats/chats.dart';
import 'package:iraqibayt/widgets/chats/user_chat.dart';
import 'package:iraqibayt/widgets/firebase_agent.dart';
import 'package:iraqibayt/widgets/home/departs_card.dart';
import 'package:iraqibayt/widgets/home/exchange_card.dart';
import 'package:iraqibayt/widgets/home/search_card.dart';
import 'package:iraqibayt/widgets/home/weather_card.dart';
import 'package:iraqibayt/widgets/notifications.dart';
import 'package:iraqibayt/widgets/posts/add_post.dart';
import 'package:iraqibayt/widgets/posts/full_post.dart';
import 'package:iraqibayt/widgets/posts/latest_posts.dart';
import 'package:iraqibayt/widgets/posts/posts_home.dart';
import 'package:iraqibayt/widgets/posts/spicail_posts.dart';
import 'package:iraqibayt/widgets/posts/spicial_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../ContactUs.dart';
import '../NavDrawer.dart';
import '../my_account.dart';
import '../my_icons_icons.dart';
import 'contact_us.dart';
import 'info_card.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  DatabaseHelper databaseHelper = new DatabaseHelper();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();

  String notificationRouteType = '0';
  String couponNotificationId = '0';
  String notificationUrl = '0';
  String notificationID = '0';
  String notificationPostID = '0';
  String notificationUserID = '0';
  String notificationMessageID = '0';
  String notificationSenderName = '0';

  int notificationCounter = 0;
  int messageCounter = 0;

  @override
  void initState() {
    super.initState();

    databaseHelper.getUserUnreadNotificationsCount().then((value) {
      setState(() {
        notificationCounter = int.parse(value);
      });
    });

    databaseHelper.getUserUnreadMessagesCount().then((value) {
      setState(() {
        messageCounter = int.parse(value);
      });
    });

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFc4c4c4),
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Center(
          child: Image.asset(
            'assets/images/logo_white.png',
            fit: BoxFit.fill,
            height: 40,
          ),
        ),
        backgroundColor: Color(0xFF335876),
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
        child: SingleChildScrollView(
          child: Column(
            //mainAxisSize: MainAxisSize.min,
            //scrollDirection: Axis.vertical,
            children: <Widget>[




              SearchCard(),

              SizedBox(
                height: 5,
              ),

              Spicial_posts(),

              SizedBox(
                height: 10,
              ),
              RaisedButton(
                onPressed: () {},
                color: Color(0XFFc4c4c4),
                elevation: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    //Icon(Icons.list,color: Colors.white,),

                    Text(
                      " العروض المضافة حديثاً ",
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.black,
                        fontFamily: "CustomIcons",
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
              latest_posts(),
              SizedBox(
                height: 5,
              ),

              RaisedButton(
                onPressed: () {},
                color: Color(0XFFc4c4c4),
                elevation: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    //Icon(Icons.list,color: Colors.white,),

                    Text(
                      "الأقسام",
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.black,
                        fontFamily: "CustomIcons",
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
              DepartsCard(),

              ExchangeCard(),
              SizedBox(
                height: 5,
              ),

              WeatherCard(),

              InfoCard(),
              SizedBox(
                height: 5,
              ),
              Contact_us_card(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String _url = 'https://api.whatsapp.com/send?phone=9647802722141&text=IB';


              await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';

        },
        child: const Icon(MyIcons.whatsapp),
        backgroundColor: Colors.green,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF335876),
        unselectedItemColor: Colors.white,
        selectedItemColor: Color(0xFFdd685f),
        onTap: onTabTapped, // new
        currentIndex: 0,
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

          new BottomNavigationBarItem(icon: Icon(MyIcons.user), label: 'حسابي'),
          new BottomNavigationBarItem(
              icon: new Stack(
                children: <Widget>[
                  new Icon(Icons.message),
                  messageCounter > 0
                      ? new Positioned(
                    right: 0,
                    child: new Container(
                      padding: EdgeInsets.all(1),
                      decoration: new BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 12,
                        minHeight: 12,
                      ),
                      child: new Text(
                        messageCounter.toString(),
                        style: new TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                      : Container(
                    height: 0,
                    width: 0,
                  )
                ],
              ), label: 'الرسائل'),
          new BottomNavigationBarItem(
              icon: new Stack(
                children: <Widget>[
                  new Icon(Icons.notifications),
                  notificationCounter > 0
                      ? new Positioned(
                          right: 0,
                          child: new Container(
                            padding: EdgeInsets.all(1),
                            decoration: new BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            constraints: BoxConstraints(
                              minWidth: 12,
                              minHeight: 12,
                            ),
                            child: new Text(
                              notificationCounter.toString(),
                              style: new TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : Container(
                          height: 0,
                          width: 0,
                        )
                ],
              ),
              label: 'الإشعارات'),
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
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => new MyAccount()));
    } else if (index == 3) {
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
