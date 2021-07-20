import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iraqibayt/modules/Comment.dart';
import 'package:iraqibayt/modules/api/callApi.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Comments extends StatefulWidget {
  final int postId;
  Comments({Key key, this.postId}) : super(key: key);

  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  TextEditingController _commentController;
  var _guest = false;
  List<Comment> _comments, _rComments;
  bool _isLoading;

  @override
  void initState() {
    super.initState();
    _commentController = new TextEditingController();

    _checkIfGuest();

    setState(() {
      _isLoading = true;
    });
    _getPostComments().then((value) {
      setState(() {
        _rComments = List.from(value);
        _isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  _checkIfGuest() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'is_login';
    final value = prefs.get(key);
    print('$value');
    if (value != '1') {
      setState(() {
        _guest = true;
      });
    }
  }

  Future _getPostComments() async {
    var commentsResponse = await http.get(Uri.parse('https://iraqibayt.com/api/posts/' +
        widget.postId.toString() +
        '/comments/all'));
    var commentsData = json.decode(commentsResponse.body);
    Comment tComment;
    _comments = [];

    for (var comment in commentsData) {
      tComment = Comment.fromJson(comment);
      print(tComment.id);

      _comments.add(tComment);
      //print('depart length is : ' + departs.length.toString());
    }

    return _comments;
  }

  void _addComment() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'user_id';
    final value = prefs.get(key);

    var data = {
      'user_id': value.toString(),
      'post_id': widget.postId.toString(),
      'body': _commentController.text,
    };

    var res = await CallApi().postData(data, '/comments/save');
    var body = json.decode(res.body);
    print(body);

    if (body['success'] == true) {
      _getPostComments().then((value) {
        setState(() {
          _rComments = List.from(value);
          _commentController.text = '';
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _guest
            ? Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        child: Center(
                          child: Column(
                            children: [
                              Text(
                                'الرجاء تسجيل الدخول لعرض التعليقات',
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
                                  Navigator.pushReplacementNamed(context, '/');
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
              )
            : Stack(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: !_isLoading && _rComments.length != 0
                        ? ListView.builder(
                            shrinkWrap: true,
                            itemExtent:
                                MediaQuery.of(context).size.height * 0.08,
                            itemCount: _rComments.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.all(5.0),
                                child: ListTile(
                                  leading: FittedBox(
                                    child: Column(
                                      children: [
                                        CircleAvatar(
                                          child: FittedBox(
                                            child: Image.asset(
                                                'assets/images/user_icon.png'),
                                          ),
                                        ),
                                        Text(
                                          _rComments[index].authorName,
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Color(0xff275879),
                                            fontFamily: "CustomIcons",
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  subtitle: Text(
                                    _rComments[index].body,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontFamily: "CustomIcons",
                                    ),
                                  ),
                                  trailing: Text(
                                    _rComments[index].createdAt,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                      fontFamily: "CustomIcons",
                                    ),
                                  ),
                                ),
                              );
                            })
                        : Center(
                            child: Text(
                              'كن أول من يضيف تعليق لهذا الإعلان',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black54,
                                fontFamily: "CustomIcons",
                              ),
                            ),
                          ),
                  ),
                  Positioned(
                      bottom: 0,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.08,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.white,
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                IconButton(
                                    icon: Icon(
                                      Icons.send,
                                      color: Color(0xff275879),
                                    ),
                                    color: Colors.white,
                                    onPressed: _addComment),
                                Container(
                                  color: Colors.white,
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: TextFormField(
                                    textAlign: TextAlign.right,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 5.0),
                                      fillColor: Colors.white,
                                      border: new OutlineInputBorder(
                                        borderRadius:
                                            new BorderRadius.circular(5.0),
                                        borderSide: new BorderSide(),
                                      ),
                                    ),
                                    controller: _commentController,
                                    onChanged: null,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ))
                ],
              ));
  }
}
