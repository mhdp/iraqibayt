

import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:iraqibayt/modules/db_helper.dart';
import 'package:iraqibayt/widgets/my_icons_icons.dart';
import 'package:iraqibayt/widgets/posts/post_details.dart';

import 'add_post.dart';

DatabaseHelper databaseHelper = new DatabaseHelper();

String default_image = "";

class Posts_Home extends StatefulWidget {
  @override
  _Posts_Home createState() => _Posts_Home();
}

class _Posts_Home extends State<Posts_Home> {

  var is_loading = true;

  void initState() {
    super.initState();

    databaseHelper.get_default_post_image().whenComplete(() {
      setState(() {
        default_image = databaseHelper.default_post_image;
      });
    });

    databaseHelper.get_posts().whenComplete(() {

      setState(() {
        is_loading = false;
      });

    });





  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

            backgroundColor: Color(0xFFe8e8e8),
            appBar: AppBar(
            backgroundColor: Color(0xFF335876),
            title: Text(
            "العقارات",
            style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 20.0
            , fontFamily: "CustomIcons",),
        ),

              actions: [
                Padding(padding: const EdgeInsets.all(10), child:
                RaisedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                    new MaterialPageRoute(
                        builder: (BuildContext context) => new Add_Post() ),);
                  },
                  color: Colors.white,
                  elevation: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(Icons.add_box,color: Color(0xFF335876),),

                      Text(" أضف إعلان ",style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFF335876),
                        fontFamily: "CustomIcons",
                        fontWeight:FontWeight.w300,

                      ),),

                    ],
                  ),
                ),
                    ),
              ],

        ),
        body :  Column(
            children: <Widget>[
              Expanded(
                child:  is_loading
                    ? new Center(child: new GFLoader(type:GFLoaderType.circle),)
                    : new BikeListItem(list1: databaseHelper.posts_list),)

            ]
        ),


        );
      }


}

class BikeListItem extends StatelessWidget {

  Map<String, dynamic> list1;

  BikeListItem({this.list1});


  @override
  Widget build(BuildContext context) {

    if(list1.length > 0){

      List<dynamic> data = list1["data"];

      return new ListView.builder(

          shrinkWrap: true,
          itemCount:data.length,
          itemBuilder: (context,i){

            var show_icons = true;

            var img = data[i]['img'].toString();
            print("img: $img");
            if(img == ""){
              img = default_image;
              print("img: $img");
            }

            var bath = data[i]['bathroom'];
            if(bath == null){
              show_icons = false;
              bath = "0";
            }

            var bed = data[i]['bedroom'];
            if(bed == null){
              show_icons = false;
              bed = "0";
            }

            var car_num = data[i]['num_car'];
            if(car_num == null){
              car_num = "0";
            }

            return new Container(

              padding: const EdgeInsets.all(10.0),
              child: new GestureDetector(
                onTap: (){

                },child: InkWell(
                borderRadius: BorderRadius.circular(4.0),
                onTap: (){


                  Navigator.of(context).push(
                    new MaterialPageRoute(
                        builder: (BuildContext context) => new Posts_detalis(post_id: data[i]['id'].toString() ,) ),

                  );
                },
                child:Card(
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

                        child: img == 'null'? Image.asset('assets/images/posts/default_post_img.jpeg',fit: BoxFit.fill,
                          height: MediaQuery.of(context).size.width/1.5,) :Image.network(
                          "https://iraqibayt.com/storage/app/public/posts/$img",
                          fit: BoxFit.cover,
                          height: MediaQuery.of(context).size.width/2.5,),


                      ),

                      ButtonBar(
                        alignment: MainAxisAlignment.center,
                        children: [
                          FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                side: BorderSide(color: Color(0xFFdd685f))
                            ),
                            color: Color(0xFFdd685f),
                            onPressed: () {
                              // Perform some action
                            },
                            child: Text("${data[i]['price']} ${data[i]['currancy']['name']}",style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontFamily: "CustomIcons",
                            ),softWrap: true,),
                          ),
                          FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                side: BorderSide(color: Color(0xFFdd685f))
                            ),
                            color: Color(0xFFdd685f),
                            onPressed: () {
                              // Perform some action
                            },
                            child: Text("${data[i]['category']['name']}",style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontFamily: "CustomIcons",
                            ),softWrap: true,),
                          ),
                        ],
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),

                        child: Text(data[i]['title'],textAlign: TextAlign.center,
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
                            Icon(Icons.location_on,color:Color(0xFFdd685f)),
                            Text("${data[i]['city']['name']} - ${data[i]['region']['name']}",style: TextStyle(
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
                            Text(" المساحة:  ${data[i]['area']} ${data[i]['unit']['name']}",style: TextStyle(
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
                            Icon(Icons.add_box,color: Color(0xFFdd685f),),
                            Text(" أضيف: ${data[i]['created_at']}",style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontFamily: "CustomIcons",
                              fontWeight:FontWeight.w300,
                            ),softWrap: true,),

                          ],
                        ),
                      ),

                      show_icons ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 3, // 20%
                            child:Column(
                              mainAxisAlignment: MainAxisAlignment.end,

                              children: [
                                Icon(MyIcons.car ,),
                                Text(car_num.toString()),
                              ],),),

                          Expanded(
                            flex: 3, // 20%
                            child:Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(MyIcons.bed,),
                                Text(bed.toString()),
                              ],),),

                          Expanded(
                            flex: 3, // 20%
                            child:Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(MyIcons.bath),
                                Text(bath.toString()),
                              ],),),
                        ],):Container(),

                      Padding(
                        padding: const EdgeInsets.all(0),

                        child:Container(color: Colors.grey,
                            margin: const EdgeInsets.only( top: 10.0,bottom: 0.0),
                            padding: const EdgeInsets.all(0.0),
                            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [

                              RaisedButton(
                                onPressed: () {},
                                color: Colors.white,
                                elevation: 0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(Icons.call,color: Color(0xFFdd685f),),
                                    Text(data[i]['phone'],style: TextStyle(
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
                ),






              ),

              )




              ,);
          });

    }else{
      return Text('لا يوجد إعلانات',style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold, fontSize: 20.0
        ,      fontFamily: "CustomIcons",),
        softWrap: true,
      );
    }

  }




}