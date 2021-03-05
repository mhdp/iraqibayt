import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:iraqibayt/modules/db_helper.dart';
import 'package:iraqibayt/widgets/chats/user_chat.dart';
import 'package:iraqibayt/widgets/notifications.dart';
import 'package:iraqibayt/widgets/posts/full_post.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class FirebaseAgent extends StatefulWidget {
  @override
  _FirebaseAgentState createState() => _FirebaseAgentState();
}

class _FirebaseAgentState extends State<FirebaseAgent> {

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
          Navigator.of(context).push(
            new MaterialPageRoute(
              builder: (BuildContext context) => new UserChat(userID: notificationUserID,userName: notificationSenderName,),),
          );
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

  Future checkIfDuplicatedNotification (String keyLabel , String receivedId) async
  {
    final prefs = await SharedPreferences.getInstance();
    final key = keyLabel;
    final value = prefs.get(key);

    if(receivedId == value.toString())
      return true;
    else
      return false;
  }

  Future setLastNotificationId (String keyLabel , String receivedId) async
  {
    final prefs = await SharedPreferences.getInstance();
    final key = keyLabel;
    prefs.setString(key, receivedId);
  }

  void initializeNotificationsConfigs() {
    var initializationSettingsAndroid =
    new AndroidInitializationSettings('@mipmap/logo');
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

        if(message['data']['type'] != 'chat' && !await checkIfDuplicatedNotification('last_notification_id' , message['data']['notification_id'])
            || message['data']['type'] == 'chat' && !await checkIfDuplicatedNotification('last_message_id' , message['data']['message_id']))
        {
          if(message['data']['type'] == 'chat')
          {
            setLastNotificationId('last_message_id' , message['data']['message_id']).whenComplete(() {
              print("onResume: $message");
              setState(() {
                // notificationID = message['data']['notification_id'];
                _backgroundNotificationRouter(message);
              });

            });
          }
          else
          {
            setLastNotificationId('last_notification_id' , message['data']['notification_id']).whenComplete(() {
              print("onResume: $message");
              setState(() {
                // notificationID = message['data']['notification_id'];
                _backgroundNotificationRouter(message);
              });

            });
          }

        }
      },
      onResume: (Map<String, dynamic> message) async {

        print('on Resume section entered !!!!');

        if(message['data']['type'] != 'chat' && !await checkIfDuplicatedNotification('last_notification_id' , message['data']['notification_id'])
            || message['data']['type'] == 'chat' && !await checkIfDuplicatedNotification('last_message_id' , message['data']['message_id']))
        {
          if(message['data']['type'] == 'chat')
          {
            setLastNotificationId('last_message_id' , message['data']['message_id']).whenComplete(() {
              print("onResume: $message");
              setState(() {
                // notificationID = message['data']['notification_id'];
                _backgroundNotificationRouter(message);
              });

            });
          }
          else
          {
            setLastNotificationId('last_notification_id' , message['data']['notification_id']).whenComplete(() {
              print("onResume: $message");
              setState(() {
                // notificationID = message['data']['notification_id'];
                _backgroundNotificationRouter(message);
              });

            });
          }

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
  Widget build(BuildContext context) {
    return Container(height: 0 , width: 0);
  }
}
