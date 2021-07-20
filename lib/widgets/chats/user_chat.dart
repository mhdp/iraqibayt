import 'dart:convert';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iraqibayt/modules/Chat.dart';
import 'package:iraqibayt/modules/db_helper.dart';
import 'package:iraqibayt/widgets/notifications.dart';
import 'package:iraqibayt/widgets/posts/full_post.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class UserChat extends StatefulWidget {
  final String userID;
  final String userName;
  UserChat({Key key, this.userID , this.userName}) : super(key: key);

  @override
  UserChatState createState() => UserChatState();
}

class UserChatState extends State<UserChat> {

  TextEditingController _messageController;
  List<Chat> _messages, _rMessages;
  bool _isLoading;
  String _messageBuffer;

  final player = AudioCache();


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
        if(context.widget.toStringShort() == 'UserChat')
        {
          print(context.widget.toStringShort());

            refreshChat();

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

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      showNotification(
          message.notification.title, message.notification.body);

      print("onMessage: $message");

      setState(() {
        notificationRouteType = message.data['type'];
        notificationID = message.data['notification_id'];

        switch(message.data['type'])
        {
          case 'local': if(message.data['url'] != '#')
          {
            print('this a private notification from iraqiBayt website');

            setState(() {
              notificationUrl = message.data['url'];
            });
          }
          break;

          case 'global': if(message.data['url'] != '#')
          {
            setState(() {
              notificationUrl = message.data['url'];
            });
          }
          break;

          case 'comment': if(message.data['post_id'] != null)
          {
            setState(() {
              notificationPostID = message.data['post_id'];
            });
          }
          break;

          case 'favourite': if(message.data['post_id'] != null)
          {
            setState(() {
              notificationPostID = message.data['post_id'];
            });
          }
          break;

          case 'chat': if(message.data['message_id'] != null)
          {
            print(context.widget.toStringShort());

            setState(() {
              notificationMessageID = message.data['message_id'];
              notificationUserID = message.data['sender_id'];
              notificationSenderName = message.data['sender_name'];
            });

            refreshChat();
          }
          break;
        }
      });


      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });

    // FirebaseMessaging.onMessageOpenedApp.listen((event) { })
    //
    // _firebaseMessaging.configure(
    //   onMessage: (Map<String , dynamic> message) async {
    //
    //     if(message['data']['type'] != 'chat')
    //       {
    //         showNotification(
    //             message['notification']['title'], message['notification']['body']);
    //       }
    //
    //     print("onMessage: $message");
    //
    //     setState(() {
    //       notificationRouteType = message['data']['type'];
    //       notificationID = message['data']['notification_id'];
    //
    //       switch(message['data']['type'])
    //       {
    //         case 'local': if(message['data']['url'] != '#')
    //         {
    //           print('this a private notification from iraqiBayt website');
    //
    //           setState(() {
    //             notificationUrl = message['data']['url'];
    //           });
    //         }
    //         break;
    //
    //         case 'global': if(message['data']['url'] != '#')
    //         {
    //           setState(() {
    //             notificationUrl = message['data']['url'];
    //           });
    //         }
    //         break;
    //
    //         case 'comment': if(message['data']['post_id'] != null)
    //         {
    //           setState(() {
    //             notificationPostID = message['data']['post_id'];
    //           });
    //         }
    //         break;
    //
    //         case 'favourite': if(message['data']['post_id'] != null)
    //         {
    //           setState(() {
    //             notificationPostID = message['data']['post_id'];
    //           });
    //         }
    //         break;
    //
    //         case 'chat': if(message['data']['message_id'] != null)
    //         {
    //           print(context.widget.toStringShort());
    //
    //           setState(() {
    //             notificationMessageID = message['data']['message_id'];
    //             notificationUserID = message['data']['sender_id'];
    //             notificationSenderName = message['data']['sender_name'];
    //           });
    //
    //             refreshChat();
    //
    //         }
    //         break;
    //       }
    //     });
    //
    //   },
    //   onLaunch: (Map<String, dynamic> message) async {
    //
    //     print('on Launch section entered !!!!');
    //
    //     if(message['data']['type'] != 'chat' && !await checkIfDuplicatedNotification('last_notification_id' , message['data']['notification_id'])
    //         || message['data']['type'] == 'chat' && !await checkIfDuplicatedNotification('last_message_id' , message['data']['message_id']))
    //     {
    //       if(message['data']['type'] == 'chat')
    //       {
    //         setLastNotificationId('last_message_id' , message['data']['message_id']).whenComplete(() {
    //           print("onResume: $message");
    //           setState(() {
    //             // notificationID = message['data']['notification_id'];
    //             _backgroundNotificationRouter(message);
    //           });
    //
    //         });
    //       }
    //       else
    //       {
    //         setLastNotificationId('last_notification_id' , message['data']['notification_id']).whenComplete(() {
    //           print("onResume: $message");
    //           setState(() {
    //             // notificationID = message['data']['notification_id'];
    //             _backgroundNotificationRouter(message);
    //           });
    //
    //         });
    //       }
    //
    //     }
    //
    //     // if(!await checkIfDuplicatedNotification('last_notification_id' , message['data']['notification_id']))
    //     // {
    //     //   setLastNotificationId('last_notification_id' , message['data']['notification_id']).whenComplete(() {
    //     //
    //     //     print("onLaunch: $message");
    //     //     setState(() {
    //     //       notificationID = message['data']['notification_id'];
    //     //       _backgroundNotificationRouter(message);
    //     //     });
    //     //
    //     //   });
    //     // }
    //   },
    //   onResume: (Map<String, dynamic> message) async {
    //
    //     print('on Resume section entered !!!!');
    //
    //     if(message['data']['type'] != 'chat' && !await checkIfDuplicatedNotification('last_notification_id' , message['data']['notification_id'])
    //      || message['data']['type'] == 'chat' && !await checkIfDuplicatedNotification('last_message_id' , message['data']['message_id']))
    //     {
    //       if(message['data']['type'] == 'chat')
    //         {
    //           setLastNotificationId('last_message_id' , message['data']['message_id']).whenComplete(() {
    //             print("onResume: $message");
    //               _backgroundNotificationRouter(message);
    //
    //           });
    //         }
    //       else
    //         {
    //           setLastNotificationId('last_notification_id' , message['data']['notification_id']).whenComplete(() {
    //             print("onResume: $message");
    //             setState(() {
    //               // notificationID = message['data']['notification_id'];
    //               _backgroundNotificationRouter(message);
    //             });
    //
    //           });
    //         }
    //
    //     }
    //
    //   },
    // );

  }

  @override
  void initState() {
    super.initState();
    _messageController = new TextEditingController();

    initializeNotificationsConfigs();

    setState(() {
      _isLoading = true;
    });
    _getUserChat().then((value) {
      setState(() {
        _rMessages = List.from(value);
        _isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future _getUserChat() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'user_id';
    final value = prefs.get(key);

    var data = {
      'user_id': value.toString(),
    };

    var chatResponse = await http.post(
        Uri.parse('https://iraqibayt.com/api/chats/users/' +
            widget.userID.toString() +
            '/get_chat'),
        body: data);
    var chatData = json.decode(chatResponse.body);
    Chat tChat;
    _messages = [];

    for (var chat in chatData) {
      tChat = Chat.fromJson(chat);
      print(tChat.id);

      _messages.add(tChat);
      //print('depart length is : ' + departs.length.toString());
    }

    return _messages;
  }

  void _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      FocusScope.of(context).unfocus();
      final prefs = await SharedPreferences.getInstance();
      final key = 'user_id';
      final value = prefs.get(key);

      setState(() {
        _messageBuffer = _messageController.text;
        Chat _temp = new Chat(
          id: 1,
          send: value,
          receive: int.parse(widget.userID),
          body: _messageBuffer.toString(),
          postId: 0,
          createdAt: 'منذ ثانية',
        );
        _rMessages.insert(0 , _temp);
        print('added');
        _messageController.text = '';
      });

      var data = {
        'user_id': value.toString(),
        'reciever_id': widget.userID.toString(),
        'body': _messageBuffer,
      };

      var res = await http.post(Uri.parse('https://iraqibayt.com/api/chats/send_msg'), body: data);
      var body = json.decode(res.body);
      print(body);

      if (body['status'] == 'Post Message sent successfully') {
        _getUserChat().then((value) {
          setState(() {
            _rMessages = List.from(value);
          });
        });
      }
    }
  }

  Future refreshChat() async
  {
    _getUserChat().then((value) {
      setState(() {
        _rMessages = List.from(value);
        player.play('sounds/deduction-588.mp3');
      });
    });
  }

  _messageWidget(Chat message, bool isOtherOne) {
    return Row(
      mainAxisAlignment:
          isOtherOne ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(10.0),
          margin: const EdgeInsets.all(10.0),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.65,
          ),
          decoration: BoxDecoration(
              color: isOtherOne ? Color(0xffd4e1e9) : Color(0xffc3fdab),
              borderRadius: isOtherOne
                  ? BorderRadius.all(Radius.circular(12)).subtract(
                      BorderRadius.only(bottomLeft: Radius.circular(12.0)))
                  : BorderRadius.all(Radius.circular(12)).subtract(
                      BorderRadius.only(bottomRight: Radius.circular(12.0)))),
          child: Column(
            crossAxisAlignment: isOtherOne
                ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: <Widget>[
              isOtherOne
                  ? Text(
                      widget.userName.toString(),
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xff2d3436),
                        fontFamily: "CustomIcons",
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : Container(
                      width: 1,
                      height: 1,
                    ),
              Text(
                message.body.toString(),
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                  fontFamily: "CustomIcons",
                ),
                textAlign: isOtherOne ? TextAlign.start : TextAlign.start,
              ),
              Text(
                message.createdAt.toString(),
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.blueGrey,
                  fontFamily: "CustomIcons",
                ),
                textAlign: isOtherOne ? TextAlign.start : TextAlign.end,
              ),
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.userName.toString(),
          style: TextStyle(
            fontFamily: "CustomIcons",
          ),
        ),
        backgroundColor: Color(0xff275879),
      ),
      body: StatefulBuilder(
        builder: (context, setState) {
          return SafeArea(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: !_isLoading
                      ? Container(
                          color: Color(0xffF2F2F2),
                          child: _rMessages.length != 0
                              ? ListView.builder(
                              reverse: true,
                              shrinkWrap: true,
                              // itemExtent: MediaQuery.of(context).size.height * 0.08,
                              itemCount: _rMessages.length,
                              itemBuilder: (context, index) {
                                return _messageWidget(
                                    _rMessages[index],
                                    _rMessages[index].send ==
                                        int.parse(widget.userID));
                              })
                              : Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 140.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        CircleAvatar(
                                          radius: 30,
                                          backgroundImage: NetworkImage(
                                              'https://iraqibayt.com/storage/app/public/posts/60b32311daad4.webp'),
                                        ),
                                        Text(
                                          'البيت العراقي',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black54,
                                            fontFamily: "CustomIcons",
                                          ),
                                        ),
                                        Text(
                                          'ابدأ محادثتك مع صاحب الإعلان',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black54,
                                            fontFamily: "CustomIcons",
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ))
                      : Center(
                          child: CircularProgressIndicator(),
                        ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.08,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(horizontal: 3.0),
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 5,
                        child: Container(
                          color: Colors.white60,
                          // width: MediaQuery.of(context).size.width * 0.84,
                          child: TextFormField(

                            textAlign: TextAlign.right,
                            decoration: InputDecoration(
                              hintText: 'اكتب رسالتك هنا...',
                              hintStyle: TextStyle(
                                fontSize: 15,
                                color: Colors.black54,
                                fontFamily: "CustomIcons",
                              ),
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              fillColor: Colors.white,
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(5.0),
                                borderSide: new BorderSide(),
                              ),
                            ),
                            controller: _messageController,
                            onChanged: null,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            color: Colors.blue,
                          ),
                          child: IconButton(
                              icon: Icon(
                                Icons.send,
                                color: Colors.white,
                              ),
                              color: Colors.blue,
                              onPressed: () {
                                _sendMessage();
                              }),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

