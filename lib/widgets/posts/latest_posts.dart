import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:iraqibayt/modules/Favorite.dart';
import 'package:iraqibayt/modules/api/callApi.dart';
import 'package:iraqibayt/modules/db_helper.dart';
import 'package:iraqibayt/widgets/home/search_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../my_icons_icons.dart';
import '../welcome.dart';
import 'full_post.dart';

DatabaseHelper databaseHelper = new DatabaseHelper();

String default_image = "";
bool _isVisible;
String _email, _password;

class latest_posts extends StatefulWidget {
  @override
  _latest_posts createState() => _latest_posts();
}

class _latest_posts extends State<latest_posts> {

  var is_loading = true;

  void initState() {
    super.initState();
    /*setState(() {
      _isVisible = false;
    });*/

    databaseHelper.get_default_post_image().whenComplete(() {
      setState(() {
        default_image = databaseHelper.default_post_image;
      });
    });

    databaseHelper.get_latest_posts().whenComplete(() {
      setState(() {
        is_loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return is_loading
        ? new Center(
      child: new GFLoader(type: GFLoaderType.circle),
    )
        : BikeListItem(list1: databaseHelper.latest_posts_list);


  }
}

class BikeListItem extends StatefulWidget {
  var list1;

  BikeListItem({
    this.list1,
  });

  @override
  _BikeListItemState createState() => _BikeListItemState();
}

class _BikeListItemState extends State<BikeListItem> {
  List<Favorite> _favorites, _rFavorites;
  List<int> _favsIds, _rFavsIds;

  Future _getUserFavorites() async {
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

    var data = {
      'email': _email,
      'password': _password,
    };

    Favorite tFav;
    _favorites = [];
    _favsIds = [];

    var res = await CallApi().postData(data, '/users/favorit');
    var body = json.decode(res.body);
    print(body);

    if (body['success'] == true && body['favorites'] != null) {
      for (var fav in body['favorites']) {
        tFav = Favorite.fromJson(fav);
        _favorites.add(tFav);
        //_favsIds.add(tFav.postId);
      }

      return _favorites;
    }
  }

  int _checkIfInFavs(int pid, List<Favorite> favsPosts) {
    try {
      for (Favorite fav in favsPosts) if (pid == fav.postId) return fav.id;
    } catch (e) {
      return null;
    }
  }

  _addFavorite(int pid) async {
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

      var data = {
        'id': pid,
        'email': _email,
        'password': _password,
      };

      var res = await CallApi().postData(data, '/favorites/add');
      var body = json.decode(res.body);
      print(body);

      _getUserFavorites().then((value) {
        setState(() {
          _rFavorites = List.from(value);
        });
      });
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)),
                elevation: 16,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.38,
                  width: MediaQuery.of(context).size.height * 0.4,
                  child: Column(
                    children: [
                      Container(
                        child: Center(
                          child: Text(
                            'تنبيه',
                            style: TextStyle(
                              fontFamily: 'CustomIcons',
                              fontSize: 30.0,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Divider(
                          thickness: 1.0,
                          color: Colors.black54,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(30.0),
                        child: Center(
                          child: Text(
                            'يجب عليك تسجيل الدخول أولاً لكي تتمكن من المتابعة',
                            style: TextStyle(
                                fontFamily: 'CustomIcons', fontSize: 20.0),
                          ),
                        ),
                      ),
                      Container(
                        //padding: const EdgeInsets.all(10.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: GFButton(
                              color: GFColors.LIGHT,
                              //blockButton: true,
                              child: Center(
                                child: Text(
                                  'تسجيل الدخول',
                                  style: TextStyle(
                                      fontFamily: 'CustomIcons',
                                      fontSize: 20.0),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Welcome()),
                                      (Route<dynamic> route) => false,
                                );
                              }),
                        ),
                      ),
                    ],
                  ),
                ));
          });
    }
  }

  _deleteFavorite(int fid) async {
    var data = {
      'id': fid,
      'email': _email,
      'password': _password,
    };

    var res = await CallApi().postData(data, '/favorites/delete');
    var body = json.decode(res.body);
    print(body);

    if (body['success'] == true) {
      _getUserFavorites().then((value) {
        setState(() {
          _rFavorites = List.from(value);
        });
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getUserFavorites().then((value) {
      setState(() {
        _rFavorites = List.from(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //print('list ${databaseHelper.spicial_posts_list.length.toString()}');
    if (widget.list1.length > 0) {
      var data = widget.list1;

      return Column(
        children: [
          for (var i = 0; i < widget.list1.length; i++)
            post_widget(i)
        ],
      );




    } else {
      return Text(
        'لا يوجد إعلانات',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
          fontFamily: "CustomIcons",
        ),
        softWrap: true,
      );
    }
  }

  post_widget(int i){
    var data = widget.list1;

    var show_icons = true;

    var img = data[i]['img'].toString();
    //print("img: $img");
    if (img == "") {
      img = default_image;
      //print("img: $img");
    }

    var bath = data[i]['bathroom'];
    if (bath == null) {
      show_icons = false;
      bath = "0";
    }

    var bed = data[i]['bedroom'];
    if (bed == null) {
      show_icons = false;
      bed = "0";
    }

    var car_num = data[i]['num_car'];
    if (car_num == null) {
      car_num = "0";
    }

    return new Container(
      padding: const EdgeInsets.all(0),
      child: new GestureDetector(
        onTap: () {},
        child: InkWell(
          borderRadius: BorderRadius.circular(4.0),
          onTap: () {
            Navigator.of(context).push(
              new MaterialPageRoute(
                  builder: (BuildContext context) =>
                  new FullPost(
                    post_id: data[i]['id'].toString(),
                  )),
            );
          },
          child: Card(
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.grey, width: 0.5),
              borderRadius: BorderRadius.circular(10),
            ),
            clipBehavior: Clip.antiAlias,
            elevation: 0,
            margin: const EdgeInsets.all(10.0),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: Stack(
                    fit: StackFit.passthrough,
                    children: <Widget>[
                      Padding(
                  padding: const EdgeInsets.all(6),
                  child:img == 'null'
                          ? Image.asset(
                        'assets/images/posts/default_post_img.jpeg',
                        fit: BoxFit.fill,
                        height: MediaQuery.of(context)
                            .size
                            .width /
                            1.5,
                      )
                          : Image.network(
                        "https://iraqibayt.com/storage/app/public/posts/$img",
                        fit: BoxFit.cover,
                        height: MediaQuery.of(context)
                            .size
                            .width /
                            2.5,
                      )),
                      Padding(
                        padding: const EdgeInsets.all(6),
                        child:Flex(
                        direction: Axis.horizontal,
                        mainAxisAlignment:
                        MainAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(3.0),
                            margin: const EdgeInsets.only(
                                top: 50.0),
                            constraints: BoxConstraints(),
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                              border: Border.all(
                                color: Colors.redAccent,
                              ),
                              borderRadius: BorderRadius.only(

                                topRight:Radius.circular(10.0),
                                bottomRight:Radius.circular(10.0),
                              ),
                            ),
                            child: Text(
                              "${data[i]['category']['name']}",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontFamily: "CustomIcons",
                              ),
                            ),
                          ),
                        ],
                      ),),
                      Padding(
                        padding: const EdgeInsets.all(6),
                        child:Flex(
                        direction: Axis.horizontal,
                        mainAxisAlignment:
                        MainAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(3.0),
                            margin: const EdgeInsets.only(
                                top: 90.0),
                            constraints: BoxConstraints(),
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                              border: Border.all(
                                color: Colors.redAccent,
                              ),
                              borderRadius: BorderRadius.only(

                                topRight:Radius.circular(10.0),
                                bottomRight:Radius.circular(10.0),
                              ),
                            ),
                            child: Text(
                              "${data[i]['price']} ${data[i]['currancy']['name']}",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontFamily: "CustomIcons",
                              ),
                            ),
                          ),
                        ],
                      ),)
                    ],
                  ),
                ),
//                                ButtonBar(
//                                  alignment: MainAxisAlignment.center,
//                                  children: [
//                                    FlatButton(
//                                      shape: RoundedRectangleBorder(
//                                          borderRadius:
//                                              BorderRadius.circular(5.0),
//                                          side: BorderSide(
//                                              color: Color(0xFFdd685f))),
//                                      color: Color(0xFFdd685f),
//                                      onPressed: () {
//                                        // Perform some action
//                                      },
//                                      child: Text(
//                                        "${data[i]['price']} ${data[i]['currancy']['name']}",
//                                        style: TextStyle(
//                                          fontSize: 18,
//                                          color: Colors.white,
//                                          fontFamily: "CustomIcons",
//                                        ),
//                                        softWrap: true,
//                                      ),
//                                    ),
//                                    FlatButton(
//                                      shape: RoundedRectangleBorder(
//                                          borderRadius:
//                                              BorderRadius.circular(5.0),
//                                          side: BorderSide(
//                                              color: Color(0xFFdd685f))),
//                                      color: Color(0xFFdd685f),
//                                      onPressed: () {
//                                        // Perform some action
//                                      },
//                                      child: Text(
//                                        "${data[i]['category']['name']}",
//                                        style: TextStyle(
//                                          fontSize: 18,
//                                          color: Colors.white,
//                                          fontFamily: "CustomIcons",
//                                        ),
//                                        softWrap: true,
//                                      ),
//                                    ),
//                                  ],
//                                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    data[i]['title'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.black,
                      fontFamily: "CustomIcons",
                    ),
                    softWrap: true,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                  ),
                  child: Divider(
                    color: Colors.black,
                    thickness: 0.5,
                  ),
                ),
                RaisedButton(
                  onPressed: () {},
                  color: Colors.white,
                  elevation: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(Icons.location_on,
                          color: Color(0xff275879)),
                      Text(
                        "${data[i]['city']['name']} - ${data[i]['region']['name']}",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontFamily: "CustomIcons",
                          fontWeight: FontWeight.w300,
                        ),
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
                RaisedButton(
                  onPressed: () {},
                  color: Colors.white,
                  elevation: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(Icons.format_line_spacing,
                          color: Color(0xff275879)),
                      Text(
                        " المساحة:  ${data[i]['area']} ${data[i]['unit']['name']}",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontFamily: "CustomIcons",
                          fontWeight: FontWeight.w300,
                        ),
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
                RaisedButton(
                  onPressed: () {},
                  color: Colors.white,
                  elevation: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.add_box,
                        color: Color(0xff275879),
                      ),
                      Text(
                        " أضيف: ${data[i]['created_at']}",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontFamily: "CustomIcons",
                          fontWeight: FontWeight.w300,
                        ),
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
                show_icons
                    ? Row(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 3, // 20%
                      child: Column(
                        mainAxisAlignment:
                        MainAxisAlignment.end,
                        children: [
                          Icon(
                            MyIcons.car,
                          ),
                          Text(car_num.toString()),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 3, // 20%
                      child: Column(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [
                          Icon(
                            MyIcons.bed,
                          ),
                          Text(bed.toString()),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 3, // 20%
                      child: Column(
                        mainAxisAlignment:
                        MainAxisAlignment.start,
                        children: [
                          Icon(MyIcons.bath),
                          Text(bath.toString()),
                        ],
                      ),
                    ),
                  ],
                )
                    : Container(),
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: Container(
                      color: Colors.grey,
                      margin: const EdgeInsets.only(
                          top: 10.0, bottom: 0.0),
                      padding: const EdgeInsets.all(0.0),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [
                          RaisedButton(
                            onPressed: () {},
                            color: Colors.white,
                            elevation: 0,
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.call,
                                  color: Color(0xFFdd685f),
                                ),
                                Text(
                                  data[i]['phone'],
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontFamily: "CustomIcons",
                                    fontWeight: FontWeight.w300,
                                  ),
                                  softWrap: true,
                                ),
                              ],
                            ),
                          ),
                          _checkIfInFavs(data[i]['id'],
                              _rFavorites) ==
                              null
                              ? RaisedButton(
                            onPressed: () {
                              _addFavorite(data[i]['id']);
                            },
                            color: Colors.red,
                            elevation: 0,
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .center,
                              children: <Widget>[
                                Icon(
                                  Icons.favorite,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          )
                              : RaisedButton(
                            onPressed: () {
                              _deleteFavorite(
                                  _checkIfInFavs(
                                      data[i]['id'],
                                      _rFavorites));
                            },
                            color: Color(0xffdfe4ea),
                            elevation: 0,
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .center,
                              children: <Widget>[
                                Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}