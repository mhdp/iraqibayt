import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/style.dart';
import 'dart:convert';
import 'package:iraqibayt/modules/Notification.dart';
import 'package:iraqibayt/widgets/ContactUs.dart';
import 'package:iraqibayt/widgets/chats/chats.dart';
import 'package:iraqibayt/widgets/firebase_agent.dart';
import 'package:iraqibayt/widgets/home/home.dart';
import 'package:iraqibayt/widgets/my_icons_icons.dart';
import 'package:iraqibayt/widgets/posts/add_post.dart';
import 'package:iraqibayt/widgets/posts/full_post.dart';
import 'package:iraqibayt/widgets/posts/posts_home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'my_account.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  List<NotificationSample> _notifications, _rNotifications;

  bool _isNotificationsLoading;
  bool _isAuth = true;

  Future _getUserNotifications() async {
    _notifications = [];
    final prefs = await SharedPreferences.getInstance();
    final key = 'is_login';
    final value = prefs.get(key);
    print('$value');
    if (value == '1') {
      final key2 = 'user_id';
      final value2 = prefs.get(key2);
      print(value2);

      setState(() {
        _isNotificationsLoading = true;
      });

      var data = {
        'user_id': value2.toString(),
      };

      NotificationSample tNot;

      var res = await http.post(Uri.parse('https://iraqibayt.com/api/users/notifications'),
          body: data);
      var body = json.decode(res.body);
      print(body);

      for (var not in body) {
        tNot = NotificationSample.fromJson(not);
        _notifications.add(tNot);
      }
      print('notifications length is : ' + _notifications.length.toString());
      setState(() {
        _isNotificationsLoading = false;
      });
      return _notifications;
    } else {
      setState(() {
        _isAuth = false;
      });
      return _notifications;
    }
  }

  @override
  void initState() {
    super.initState();
    _rNotifications = new List<NotificationSample>();

    setState(() {
      _isNotificationsLoading = true;
    });
    _getUserNotifications().then((value) {
      setState(() {
        _rNotifications = List.from(value);
        _isNotificationsLoading = false;
      });
    });
  }

  Future _launchNotificationURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _notificationRouter(NotificationSample notification) {
    switch (notification.type) {
      case 'local':
        if (notification.url != '#' && notification != null) {
          _launchNotificationURL(notification.url);
        }
        break;

      case 'global':
        if (notification.url != '#' && notification != null) {
          _launchNotificationURL(notification.url);
        }
        break;

      case 'comment':
        if (notification.postId != null) {
          Navigator.of(context).push(
            new MaterialPageRoute(
              builder: (BuildContext context) => new FullPost(
                post_id: notification.postId.toString(),
              ),
            ),
          );
        }
        break;

      case 'favourite':
        if (notification.postId != null) {
          Navigator.of(context).push(
            new MaterialPageRoute(
              builder: (BuildContext context) => new FullPost(
                post_id: notification.postId.toString(),
              ),
            ),
          );
        }
        break;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double screenHeight =
        MediaQuery.of(context).size.height - statusBarHeight - kToolbarHeight;

    return Scaffold(
      backgroundColor: Color(0XFFc4c4c4),
      appBar: AppBar(
        title: Text(
          'الإشعارات',
          style: TextStyle(
            fontFamily: "CustomIcons",
          ),
        ),
        backgroundColor: Color(0xff275879),
        actions: [
          FirebaseAgent(),
        ],
      ),
      body: _isNotificationsLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              child: !_isAuth
                  ? InkWell(
                      borderRadius: BorderRadius.circular(0),
                      onTap: () {},
                      child: Card(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.grey, width: 0.5),
                          borderRadius: BorderRadius.circular(0),
                        ),
                        clipBehavior: Clip.antiAlias,
                        margin: const EdgeInsets.only(top: 10.0),
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
                                  'تنبيه',
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
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text(
                                        'الرجاء تسجيل الدخول لعرض قائمة الإشعارات الخاصة بك',
                                        style: TextStyle(
                                          fontFamily: 'CustomIcons',
                                        ),
                                      ),
                                      FlatButton(
                                        color: Colors.white,
                                        textColor: Colors.black,
                                        disabledColor: Colors.grey,
                                        disabledTextColor: Colors.grey,
                                        padding: EdgeInsets.all(8.0),
                                        splashColor: Colors.orange,
                                        onPressed: () {
                                          Navigator.pushReplacementNamed(
                                              context, '/');
                                        },
                                        child: Text(
                                          'تسجيل الدخول',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black,
                                            fontFamily: "CustomIcons",
                                          ),
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
                    )
                  : Container(
                      child: _rNotifications.length == 0
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Center(
                                    child: Text(
                                      'لا يوجد لديك إشعارات حالياً',
                                      style: TextStyle(
                                        fontFamily: 'CustomIcons',
                                        fontSize: 18,
                                        color: Colors.blueGrey,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: screenHeight,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: _rNotifications.length,
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () {
                                            _notificationRouter(
                                                _rNotifications[index]);
                                          },
                                          child: Card(
                                            elevation: 3,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8.0),
                                              child: ListTile(
                                                leading: CircleAvatar(
                                                  radius: 30,
                                                  backgroundImage: NetworkImage(
                                                      'https://iraqibayt.com/storage/app/public/posts/60b32311daad4.webp'),
                                                ),
                                                title: Text(
                                                  _rNotifications[index]
                                                      .content,
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontFamily: 'CustomIcons'
                                                      //fontWeight: FontWeight.bold,
                                                      ),
                                                ),
                                                trailing: Text(
                                                  _rNotifications[index]
                                                      .createdAt,
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    fontFamily: 'CustomIcons',
                                                    color: Colors.blueGrey,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
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
        selectedItemColor: Color(0xFFdd685f),
        onTap: onTabTapped, // new
        currentIndex: 4,
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
              icon: Icon(Icons.message), label: 'الرسائل'),
          new BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: 'الإشعارات'),
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
    } else if (index == 0) {
      Navigator.of(context).push(
          new MaterialPageRoute(builder: (BuildContext context) => new Home()));
    } else if (index == 3) {
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => new Chats()));
    } else if (index == 2) {
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => new MyAccount()));
    }
    /*setState(() {
      _currentIndex = index;
      print(index.toString());
    });*/
  }
}
