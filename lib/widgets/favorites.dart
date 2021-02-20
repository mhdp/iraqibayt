import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:getwidget/getwidget.dart';
import 'package:iraqibayt/modules/Favorite.dart';
import 'package:iraqibayt/widgets/firebase_agent.dart';
import 'package:iraqibayt/widgets/posts/add_post.dart';
import 'package:iraqibayt/widgets/posts/full_post.dart';
import 'package:iraqibayt/widgets/posts/posts_home.dart';
import 'package:iraqibayt/widgets/profile.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iraqibayt/modules/api/callApi.dart';

import 'ContactUs.dart';
import 'home/home.dart';
import 'my_account.dart';
import 'my_icons_icons.dart';

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  List<Favorite> _favorites, _rFavorites;

  String _token;
  String delete_icon_text = "إزالة";
  var _guest = false;
  bool _isFavLoading;

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

  Future _getUserFavorites() async {
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

    setState(() {
      _isFavLoading = true;
    });
    var data = {
      'token': _token,
    };

    Favorite tFav;
    _favorites = [];

    var res = await CallApi().postData(data, '/users/favorit');
    var body = json.decode(res.body);
    print(body);

    if (body['success'] == true) {
      for (var fav in body['favorites']) {
        tFav = Favorite.fromJson(fav);
        _favorites.add(tFav);
      }
      print('favorite length is : ' + _favorites.length.toString());
      setState(() {
        _isFavLoading = false;
      });
      return _favorites;
    }
  }

  _deleteFavorite(int fid) async {
    setState(() {
      delete_icon_text = "جار الإزالة...";
    });

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
          Navigator.pop(context);
          delete_icon_text = "إزالة";
        });
      });
    }

    setState(() {
      delete_icon_text = "إزالة";
    });
  }

  @override
  void initState() {
    super.initState();
    _rFavorites = new List<Favorite>();

    _checkIfGuest();
    _getUserdata();
    setState(() {
      _isFavLoading = true;
    });
    _getUserFavorites().then((value) {
      setState(() {
        _rFavorites = List.from(value);
        _isFavLoading = false;
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
      backgroundColor: Color(0XFFc4c4c4),
      appBar: AppBar(
        title: Text(
          'االمفضلة',
          style: TextStyle(
            fontFamily: "CustomIcons",
          ),
        ),
        backgroundColor: Color(0xff275879),
        actions: [
          FirebaseAgent(),
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

                      borderRadius: BorderRadius.circular(0),
                      onTap: () {},
                      child: Card(

                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.grey, width: 0.5),
                          borderRadius: BorderRadius.circular(0),
                        ),
                        clipBehavior: Clip.antiAlias,
                        margin: const EdgeInsets.only(top:10.0),
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
                                              'الرجاء تسجيل الدخول لعرض الإعلانات التي قمت بإضافتها إلى المفضلة',
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
                                        'الإعلانات المفضلة',
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
                                                child: _isFavLoading
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
                                                        rows: _rFavorites
                                                            .map(
                                                              (favorite) =>
                                                                  DataRow(
                                                                cells: [
                                                                  DataCell(
                                                                    FittedBox(
                                                                      child: InkWell(
                                                                          onTap: () {
                                                                            Navigator.of(context).push(
                                                                              new MaterialPageRoute(
                                                                                builder: (BuildContext context) => new FullPost(
                                                                                  post_id: favorite.postId.toString(),
                                                                                ),
                                                                              ),
                                                                            );
                                                                          },
                                                                          child: Text(
                                                                            favorite.postTitle,
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
                                                                          Icons.delete),
                                                                      color: Colors.red,
                                                                      onPressed:
                                                                          () {
                                                                            Alert(
                                                                              context: context,
                                                                              type: AlertType.none,
                                                                              title: "",
                                                                              desc: "هل أنت متأكد من رغبتك في إزالة هذا الإعلان من المفضلة",
                                                                              buttons: [
                                                                                DialogButton(
                                                                                  child: Text(
                                                                                    delete_icon_text,
                                                                                    style: TextStyle(color: Colors.white, fontSize: 20),
                                                                                  ),
                                                                                  onPressed: () => {
                                                                            setState(() {

                                                                            _deleteFavorite(favorite.id);
                                                                            }),


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
        //currentIndex: 0,
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
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    if(index == 0){
      Navigator.of(context).push(
        new MaterialPageRoute(
            builder: (BuildContext context) => new Home()),
      );
    }else if(index == 1){
      Navigator.of(context).push(
        new MaterialPageRoute(
            builder: (BuildContext context) => new Posts_Home()),
      );
    }else if(index == 2){
      Navigator.of(context).push(
        new MaterialPageRoute(
            builder: (BuildContext context) => new Add_Post()),
      );
    }else if(index == 3){
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => new MyAccount()));
    }else if(index == 4){
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => new ContactUs()));
    }
    /*setState(() {
      _currentIndex = index;
      print(index.toString());
    });*/
  }
}
