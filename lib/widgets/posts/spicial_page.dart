import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:iraqibayt/modules/Favorite.dart';
import 'package:iraqibayt/modules/api/callApi.dart';
import 'package:iraqibayt/modules/db_helper.dart';
import 'package:iraqibayt/widgets/chats/chats.dart';
import 'package:iraqibayt/widgets/firebase_agent.dart';
import 'package:iraqibayt/widgets/home/home.dart';
import 'package:iraqibayt/widgets/home/search_card.dart';
import 'package:iraqibayt/widgets/my_icons_icons.dart';
import 'package:iraqibayt/widgets/notifications.dart';
import 'package:iraqibayt/widgets/posts/full_post.dart';
import 'package:iraqibayt/widgets/posts/posts_home.dart';
import 'package:iraqibayt/widgets/welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../ContactUs.dart';
import '../profile.dart';
import 'add_post.dart';

DatabaseHelper databaseHelper = new DatabaseHelper();

String default_image = "";
bool _isVisible;
String _token;

class Spical_page extends StatefulWidget {
  @override
  _Spical_page createState() => _Spical_page();
}

class _Spical_page extends State<Spical_page> {
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

    databaseHelper.get_all_spicial_posts().whenComplete(() {
      setState(() {
        is_loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double screenHeight =
        MediaQuery.of(context).size.height - statusBarHeight - kToolbarHeight;
    return Scaffold(
      backgroundColor: Color(0XFFc4c4c4),
      appBar: AppBar(
        backgroundColor: Color(0xFF335876),
        title: Text(
          "الإعلانات المميزة",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
            fontFamily: "CustomIcons",
          ),
        ),
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
                    color: Colors.white,
                  ),
                  Text(
                    " أضف إعلان ",
                    style: TextStyle(
                      fontSize: 20,
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

        child: is_loading
            ? new Center(
          child: new GFLoader(type: GFLoaderType.circle),
        )
            : BikeListItem(list1: databaseHelper.all_spicial_posts_list),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF335876),
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.white,
        onTap: onTabTapped, // new
        currentIndex: 1,
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
    if (index == 0) {
      Navigator.of(context).push(
        new MaterialPageRoute(builder: (BuildContext context) => new Home()),
      );
    } else if (index == 1) {
      Navigator.of(context).push(
        new MaterialPageRoute(
            builder: (BuildContext context) => new Posts_Home()),
      );
    }else if (index == 2) {
      Navigator.of(context).push(
        new MaterialPageRoute(
            builder: (BuildContext context) => new Add_Post()),
      );
    } else if (index == 3) {
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => new Profile()));
    } else if (index == 4) {
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
      final key2 = 'token';
      final value2 = prefs.get(key2);

      setState(() {
        _token = value2;
      });
    }

    var data = {
      'token': _token,
    };

    Favorite tFav;
    _favorites = [];

    var res = await CallApi().postData(data, '/users/favorit');
    var body = json.decode(res.body);
    print(body);

    if (body['success'] == true && body['favorites'] != null) {
      for (var fav in body['favorites']) {
        tFav = Favorite.fromJson(fav);
        _favorites.add(tFav);
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
      final key2 = 'token';
      final value2 = prefs.get(key2);

      setState(() {
        _token = value2;
      });

      var data = {
        'id': pid,
        'token': _token,
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
                              color: Color(0xFF335876),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Divider(
                          thickness: 1.0,
                          color: Color(0xFF335876),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(30.0),
                        child: Center(
                          child: Text(
                            'يجب عليك تسجيل الدخول أولاً لكي تتمكن من إضافة الإعلان إلى المفضلة',
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
                              color: Color(0xFF335876),
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
      'token': _token,
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

      return SingleChildScrollView(
          child: Column(
        children: [
          for (var i = 0; i < widget.list1.length; i++)
            post_widget(i)
        ],
      ));




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
    if (img == "" || img== null) {
      img = default_image;
      //print("img: $img");
    }

    var bath = data[i]['bathroom'];
    if (bath == 'null' || bath == null) {
      show_icons = false;
      bath = "0";
    }

    var bed = data[i]['bedroom'];
    if (bed == 'null' || bed == null) {
      show_icons = false;
      bed = "0";
    }

    var car_num = data[i]['num_car'];
    if (car_num == 'null' || car_num == null) {
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
              borderRadius: BorderRadius.circular(0),
            ),
            clipBehavior: Clip.antiAlias,
            elevation: 0,
            margin: const EdgeInsets.only(top:10.0),
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
                                1.5,
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

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    data[i]['title'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      color: Color(0xFF335876),
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
                            MyIcons.car, color: Color(0xFF335876),
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
                            MyIcons.bed,color: Color(0xFF335876),
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
                          Icon(MyIcons.bath,color: Color(0xFF335876),),
                          Text(bath.toString()),
                        ],
                      ),
                    ),
                  ],
                )
                    : Container(),
//Divider
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

                Padding(
                  padding: const EdgeInsets.all(0),
                  child: Container(
                      color: Colors.white,
                      margin: const EdgeInsets.only(
                          top: 0, bottom: 0.0),
                      padding: const EdgeInsets.all(0.0),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [
                          FlatButton(
                            onPressed: () async {
                              var url = "tel:+${data[i]['phone'].toString().trim()}";
                              print(url);
                              if (await canLaunch(url)) {
                                await launch(url);
                              }
                            },
                            shape: RoundedRectangleBorder(side: BorderSide(
                                color: Color(0xFF335876),
                                width: 0,
                                style: BorderStyle.solid
                            ),),

                            color: Color(0xFF335876),

                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.call,
                                  color: Colors.white,
                                ),
                                Text(
                                  data[i]['phone'],
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
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
                              ? FlatButton(
                            onPressed: () {
                              _addFavorite(data[i]['id']);
                            },
                            shape: RoundedRectangleBorder(side: BorderSide(
                                color: Colors.red,
                                width: 0,
                                style: BorderStyle.solid
                            ),),
                            color: Colors.red,
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .center,
                              children: <Widget>[
                                Icon(
                                  Icons.favorite_border,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          )
                              : FlatButton(
                            onPressed: () {
                              _deleteFavorite(
                                  _checkIfInFavs(
                                      data[i]['id'],
                                      _rFavorites));
                            },
                            shape: RoundedRectangleBorder(side: BorderSide(
                                color: Colors.red,
                                width: 0,
                                style: BorderStyle.solid
                            ),),
                            color: Colors.red,
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

  phone_call() async {
    const url = 'https://flutter.dev';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
