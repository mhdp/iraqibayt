import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:getwidget/getwidget.dart';
import 'package:iraqibayt/modules/Favorite.dart';
import 'package:iraqibayt/modules/Post.dart';
import 'package:iraqibayt/widgets/posts/full_post.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iraqibayt/modules/api/callApi.dart';

class MyPosts extends StatefulWidget {
  @override
  _MyPostsState createState() => _MyPostsState();
}

class _MyPostsState extends State<MyPosts> {
  List<Post> _posts, _rPosts;

  String _password;
  String _email;

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
      final key2 = 'email';
      final key3 = 'pass';
      final value2 = prefs.get(key2);
      print(value2);
      final value3 = prefs.get(key3);
      print(value3);
      setState(() {
        _email = value2;
        _password = value3;
      });
    }
  }

  Future _getUserPosts() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'is_login';
    final value = prefs.get(key);
    print('$value');
    if (value == '1') {
      final key2 = 'email';
      final key3 = 'pass';
      final value2 = prefs.get(key2);
      print(value2);
      final value3 = prefs.get(key3);
      print(value3);

      setState(() {
        _email = value2;
        _password = value3;
      });
    }

    setState(() {
      _isPostLoading = true;
    });
    var data = {
      'email': _email,
      'password': _password,
    };

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
    }
  }

  _deletePost(int pid) async {
    var data = {
      'id': pid,
      'email': _email,
      'password': _password,
    };

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
                                                                    IconButton(
                                                                      icon: Icon(
                                                                          Icons
                                                                              .delete),
                                                                      color: Colors
                                                                          .red,
                                                                      onPressed:
                                                                          () {
                                                                        _deletePost(
                                                                            post.id);
                                                                      },
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
    );
  }
}
