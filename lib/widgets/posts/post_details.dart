import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:getwidget/components/carousel/gf_carousel.dart';
import 'package:getwidget/getwidget.dart';
import 'package:iraqibayt/modules/db_helper.dart';

import '../my_icons_icons.dart';

DatabaseHelper databaseHelper = new DatabaseHelper();

class Posts_detalis extends StatefulWidget {
  String post_id;

  Posts_detalis({Key key, this.post_id}) : super(key: key);
  @override
  _Posts_detalis createState() => _Posts_detalis();
}

class _Posts_detalis extends State<Posts_detalis> {
  int _selectedIndex = 0;

  List<String> imageList = new List<String>();

  var is_loading = true;

  void initState() {
    super.initState();
    imageList.clear();
    print("widget.post_id: ${widget.post_id}");
    databaseHelper.get_post_by_id(widget.post_id).whenComplete(() {
      //print(databaseHelper.get_post_by_id_list.length.toString());
      setState(() {
        print(
            "img: ${databaseHelper.get_post_by_id_list[0]["img"].toString()}");

        if (databaseHelper.get_post_by_id_list[0]["img"].toString() == "") {
          databaseHelper.get_default_post_image().whenComplete(() {
            setState(() {
              String default_image = databaseHelper.default_post_image;
              imageList.add(default_image);
            });
          });
        } else {
          imageList
              .add(databaseHelper.get_post_by_id_list[0]["img"].toString());
        }

        is_loading = false;

        //print(databaseHelper.get_post_by_id_list[0]["imgs"].toString());
        //List<String> imgs = databaseHelper.get_post_by_id_list["data"][0]["imgs"].toString().replaceAll("[", "").replaceAll("]", "").replaceAll(" ", "").split(",");

        //imgs.forEach((element) => imageList.add(element));

        //print(imageList.length);
        //imageList = Set.from(imgs);
        //print(imgs);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var show_icons = true;
    var bath;
    var bed;
    var car_num;
    if (is_loading == false) {
      bath = databaseHelper.get_post_by_id_list[0]["bathroom"];
      if (bath == null) {
        show_icons = false;
        bath = "0";
      }

      bed = databaseHelper.get_post_by_id_list[0]["bedroom"];
      if (bed == null) {
        show_icons = false;
        bed = "0";
      }

      car_num = databaseHelper.get_post_by_id_list[0]["num_car"];
      if (car_num == null) {
        car_num = "0";
      }
    }

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
                    activeIndicator: Color(0xFFdd685f),
                    items: imageList.map(
                      (url) {
                        return Container(
                          margin: EdgeInsets.all(0.0),
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            child: Image.network(
                                "https://iraqibayt.com/storage/app/public/posts/$url",
                                fit: BoxFit.cover,
                                width: 1000.0),
                          ),
                        );
                      },
                    ).toList(),
                    onPageChanged: (index) {
                      setState(() {
                        index;
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
                        color: Colors.indigo,
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
                            Icon(Icons.location_city, color: Color(0xFFdd685f)),
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
                            Icon(Icons.location_on, color: Color(0xFFdd685f)),
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
                                color: Color(0xFFdd685f)),
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
                              color: Color(0xFFdd685f),
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
                            Icon(MyIcons.money_bill, color: Color(0xFFdd685f)),
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
                              color: Color(0xFFdd685f),
                            ),
                            Text(
                              " أضافه ${databaseHelper.get_post_by_id_list[0]["name"].toString()} ${databaseHelper.get_post_by_id_list[0]["created_at"].toString()}",
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
                              color: Color(0xFFdd685f),
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
                                    color: Color(0xFFdd685f),
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
                                  Icon(MyIcons.bath, color: Color(0xFFdd685f)),
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
                                      color: Color(0xFFdd685f)),
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
                              color: Color(0xFFdd685f),
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
                              color: Color(0xFFdd685f),
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
                      IconButton(
                        padding: new EdgeInsets.all(0.0),
                        color: Colors.black,
                        icon: new Icon(MyIcons.phone, size: 38.0),
                        onPressed: () {},
                      ),
                      IconButton(
                        padding: new EdgeInsets.all(0.0),
                        color: Colors.green,
                        icon: new Icon(MyIcons.whatsapp, size: 38.0),
                        onPressed: () {},
                      ),
                      IconButton(
                        padding: new EdgeInsets.all(0.0),
                        color: Colors.blue,
                        icon: new Icon(MyIcons.telegram, size: 38.0),
                        onPressed: () {},
                      ),
                      IconButton(
                        padding: new EdgeInsets.all(0.0),
                        color: Colors.indigo,
                        icon: new Icon(MyIcons.viber, size: 38.0),
                        onPressed: () {},
                      ),
                    ],
                  ),

                  Container(
                      color: Colors.white,
                      margin: const EdgeInsets.only(top: 10.0),
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RaisedButton(
                            onPressed: () {},
                            color: Colors.red,
                            elevation: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.favorite_border,
                                  color: Colors.white,
                                ),
                                Text(
                                  " أضف إلى المفضلة",
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
