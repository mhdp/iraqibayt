import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:getwidget/components/carousel/gf_carousel.dart';
import 'package:getwidget/getwidget.dart';
import 'package:iraqibayt/modules/Favorite.dart';
import 'package:iraqibayt/modules/api/callApi.dart';
import 'package:iraqibayt/modules/db_helper.dart';
import 'package:iraqibayt/widgets/chats/user_chat.dart';
import 'package:iraqibayt/widgets/home/contact_us.dart';
import 'package:iraqibayt/widgets/welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../my_icons_icons.dart';
import 'package:image_viewer/image_viewer.dart';
import 'package:carousel_slider/carousel_slider.dart';

DatabaseHelper databaseHelper = new DatabaseHelper();

class Posts_detalis extends StatefulWidget {
  String post_id;

  Posts_detalis({Key key, this.post_id}) : super(key: key);
  @override
  _Posts_detalis createState() => _Posts_detalis();
}

class _Posts_detalis extends State<Posts_detalis> {
  int carsoul_index;
  int _selectedIndex = 0;
  String _token;
  List<Favorite> _favorites, _rFavorites;

  Future _getUserFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'is_login';
    final value = prefs.get(key);
    //print('$value');
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
    //print(body);

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
    //print('$value');
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
      //print(body);

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
                  height: MediaQuery.of(context).size.height * 0.44,
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

  List<String> imageList = new List<String>();

  var is_loading = true;

  void initState() {
    super.initState();
    imageList.clear();
    print("widget.post_id: ${widget.post_id}");

    _getUserFavorites().then((value) {
      setState(() {
        _rFavorites = List.from(value);
      });
    });

    databaseHelper.get_post_by_id(widget.post_id).whenComplete(() {
      //print(databaseHelper.get_post_by_id_list.length.toString());
      setState(() {
        //print("img: ${databaseHelper.get_post_by_id_list[0]["img"].toString()}");

        if (databaseHelper.get_post_by_id_list[0]["img"].toString().isEmpty) {
          databaseHelper.get_default_post_image().whenComplete(() {
            setState(() {
              String default_image = databaseHelper.default_post_image;
              imageList.add(
                  "https://iraqibayt.com/storage/app/public/posts/$default_image");
            });
          });
        } else {
          imageList.add(
              'https://iraqibayt.com/storage/app/public/posts/${databaseHelper.get_post_by_id_list[0]["img"].toString()}');
        }

        is_loading = false;

        //print(databaseHelper.get_post_by_id_list[0]["imgs"].toString());
        String imgs_list1 = databaseHelper.get_post_by_id_list[0]["imgs"]
            .toString()
            .replaceAll("[", "");
        imgs_list1 = imgs_list1.replaceAll("]", "");
        imgs_list1 = imgs_list1.replaceAll(" ", "");

        List<String> imgs = imgs_list1.split(",");
        //print(imgs.length.toString());
        imgs.forEach((element) {
          //print(element.toString());
          if (!element.isEmpty) {
            print("enter $element");
            imageList
                .add('https://iraqibayt.com/storage/app/public/posts/$element');
          }
        });

        //print(imageList.length);
        //imageList = Set.from(imgs);
        //print(imgs);
      });
    });
  }

