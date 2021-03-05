import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/colors/gf_color.dart';
import 'package:getwidget/components/badge/gf_badge.dart';
import 'dart:convert';
import 'package:iraqibayt/modules/User.dart';
import 'package:iraqibayt/widgets/ContactUs.dart';
import 'package:iraqibayt/widgets/chats/user_chat.dart';
import 'package:iraqibayt/widgets/firebase_agent.dart';
import 'package:iraqibayt/widgets/home/home.dart';
import 'package:iraqibayt/widgets/my_icons_icons.dart';
import 'package:iraqibayt/widgets/notifications.dart';
import 'package:iraqibayt/widgets/posts/add_post.dart';
import 'package:iraqibayt/widgets/posts/posts_home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Chats extends StatefulWidget {
  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  List<User> _users, _rUsers;
  List<String> _unreadMessages = [];

  bool _isUsersLoading;
  bool _isAuth = true;

  Future _getChatsUsers() async {
    _users = [];
    final prefs = await SharedPreferences.getInstance();
    final key = 'is_login';
    final value = prefs.get(key);
    print('$value');
    if (value == '1') {
      final key2 = 'user_id';
      final value2 = prefs.get(key2);
      print(value2);

      setState(() {
        _isUsersLoading = true;
      });

      var data = {
        'user_id': value2.toString(),
      };

      User tUser;

      var res = await http.post(
          'https://iraqibayt.com/api/chats/users/get_interseted_users',
          body: data);
      var body = json.decode(res.body);
      print(body);

      for (var user in body) {
        tUser = User.fromJson(user);
        _users.add(tUser);
      }
      print('users length is : ' + _users.length.toString());

      return _users;
    } else {
      setState(() {
        _isAuth = false;
      });
      return _users;
    }
  }

  Future getUserUnreadMessages(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    final key2 = 'user_id';
    final value2 = prefs.get(key2);

    var data = {
      'user_id': value2.toString(),
    };

    try {
      var res = await http.post(
          'https://iraqibayt.com/api/chats/users/' +
              uid +
              '/get_unread_msgs_count',
          body: data);
      //print(res.body);
      //print('sending...');
      var body = json.decode(res.body);
      print(body);

      return body;
    } catch (e) {
      return ' ';
    }
  }

  Future getUsersBadges(List<User> users) async {
    _unreadMessages.length = users.length;

    for (int i = 0; i < users.length; i++) {
      await getUserUnreadMessages(users[i].id.toString()).then((value) {
        setState(() {
          _unreadMessages[i] = value.toString();
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _rUsers = new List<User>();
    _unreadMessages = new List<String>();

    setState(() {
      _isUsersLoading = true;
    });
    _getChatsUsers().then((value) {
      setState(() {
        _rUsers = List.from(value);
        getUsersBadges(_rUsers).whenComplete(() {
          setState(() {
            _isUsersLoading = false;
          });
        });
      });
    });
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
          'الرسائل',
          style: TextStyle(
            fontFamily: "CustomIcons",
          ),
        ),
        backgroundColor: Color(0xff275879),
        actions: [
          FirebaseAgent(),
        ],
      ),
      body: _isUsersLoading
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
                                        'الرجاء تسجيل الدخول لعرض الأشخاص الذين قاموا بمراسلتك',
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
                  : Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: screenHeight,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: _rUsers.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        new MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                new UserChat(
                                                  userID: _rUsers[index]
                                                      .id
                                                      .toString(),
                                                  userName: _rUsers[index]
                                                      .name
                                                      .toString(),
                                                )));
                                  },
                                  child: Card(
                                    elevation: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          child: Image.asset(
                                              'assets/images/user_icon.png'),
                                        ),
                                        title: Text(
                                          _rUsers[index].name,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontFamily: 'CustomIcons'
                                              //fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        trailing: GFBadge(
                                          color: _unreadMessages[index]
                                                      .toString() ==
                                                  '0'
                                              ? Colors.white
                                              : GFColors.DANGER,
                                          textColor: Colors.white,
                                          child: Text(
                                            _unreadMessages[index].toString(),
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontFamily: 'CustomIcons',
                                              // color: Colors.blueGrey,
                                            ),
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
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF335876),
        unselectedItemColor: Colors.white,
        selectedItemColor: Color(0xFFdd685f),
        onTap: onTabTapped, // new
        currentIndex: 5,
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
    } else if (index == 2) {
      Navigator.of(context).push(
        new MaterialPageRoute(
            builder: (BuildContext context) => new Add_Post()),
      );
    } else if (index == 0) {
      Navigator.of(context).push(
          new MaterialPageRoute(builder: (BuildContext context) => new Home()));
    } else if (index == 4) {
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => new ContactUs()));
    } else if (index == 5) {
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
