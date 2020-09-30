

import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:iraqibayt/widgets/my_icons_icons.dart';

class Posts_Home extends StatefulWidget {
  @override
  _Posts_Home createState() => _Posts_Home();
}

class _Posts_Home extends State<Posts_Home> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(

            backgroundColor: Colors.white70,
            appBar: AppBar(

            backgroundColor: Colors.deepOrange,

            title: Text(
            "العقارات",
            style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 20.0
            , fontFamily: "CustomIcons",),
        ),

        ),
        body :  ListView(
          children: [
            InkWell(onTap: (){
              Navigator.pushReplacementNamed(context, '/Posts_detalis');
            }, child: Card(
              clipBehavior: Clip.antiAlias,
              margin: const EdgeInsets.all(10.0),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,

                children: [

                  Padding(
                    padding: const EdgeInsets.all(0),

                    child: Image.network(
                      'https://iraqibayt.com/storage/app/public/posts/5f7180d0137d2.jpeg',
                      fit: BoxFit.fill,
                      height: MediaQuery.of(context).size.width/1.5,),


                  ),

                  ButtonBar(
                    alignment: MainAxisAlignment.center,
                    children: [
                      FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            side: BorderSide(color: Colors.deepOrange)
                        ),
                        color: Colors.deepOrange,
                        onPressed: () {
                          // Perform some action
                        },
                        child: const Text('السعر ٢٠٠٠٠ دولار أميركي',style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontFamily: "CustomIcons",
                        ),softWrap: true,),
                      ),
                      FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            side: BorderSide(color: Colors.deepOrange)
                        ),
                        color: Colors.deepOrange,
                        onPressed: () {
                          // Perform some action
                        },
                        child: const Text('شقق سكنية للبيع',style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontFamily: "CustomIcons",
                        ),softWrap: true,),
                      ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),

                    child: Text('شقة سكنية للبيع',textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.black,
                        fontFamily: "CustomIcons",
                      ),softWrap: true,),


                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 16.0,
                      right: 16.0,),

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
                        Icon(Icons.location_on,color:Colors.deepOrange),
                        Text("بغداد - الكرخ",style: TextStyle(
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
                        Text(" المساحة:  200 متر مربع",style: TextStyle(
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
                        Icon(Icons.add_box,color: Colors.deepOrange,),
                        Text(" أضيف: منذ شهرين",style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontFamily: "CustomIcons",
                          fontWeight:FontWeight.w300,
                        ),softWrap: true,),

                      ],
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 3, // 20%
                        child:Column(
                          mainAxisAlignment: MainAxisAlignment.end,

                          children: [
                            Icon(MyIcons.car ,),
                            Text('3'),
                          ],),),

                      Expanded(
                        flex: 3, // 20%
                        child:Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(MyIcons.bed,),
                            Text('2'),
                          ],),),

                      Expanded(
                        flex: 3, // 20%
                        child:Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(MyIcons.bath),
                            Text('2'),
                          ],),),
                    ],),

                  Padding(
                    padding: const EdgeInsets.all(0),

                    child:Container(color: Colors.grey,
                        margin: const EdgeInsets.only( top: 10.0),
                        padding: const EdgeInsets.all(10.0),
                        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          RaisedButton(
                            onPressed: () {},
                            color: Colors.white,
                            elevation: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.call,color: Colors.deepOrange,),
                                Text(" 00963937830937",style: TextStyle(
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
                            color: Colors.red,
                            elevation: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.favorite_border,color: Colors.white,),


                              ],
                            ),
                          ),
                        ],)

                    ),
                  ),



                ],
              ),
            ),)

          ],
        ),
        );
      }


}