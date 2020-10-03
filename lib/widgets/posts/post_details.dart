import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:getwidget/components/carousel/gf_carousel.dart';

import '../my_icons_icons.dart';


class Posts_detalis extends StatefulWidget {
  @override
  _Posts_detalis createState() => _Posts_detalis();
}

class _Posts_detalis extends State<Posts_detalis> {

  final List<String> imageList = [
    "https://cdn.pixabay.com/photo/2017/12/03/18/04/christmas-balls-2995437_960_720.jpg",
    "https://cdn.pixabay.com/photo/2017/12/13/00/23/christmas-3015776_960_720.jpg",
    "https://cdn.pixabay.com/photo/2019/12/19/10/55/christmas-market-4705877_960_720.jpg",
    "https://cdn.pixabay.com/photo/2019/12/20/00/03/road-4707345_960_720.jpg",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(

          backgroundColor: Colors.deepOrange,

          title: Text(
            "تفاصيل الإعلان",
            style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20.0
              , fontFamily: "CustomIcons", ),
          ),

        ),
        body : SingleChildScrollView(
          child: Column(children: [
          GFCarousel(
          enlargeMainPage: true,
            viewportFraction: 1.0,
          autoPlay: true,
            pagination: true,
            activeIndicator: Colors.deepOrange,
          items: imageList.map(
                (url) {
              return Container(
                margin: EdgeInsets.all(0.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  child: Image.network(
                      url,
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

            child: Text('شقة سكنية للبيع',textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                color: Colors.indigo,
                fontFamily: "CustomIcons",
              ),softWrap: true,),


          ),

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
                    Icon(Icons.location_city,color:Colors.deepOrange),
                    Text(" بغداد",style: TextStyle(
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
                    Icon(Icons.location_on,color:Colors.deepOrange),
                    Text(" الكرخ",style: TextStyle(
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
                    Icon(Icons.format_line_spacing,color:Colors.deepOrange),
                    Text("  200 متر مربع",style: TextStyle(
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
                    Icon(MyIcons.money,color: Colors.deepOrange,),
                    Text("  ٢٠٠٠٠ دينار عراقي",style: TextStyle(
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
                    Icon(MyIcons.money_bill,color:Colors.deepOrange),
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
                    Icon(Icons.date_range,color: Colors.deepOrange,),
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
                    Icon(Icons.info,color: Colors.deepOrange,),
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
                    Icon(MyIcons.bed,color: Colors.deepOrange,),
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
                    Icon(MyIcons.bath,color:Colors.deepOrange),
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
                    Icon(MyIcons.car_alt,color:Colors.deepOrange),
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
                    Icon(MyIcons.info,color: Colors.deepOrange,),

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
                    Icon(Icons.call,color: Colors.deepOrange,),

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
            RaisedButton(
              onPressed: () {},
              color: Colors.white,
              elevation: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(Icons.comment,color: Colors.deepOrange,),

                  Text(" التعليقات ",style: TextStyle(
                    fontSize: 25,
                    color: Colors.indigo,
                    fontFamily: "CustomIcons",
                    fontWeight:FontWeight.w300,

                  ),),

                ],
              ),
            ),

          ],
      ),
        ),



    );
  }
}