  _launchURL(String phone) async {
    String url = 'tel://$phone';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _launchWhatsApp({
    @required String phone,
    @required String message,
  }) async {
    /*String url() {
      if (Platform.isIOS) {
        return "whatsapp://wa.me/$phone/?text=${Uri.parse(message)}";
      } else {
        return "whatsapp://send?   phone=$phone&text=${Uri.parse(message)}";
      }
    }

    if (await canLaunch(url())) {
      await launch(url());
    } else {
      throw 'Could not launch ${url()}';
    }*/

    FlutterOpenWhatsapp.sendSingleMessage(phone, message);
  }

  void _launchViber({
    @required String phone,
  }) async {
    String url() {
      return 'viber://chat?number=$phone';
    }

    if (await canLaunch(url())) {
      await launch(url());
    } else {
      throw 'Could not launch ${url()}';
    }
  }

  void _launchTelegram({
    @required String phone,
  }) async {
    String url() {
      return 'https://t.me/$phone';
    }

    if (await canLaunch(url())) {
      await launch(url());
    } else {
      throw 'Could not launch ${url()}';
    }
  }

  @override
  Widget build(BuildContext context) {
    var show_icons = true;
    var bath;
    var bed;
    var car_num;

    //contact method
    var call_ = false;
    var whatsapp_ = false;
    var telegram_ = false;
    var viber_ = false;

    if (is_loading == false) {
      bath = databaseHelper.get_post_by_id_list[0]["bathroom"];
      if (bath == "null" || bath == null) {
        show_icons = false;
        bath = "0";
      }

      bed = databaseHelper.get_post_by_id_list[0]["bedroom"];
      if (bed == "null" || bed == null) {
        show_icons = false;
        bed = "0";
      }

      car_num = databaseHelper.get_post_by_id_list[0]["num_car"];
      if (car_num == null || car_num == null) {
        car_num = "0";
      }

      //check contact method
      String contact_info =
          databaseHelper.get_post_by_id_list[0]["contact"].toString();

      //check call

      if (contact_info.contains("إتصال مباشر")) {
        call_ = true;
      }

      //check whatsapp
      if (contact_info.contains("واتسآب")) {
        whatsapp_ = true;
      }

      //check telegram
      if (contact_info.contains("تلغرام")) {
        telegram_ = true;
      }

      //check viber
      if (contact_info.contains("فايبر")) {
        call_ = true;
      }
    }

    int carsoul_counter = 0;

    return Container(
      child: is_loading
          ? new Center(
              child: new GFLoader(type: GFLoaderType.circle),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  GFCarousel(
                    enlargeMainPage: true,
                    viewportFraction: 1.0,
                    autoPlay: true,
                    pagination: true,
                    activeIndicator: Color(0xff275879),
                    items: imageList.map(
                      (url) {
                        //carsoul_counter++;
                        return Container(
                          margin: EdgeInsets.all(0.0),
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            child: InkWell(
                              onTap: () {
                                ImageViewer.showImageSlider(
                                  images: imageList,
                                  startingPosition: carsoul_index,
                                  //print(carsoul_counter.toString());
                                );
                              },
                              child: Image.network(url,
                                  fit: BoxFit.cover, width: 1000.0),
                            ),
                          ),
                        );
                      },
                    ).toList(),
                    onPageChanged: (index) {
                      setState(() {
                        carsoul_index = index;
                      });
                    },
                  ),

//title
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      databaseHelper.get_post_by_id_list[0]["title"].toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        color: Color(0xFF335876),
                        fontFamily: "CustomIcons",
                      ),
                      softWrap: true,
                    ),
                  ),
//divider
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Divider(
                      color: Colors.black,
                      thickness: 0.5,
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
//city
                      RaisedButton(
                        onPressed: () {},
                        color: Colors.white,
                        elevation: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(Icons.location_city, color: Color(0xff275879)),
                            Text(
                              databaseHelper.get_post_by_id_list[0]["city"]
                                      ["name"]
                                  .toString(),
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
                      //region
                      RaisedButton(
                        onPressed: () {},
                        color: Colors.white,
                        elevation: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(Icons.location_on, color: Color(0xff275879)),
                            Text(
                              databaseHelper.get_post_by_id_list[0]["region"]
                                      ["name"]
                                  .toString(),
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
                      //area
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
                              " ${databaseHelper.get_post_by_id_list[0]["area"].toString()} ${databaseHelper.get_post_by_id_list[0]["unit"]["name"].toString()}",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontFamily: "CustomIcons",
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
//price
                      RaisedButton(
                        onPressed: () {},
                        color: Colors.white,
                        elevation: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(
                              MyIcons.money,
                              color: Color(0xff275879),
                            ),
                            Text(
                              " ${databaseHelper.get_post_by_id_list[0]["price"].toString()} ${databaseHelper.get_post_by_id_list[0]["currancy"]["name"].toString()}",
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
                      //payment method
                      RaisedButton(
                        onPressed: () {},
                        color: Colors.white,
                        elevation: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(MyIcons.money_bill, color: Color(0xff275879)),
                            Text(
                              "   ${databaseHelper.get_post_by_id_list[0]["payment"].toString()}",
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
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
//user and created_at
                      RaisedButton(
                        onPressed: () {},
                        color: Colors.white,
                        elevation: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(
                              Icons.date_range,
                              color: Color(0xff275879),
                            ),
                            Text(
                              " أضافه ${databaseHelper.get_post_by_id_list[0]["user"]["name"].toString()} ${databaseHelper.get_post_by_id_list[0]["created_at"].toString()}",
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
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
//category and sub
                      RaisedButton(
                        onPressed: () {},
                        color: Colors.white,
                        elevation: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(
                              Icons.info,
                              color: Color(0xff275879),
                            ),
                            Text(
                              " ${databaseHelper.get_post_by_id_list[0]["category"]["name"].toString()} - ${databaseHelper.get_post_by_id_list[0]["sub"]["name"].toString()}",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontFamily: "CustomIcons",
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  if (show_icons)
                    FittedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
//beedroom
                          FittedBox(
                            child: RaisedButton(
                              onPressed: () {},
                              color: Colors.white,
                              elevation: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Icon(
                                    MyIcons.bed,
                                    color: Color(0xff275879),
                                  ),
                                  Text(
                                    "  غرف النوم: ${bed.toString()}",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontFamily: "CustomIcons",
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          //bathroom
                          FittedBox(
                            child: RaisedButton(
                              onPressed: () {},
                              color: Colors.white,
                              elevation: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Icon(MyIcons.bath, color: Color(0xff275879)),
                                  Text(
                                    "  حمامات: ${bath.toString()}",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontFamily: "CustomIcons",
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
//car
                          FittedBox(
                            child: RaisedButton(
                              onPressed: () {},
                              color: Colors.white,
                              elevation: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Icon(MyIcons.car_alt,
                                      color: Color(0xff275879)),
                                  Text(
                                    "  كراج: ${car_num.toString()}",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
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
                    )
                  else
                    Container(),

//Divider
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Divider(
                      color: Colors.black,
                      thickness: 0.5,
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      RaisedButton(
                        onPressed: () {},
                        color: Colors.white,
                        elevation: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(
                              MyIcons.info,
                              color: Color(0xff275879),
                            ),
                            Text(
                              "تفاصيل الإعلان",
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.indigo,
                                fontFamily: "CustomIcons",
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      databaseHelper.get_post_by_id_list[0]["description"]
                          .toString(),
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontFamily: "CustomIcons",
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Divider(
                      color: Colors.indigo,
                      thickness: 0.5,
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      RaisedButton(
                        onPressed: () {},
                        color: Colors.white,
                        elevation: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(
                              Icons.call,
                              color: Color(0xff275879),
                            ),
                            Text(
                              " طرق التواصل",
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.indigo,
                                fontFamily: "CustomIcons",
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  Text(
                    'يمكنك التواصل معي على الرقم ${databaseHelper.get_post_by_id_list[0]["phone"].toString()}',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontFamily: "CustomIcons",
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  ButtonBar(
                    alignment: MainAxisAlignment.center,
                    children: [
                      call_
                          ? IconButton(
                              padding: new EdgeInsets.all(0.0),
                              color: Colors.black,
                              icon: new Icon(MyIcons.phone, size: 38.0),
                              onPressed: () {
                                _launchURL(databaseHelper.get_post_by_id_list[0]
                                        ["phone"]
                                    .toString());
                              },
                            )
                          : Container(),
                      whatsapp_
                          ? IconButton(
                              padding: new EdgeInsets.all(0.0),
                              color: Colors.green,
                              icon: new Icon(MyIcons.whatsapp, size: 38.0),
                              onPressed: () {
                                _launchWhatsApp(
                                    phone: databaseHelper.get_post_by_id_list[0]
                                            ["phone"]
                                        .toString(),
                                    message: 'البيت العراقي');
                              },
                            )
                          : Container(),
                      telegram_
                          ? IconButton(
                              padding: new EdgeInsets.all(0.0),
                              color: Colors.blue,
                              icon: new Icon(MyIcons.telegram, size: 38.0),
                              onPressed: () {
                                _launchTelegram(
                                    phone: databaseHelper.get_post_by_id_list[0]
                                            ["phone"]
                                        .toString());
                              },
                            )
                          : Container(),
                      viber_
                          ? IconButton(
                              padding: new EdgeInsets.all(0.0),
                              color: Colors.indigo,
                              icon: new Icon(MyIcons.viber, size: 38.0),
                              onPressed: () {
                                _launchViber(
                                    phone: databaseHelper.get_post_by_id_list[0]
                                            ["phone"]
                                        .toString());
                              },
                            )
                          : Container(),
                    ],
                  ),

                  Row(
                    children: [
                      Container(
                          color: Colors.white,
                          margin: const EdgeInsets.only(top: 10.0),
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _checkIfInFavs(
                                          databaseHelper.get_post_by_id_list[0]
                                              ["id"],
                                          _rFavorites) ==
                                      null
                                  ? RaisedButton(
                                      onPressed: () {
                                        _addFavorite(databaseHelper
                                            .get_post_by_id_list[0]["id"]);
                                      },
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Colors.red,
                                      width: 1,
                                      style:
                                      BorderStyle.solid),
                                ),
                                      color: Colors.white,
                                      elevation: 0,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(
                                            Icons.favorite_border,
                                            color: Colors.red,
                                          ),
                                          Text(
                                            " أضف إلى المفضلة",
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.black,
                                              fontFamily: "CustomIcons",
                                              fontWeight: FontWeight.w300,
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  : RaisedButton(
                                      onPressed: () {
                                        _deleteFavorite(_checkIfInFavs(
                                            databaseHelper.get_post_by_id_list[0]
                                                ["id"],
                                            _rFavorites));
                                      },
                                      color: Colors.red,
                                      elevation: 0,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(
                                            Icons.favorite,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            " ضمن المفضلة",
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                              fontFamily: "CustomIcons",
                                              fontWeight: FontWeight.w300,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                            ],
                          )),

                      Container(
                          color: Colors.white,
                          margin: const EdgeInsets.only(top: 10.0),
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RaisedButton(
                                onPressed: () {
                                  Navigator.of(context).push(new MaterialPageRoute(
                                      builder: (BuildContext context) => new UserChat(userID: databaseHelper.get_post_by_id_list[0]["user"]["id"].toString(),userName: databaseHelper.get_post_by_id_list[0]["user"]["name"].toString(),)));

                                },
                                color: Colors.blue,
                                elevation: 0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.send,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      " أرسل رسالة",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontFamily: "CustomIcons",
                                        fontWeight: FontWeight.w300,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          )),


                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Divider(
                      color: Colors.black,
                      thickness: 0.5,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
