import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:iraqibayt/modules/db_helper.dart';
import 'package:iraqibayt/widgets/chats/user_chat.dart';
import 'package:iraqibayt/widgets/home/exchange_card.dart';
import 'package:iraqibayt/widgets/home/search_card.dart';
import 'package:iraqibayt/widgets/home/weather_card.dart';
import 'package:iraqibayt/widgets/home/departs_card.dart';
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
import '../notifications.dart';
import 'contact_us.dart';
import 'info_card.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
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


  Future _launchNotificationURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future onSelectNotification(String payload) async
  {
    _foregroundNotificationRouter();

  }
  void showNotification(String title, String body) async {
    await _demoNotification(title, body);
  }

  Future<void> _demoNotification(String title, String body) async {

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'channel_ID', 'channel name', 'channel description',
        importance: Importance.max,
        playSound: true,
        showProgress: true,
        priority: Priority.high,
        ticker: 'test ticker');

    var iOSChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSChannelSpecifics);
    await flutterLocalNotificationsPlugin
        .show(0, title, body, platformChannelSpecifics, payload: 'test');
  }

  _foregroundNotificationRouter()
  {

    switch(notificationRouteType)
    {
      case 'local': if(notificationUrl == '0')
      {
        Navigator.of(context).push(
          new MaterialPageRoute(
              builder: (BuildContext context) => new Notifications()),
        );
      }
      else
      {
        _launchNotificationURL(notificationUrl).whenComplete(() {
          setState(() {
            notificationUrl = '0';
          });
          databaseHelper.checkNotification(notificationID);
        });
      }
      break;

      case 'global': if(notificationUrl == '0')
      {
        Navigator.of(context).push(
          new MaterialPageRoute(
              builder: (BuildContext context) => new Notifications()),
        );
      }
      else
      {
        _launchNotificationURL(notificationUrl).whenComplete(() {
          setState(() {
            notificationUrl = '0';
          });
          databaseHelper.checkNotification(notificationID);
        });
      }
      break;

      case 'comment': if(notificationPostID != '0')
      {
        Navigator.of(context).push(
          new MaterialPageRoute(
            builder: (BuildContext context) => new FullPost(post_id: notificationPostID,),),
        );
      }
      break;

      case 'favourite': if(notificationPostID != '0')
      {
        Navigator.of(context).push(
          new MaterialPageRoute(
            builder: (BuildContext context) => new FullPost(post_id: notificationPostID,),),
        );
      }
      break;

      case 'chat': if(notificationMessageID != '0')
      {
        if(context.widget.toStringShort() != 'UserChat')
          {
            Navigator.of(context).push(
              new MaterialPageRoute(
                builder: (BuildContext context) => new UserChat(userID: notificationUserID,userName: notificationSenderName,),),
            );
          }

      }
      break;
    }

  }

  _backgroundNotificationRouter(Map<String , dynamic> message)
  {
    switch(message['data']['type'])
    {
      case 'local': if(message['data']['url'] == '#' && message['data']['url'] != null)
      {
        Navigator.of(context).push(
          new MaterialPageRoute(
              builder: (BuildContext context) => new Notifications()),
        );
      }
      else
      {
        _launchNotificationURL(message['data']['url']).whenComplete((){
          databaseHelper.checkNotification(message['data']['notification_id'].toString());
        });
      }
      break;

      case 'global': if(message['data']['url'] == '#' && message['data']['url'] != null)
      {
        Navigator.of(context).push(
          new MaterialPageRoute(
              builder: (BuildContext context) => new Notifications()),
        );
      }
      else
      {
        _launchNotificationURL(message['data']['url']).whenComplete((){
          databaseHelper.checkNotification(message['data']['notification_id'].toString());
        });
      }
      break;

      case 'comment': if(message['data']['post_id'] != null)
      {
        Navigator.of(context).push(
          new MaterialPageRoute(
            builder: (BuildContext context) => new FullPost(post_id: message['data']['post_id'].toString(),),),
        );
      }
      break;

      case 'favourite': if(message['data']['post_id'] != null)
      {
        Navigator.of(context).push(
          new MaterialPageRoute(
            builder: (BuildContext context) => new FullPost(post_id: message['data']['post_id'].toString(),),),
        );
      }
      break;

      case 'chat': if(message['data']['message_id'] != null)
      {
          Navigator.of(context).push(
            new MaterialPageRoute(
              builder: (BuildContext context) => new UserChat(userID: message['data']['sender_id'].toString(),userName: message['data']['sender_name'].toString(),),),
          );
      }
      break;
    }

  }

  Future checkIfDuplicatedNotification (String receivedId) async
  {
    final prefs = await SharedPreferences.getInstance();
    final key = 'last_notification_id';
    final value = prefs.get(key);

    if(receivedId == value.toString())
      return true;
    else
      return false;
  }

  Future setLastNotificationId (String receivedId) async
  {
    final prefs = await SharedPreferences.getInstance();
    final key = 'last_notification_id';
    prefs.setString(key, receivedId);
  }

  void initializeNotificationsConfigs() {
    var initializationSettingsAndroid =
    new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    _firebaseMessaging.configure(
      onMessage: (Map<String , dynamic> message) async {

        showNotification(
            message['notification']['title'], message['notification']['body']);

        print("onMessage: $message");

        setState(() {
          notificationRouteType = message['data']['type'];
          notificationID = message['data']['notification_id'];

          switch(message['data']['type'])
          {
            case 'local': if(message['data']['url'] != '#')
            {
              print('this a private notification from iraqiBayt website');

              setState(() {
                notificationUrl = message['data']['url'];
              });
            }
            break;

            case 'global': if(message['data']['url'] != '#')
            {
              setState(() {
                notificationUrl = message['data']['url'];
              });
            }
            break;

            case 'comment': if(message['data']['post_id'] != null)
            {
              setState(() {
                notificationPostID = message['data']['post_id'];
              });
            }
            break;

            case 'favourite': if(message['data']['post_id'] != null)
            {
              setState(() {
                notificationPostID = message['data']['post_id'];
              });
            }
            break;

            case 'chat': if(message['data']['message_id'] != null)
            {
              print(context.widget.toStringShort());

              setState(() {
                notificationMessageID = message['data']['message_id'];
                notificationUserID = message['data']['sender_id'];
                notificationSenderName = message['data']['sender_name'];
              });
            }
            break;
          }
        });

      },
      onLaunch: (Map<String, dynamic> message) async {

        print('on Launch section entered !!!!');
        if(!await checkIfDuplicatedNotification(message['data']['notification_id']))
        {
          setLastNotificationId(message['data']['notification_id']).whenComplete(() {

            print("onLaunch: $message");
            setState(() {
              notificationID = message['data']['notification_id'];
              _backgroundNotificationRouter(message);
            });

          });
        }
      },
      onResume: (Map<String, dynamic> message) async {

        print('on Resume section entered !!!!');

        if(!await checkIfDuplicatedNotification(message['data']['notification_id']))
        {
          setLastNotificationId(message['data']['notification_id']).whenComplete(() {

            print("onResume: $message");
            setState(() {
              notificationID = message['data']['notification_id'];
              _backgroundNotificationRouter(message);
            });

          });
        }

      },
    );

  }

  @override
  void initState() {
    super.initState();

    initializeNotificationsConfigs();
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
              WeatherCard(),
              ExchangeCard(),
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
              SizedBox(
                height: 5,
              ),
              SearchCard(),
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
                      " العروض المميزة ",
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
              Spicial_posts(),
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: FlatButton(
                    onPressed: () {
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) =>
                              new Spical_page()));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'عرض كل الإعلانات المميزة',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontFamily: "CustomIcons",
                          ),
                        ),
                      ],
                    ),
                    //blockButton: true,
                    color: Color(0xFFdd685f),
                  )),
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
              InfoCard(),
              SizedBox(
                height: 5,
              ),
              Contact_us_card(),
            ],
          ),
        ),
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
    } else if (index == 3) {
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => new MyAccount()));
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
