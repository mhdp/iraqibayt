import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:getwidget/components/carousel/gf_carousel.dart';
import 'package:getwidget/getwidget.dart';
import 'package:iraqibayt/modules/db_helper.dart';

import '../my_icons_icons.dart';

DatabaseHelper databaseHelper = new DatabaseHelper();

class Posts_detalis extends StatefulWidget {
  String post_id;

  Posts_detalis( {this.post_id});
  @override
  _Posts_detalis createState() => _Posts_detalis();
}

class _Posts_detalis extends State<Posts_detalis> {

  int _selectedIndex = 0;

  List<String> imageList = new List<String>();

  var is_loading = true;

  void initState() {
    super.initState();

    databaseHelper.get_post_by_id(widget.post_id).whenComplete(() {

      setState(() {
        is_loading = false;
        imageList.add(databaseHelper.get_post_by_id_list["data"][0]["img"].toString());
        List<String> imgs = databaseHelper.get_post_by_id_list["data"][0]["imgs"].toString().replaceAll("[", "").replaceAll("]", "").replaceAll(" ", "").split(",");

        imgs.forEach((element) => imageList.add(element));

        print(imageList.length);
         //imageList = Set.from(imgs);
         //print(imgs);
      });

    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(

          backgroundColor: Color(0xFF335876),

          title: Text(
            "تفاصيل الإعلان",
            style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20.0
              , fontFamily: "CustomIcons", ),
          ),

        ),
        body :is_loading
            ? new Center(child: new GFLoader(type:GFLoaderType.circle),)
            : SingleChildScrollView(
          child: Column(children: [
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
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  child: Image.network(
                      "https://iraqibayt.com/storage/app/public/posts/$url",
                      fit: BoxFit.cover,
                      width: 1000.0
                  ),
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

            child: Text(databaseHelper.get_post_by_id_list["data"][0]["title"].toString(),textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                color: Colors.indigo,
                fontFamily: "CustomIcons",
              ),softWrap: true,),


          ),
//divider
          Padding(
            padding: const EdgeInsets.all(10.0),

            child: Divider(
              color: Colors.black,
              thickness: 0.5,
            ),),

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
                    Icon(Icons.location_city,color:Color(0xFFdd685f)),
                    Text(databaseHelper.get_post_by_id_list["data"][0]["city"]["name"].toString(),style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontFamily: "CustomIcons",
                      fontWeight:FontWeight.w300,
                    ),softWrap: true,),

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
                    Icon(Icons.location_on,color:Color(0xFFdd685f)),
                    Text(databaseHelper.get_post_by_id_list["data"][0]["region"]["name"].toString(),style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontFamily: "CustomIcons",
                      fontWeight:FontWeight.w300,
                    ),softWrap: true,),

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
                    Icon(Icons.format_line_spacing,color:Color(0xFFdd685f)),
                    Text(" ${databaseHelper.get_post_by_id_list["data"][0]["area"].toString()} ${databaseHelper.get_post_by_id_list["data"][0]["unit"]["name"].toString()}",style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontFamily: "CustomIcons",
                      fontWeight:FontWeight.w300,
                    ),),

                  ],
                ),
              ),
            ],),
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
                    Icon(MyIcons.money,color: Color(0xFFdd685f),),
                    Text(" ${databaseHelper.get_post_by_id_list["data"][0]["price"].toString()} ${databaseHelper.get_post_by_id_list["data"][0]["currancy"]["name"].toString()}",style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontFamily: "CustomIcons",
                      fontWeight:FontWeight.w300,
                    ),softWrap: true,),

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
                    Icon(MyIcons.money_bill,color:Color(0xFFdd685f)),
                    Text("   كاش وتقسيط",style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontFamily: "CustomIcons",
                      fontWeight:FontWeight.w300,
                    ),softWrap: true,),

                  ],
                ),
              ),
            ],),

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
                    Icon(Icons.date_range,color: Color(0xFFdd685f),),
                    Text(" أضافه Mohammad منذ شهرين",style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontFamily: "CustomIcons",
                      fontWeight:FontWeight.w300,
                    ),softWrap: true,),

                  ],
                ),
              ),
            ],),

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
                    Icon(Icons.info,color: Color(0xFFdd685f),),
                    Text(" عقارات للبيع-شقق للبيع",style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontFamily: "CustomIcons",
                      fontWeight:FontWeight.w300,

                    ),),

                  ],
                ),
              ),

            ],),

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
                    Icon(MyIcons.bed,color: Color(0xFFdd685f),),
                    Text("  غرف النوم: +٣",style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontFamily: "CustomIcons",
                      fontWeight:FontWeight.w300,

                    ),),

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
                    Icon(MyIcons.bath,color:Color(0xFFdd685f)),
                    Text("  حمامات: ٢",style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontFamily: "CustomIcons",
                      fontWeight:FontWeight.w300,
                    ),),

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
                    Icon(MyIcons.car_alt,color:Color(0xFFdd685f)),
                    Text("  كراج: ٣",style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontFamily: "CustomIcons",
                      fontWeight:FontWeight.w300,
                    ),),

                  ],
                ),
              ),

            ],),


          Padding(
            padding: EdgeInsets.all(16.0),

            child: Divider(
              color: Colors.black,
              thickness: 0.5,
            ),),

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
                    Icon(MyIcons.info,color: Color(0xFFdd685f),),

                    Text("تفاصيل الإعلان",style: TextStyle(
                      fontSize: 25,
                      color: Colors.indigo,
                      fontFamily: "CustomIcons",
                      fontWeight:FontWeight.w300,

                    ),),

                  ],
                ),
              ),

            ],),

          Text('عمارة كاملة المرافق للبيع بسعر مغري ومكان مميز',style: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontFamily: "CustomIcons",
            fontWeight:FontWeight.w300,

          ),),

          Padding(
            padding: EdgeInsets.all(16.0),

            child: Divider(
              color: Colors.indigo,
              thickness: 0.5,
            ),),

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
                    Icon(Icons.call,color: Color(0xFFdd685f),),

                    Text(" طرق التواصل",style: TextStyle(
                      fontSize: 25,
                      color: Colors.indigo,
                      fontFamily: "CustomIcons",
                      fontWeight:FontWeight.w300,

                    ),),

                  ],
                ),
              ),

            ],),

          Text('يمكنك التواصل معي على الرقم 00201000783921',style: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontFamily: "CustomIcons",
            fontWeight:FontWeight.w300,

          ),),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  padding: new EdgeInsets.all(0.0),
                  color: Colors.black,
                  icon: new Icon(MyIcons.phone, size: 38.0),
                  onPressed: (){},
                ),
                IconButton(
                  padding: new EdgeInsets.all(0.0),
                  color: Colors.green,
                  icon: new Icon(MyIcons.whatsapp, size: 38.0),
                  onPressed: (){},
                ),

                IconButton(
                  padding: new EdgeInsets.all(0.0),
                  color: Colors.blue,
                  icon: new Icon(MyIcons.telegram, size: 38.0),
                  onPressed: (){},
                ),
                IconButton(
                  padding: new EdgeInsets.all(0.0),
                  color: Colors.indigo,
                  icon: new Icon(MyIcons.viber, size: 38.0),
                  onPressed: (){},
                ),
              ],
            ),

            Container(color: Colors.white,
                margin: const EdgeInsets.only( top: 10.0),
                padding: const EdgeInsets.all(10.0),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  RaisedButton(
                    onPressed: () {},
                    color: Colors.red,
                    elevation: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.favorite_border,color: Colors.white,),
                        Text(" أضف إلى المفضلة",style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontFamily: "CustomIcons",
                          fontWeight:FontWeight.w300,

                        ),)

                      ],
                    ),
                  ),
                ],)

            ),

            Padding(
              padding: const EdgeInsets.all(16.0),

              child: Divider(
                color: Colors.black,
                thickness: 0.5,
              ),),

          ],
      ),
        ),

      bottomNavigationBar:

      BottomNavigationBar(
        backgroundColor: Color(0xFF335876),
        unselectedItemColor: Colors.white,
        selectedItemColor: Color(0xFFdd685f),

        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(

            icon: Icon(Icons.details),
            title: Text('التفاصيل',style: TextStyle( fontSize: 16.0
              ,      fontFamily: "CustomIcons"),),
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.comment),
            title: Text('التعليقات',style: TextStyle( fontSize: 16.0
              ,      fontFamily: "CustomIcons"),),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            title: Text('الرسائل',style: TextStyle( fontSize: 16.0
              ,      fontFamily: "CustomIcons"),),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),


    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      print(_selectedIndex.toString());
    });
  }
}