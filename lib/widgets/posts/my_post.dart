import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:getwidget/getwidget.dart';
import 'package:iraqibayt/modules/Favorite.dart';
import 'package:iraqibayt/modules/Post.dart';
import 'package:iraqibayt/widgets/chats/chats.dart';
import 'package:iraqibayt/widgets/firebase_agent.dart';
import 'package:iraqibayt/widgets/home/home.dart';
import 'package:iraqibayt/widgets/notifications.dart';
import 'package:iraqibayt/widgets/posts/full_post.dart';
import 'package:iraqibayt/widgets/posts/posts_home.dart';
import 'package:iraqibayt/widgets/posts/update_post.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iraqibayt/modules/api/callApi.dart';

import '../ContactUs.dart';
import '../my_account.dart';
import '../my_icons_icons.dart';
import '../welcome.dart';
import 'add_post.dart';

class MyPosts extends StatefulWidget {
  @override
  _MyPostsState createState() => _MyPostsState();
}

class _MyPostsState extends State<MyPosts> {
  List<Post> _posts, _rPosts;

  String _token;

  var _guest = false;
  bool _isPostLoading;

  _checkIfGuest() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'is_login';
    final value = prefs.get(key);
    print('$value');
    if (value != '1') {
      setState(() {
        _guest = true;
      });
    } else {
      final key = 'name';
      final value = prefs.get(key);
      setState(() {});
    }
  }

  _getUserdata() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'is_login';
    final value = prefs.get(key);
    print('$value');
    if (value == '1') {
      final key2 = 'token';
      final value2 = prefs.get(key2);
      print(value2);
      setState(() {
        _token = value2;
      });
    }
  }

  Future _getUserPosts() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'is_login';
    final value = prefs.get(key);
    print('$value');
    if (value == '1') {
      final key2 = 'token';
      final value2 = prefs.get(key2);
      print(value2);
      setState(() {
        _token = value2;
        print('token: $_token');
      });
    }

    setState(() {
      _isPostLoading = true;
    });
    var data = {'token': _token};

    Post tPost;
    _posts = [];

    var res = await CallApi().postData(data, '/get_my_posts_api');
    var body = json.decode(res.body);
    print(body);

    if (body['success'] == true) {
      for (var post in body['posts']['data']) {
        tPost = Post.fromJson(post);
        _posts.add(tPost);
      }
      print('posts length is : ' + _posts.length.toString());
      setState(() {
        _isPostLoading = false;
      });
      return _posts;
    }else{
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => new Welcome()));
    }
  }

  _deletePost(int pid) async {
    var data = {'id': pid, 'token': _token};

    var res = await CallApi().postData(data, '/posts/delete');
    var body = json.decode(res.body);
    print(body);

    if (body['success'] == true) {
      _getUserPosts().then((value) {
        setState(() {
          _rPosts = List.from(value);
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _rPosts = new List<Post>();

    _checkIfGuest();
    _getUserdata();
    setState(() {
      _isPostLoading = true;
    });
    _getUserPosts().then((value) {
      setState(() {
        _rPosts = List.from(value);
        _isPostLoading = false;
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
      backgroundColor: Color(0XFF8e8d8d),
      appBar: AppBar(
        title: Text(
          'إعلاناتي',
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
      body: SingleChildScrollView(
        child: LayoutBuilder(
          builder: (ctx, constraints) {
            if (_guest) {
              return Row(
                children: [
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(4.0),
                      onTap: () {},
                      child: Card(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.grey, width: 0.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        clipBehavior: Clip.antiAlias,
                        margin: const EdgeInsets.all(10.0),
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
                                  'الإعلانات',
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
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      child: Center(
                                        child: Column(
                                          children: [
                                            Text(
                                              'الرجاء تسجيل الدخول لعرض الإعلانات التي قمت بإضافتها',
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
                                                  color: Colors.grey,
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
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          borderRadius: BorderRadius.circular(4.0),
                          onTap: () {},
                          child: SingleChildScrollView(
                            child: Card(
                              shape: RoundedRectangleBorder(
                                side:
                                    BorderSide(color: Colors.grey, width: 0.5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              clipBehavior: Clip.antiAlias,
                              margin: const EdgeInsets.all(10.0),
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
                                        'الإعلانات التي قمت بإضافتها',
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
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                child: _isPostLoading
                                                    ? Container(
                                                        height: 100,
                                                        child: Center(
                                                          child:
                                                              new CircularProgressIndicator(),
                                                        ),
                                                      )
                                                    : DataTable(
                                                        columns: <DataColumn>[
                                                          DataColumn(
                                                            label: Text(
                                                              'العنوان',
                                                              style: TextStyle(
                                                                fontSize: 18,
                                                                color: Colors
                                                                    .lightBlue,
                                                                fontFamily:
                                                                    "CustomIcons",
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                            ),
                                                          ),
                                                          DataColumn(
                                                            label: Text(
                                                              'التحكم',
                                                              style: TextStyle(
                                                                fontSize: 18,
                                                                color: Colors
                                                                    .lightBlue,
                                                                fontFamily:
                                                                    "CustomIcons",
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                            ),
                                                          ),
                                                        ],
                                                        rows: _rPosts
                                                            .map(
                                                              (post) => DataRow(
                                                                cells: [
                                                                  DataCell(
                                                                    FittedBox(
                                                                      child: InkWell(
                                                                          onTap: () {
                                                                            Navigator.of(context).push(
                                                                              new MaterialPageRoute(
                                                                                builder: (BuildContext context) => new FullPost(
                                                                                  post_id: post.id.toString(),
                                                                                ),
                                                                              ),
                                                                            );
                                                                          },
                                                                          child: Text(
                                                                            post.title,
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 18,
                                                                              fontFamily: "CustomIcons",
                                                                            ),
                                                                            textAlign:
                                                                                TextAlign.right,
                                                                          )),
                                                                    ),
                                                                  ),
                                                                  DataCell(
                                                                    Row(
                                                                      children: [

                                                                        IconButton(
                                                                          icon:
                                                                              Icon(Icons.edit),
                                                                          color:
                                                                              Colors.blue,
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.of(context).push(
                                                                              new MaterialPageRoute(
                                                                                  builder: (BuildContext context) => new UpdatePost(
                                                                                        postId: post.id.toString(),
                                                                                      )),
                                                                            );
                                                                          },
                                                                        ),
                                                                        IconButton(
                                                                          icon:
                                                                          Icon(Icons.delete),
                                                                          color:
                                                                          Colors.red,
                                                                          onPressed:
                                                                              () {
                                                                                Alert(
                                                                                  context: context,
                                                                                  type: AlertType.none,
                                                                                  title: "",
                                                                                  desc: "هل أنت متأكد من رغبتك في حذف هذا الإعلان",
                                                                                  buttons: [
                                                                                    DialogButton(
                                                                                      child: Text(
                                                                                        "حذف الإعلان",
                                                                                        style: TextStyle(color: Colors.white, fontSize: 20),
                                                                                      ),
                                                                                      onPressed: () => {
                                                                                        setState(() {
                                                                                          _deletePost(post.id);


                                                                                        }),
                                                                                      Navigator.pop(context),


                                                                                        //Navigator.pop(context),

                                                                                      },
                                                                                      color: Colors.red,
                                                                                    ),
                                                                                    DialogButton(
                                                                                        child: Text(
                                                                                          "إلغاء",
                                                                                          style: TextStyle(color: Colors.white, fontSize: 20),
                                                                                        ),
                                                                                        onPressed: () => Navigator.pop(context),
                                                                                        color: Colors.grey
                                                                                    )
                                                                                  ],
                                                                                ).show();


                                                                          },
                                                                        ),

                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                            .toList(),
                                                      ),
                                              ),
                                            ],
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
                      ),
                    ],
                  ),
                ],
              );
            }
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF335876),
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.white,
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
    if(index == 1){
      Navigator.of(context).push(
        new MaterialPageRoute(
            builder: (BuildContext context) => new Posts_Home()),
      );
    }else if(index == 2){
      Navigator.of(context).push(
        new MaterialPageRoute(
            builder: (BuildContext context) => new Add_Post()),
      );
    }else if(index == 0){
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => new Home()));
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
