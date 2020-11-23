import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:iraqibayt/widgets/home/exchange_card.dart';
import 'package:iraqibayt/widgets/home/search_card.dart';
import 'package:iraqibayt/widgets/home/weather_card.dart';
import 'package:iraqibayt/widgets/home/departs_card.dart';
import 'package:iraqibayt/widgets/posts/add_post.dart';
import 'package:iraqibayt/widgets/posts/latest_posts.dart';
import 'package:iraqibayt/widgets/posts/posts_home.dart';
import 'package:iraqibayt/widgets/posts/spicail_posts.dart';
import 'package:iraqibayt/widgets/posts/spicial_page.dart';
import 'package:responsive_grid/responsive_grid.dart';

import '../ContactUs.dart';
import '../NavDrawer.dart';
import '../my_icons_icons.dart';
import '../profile.dart';
import 'contact_us.dart';
import 'info_card.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {

  var _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFc4c4c4),
      drawer: NavDrawer(),
      appBar: AppBar(
        title:
        Center(child: Image.asset('assets/images/logo_white.png', fit: BoxFit.fill,height: 40,),),

        backgroundColor: Color(0xFF335876),
        actions: [
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
                    //color: Color(0xFF335876),
                    color: Colors.white,
                  ),
                  Text(
                    " أضف إعلان ",
                    style: TextStyle(
                      fontSize: 20,
                      //color: Color(0xFF335876),
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
        child: SingleChildScrollView(
      child:Column(
          //mainAxisSize: MainAxisSize.min,
          //scrollDirection: Axis.vertical,
          children: <Widget>[
            WeatherCard(),
            ExchangeCard(),
            RaisedButton(

              onPressed: () {},
              color: Color(0XFFc4c4c4),
              elevation: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  //Icon(Icons.list,color: Colors.white,),

                  Text("الأقسام",style: TextStyle(
                    fontSize: 25,
                    color: Colors.black,
                    fontFamily: "CustomIcons",
                    fontWeight:FontWeight.w300,

                  ),),

                ],
              ),
            ),
            DepartsCard(),
            SizedBox(height: 5,),
            SearchCard(),
            SizedBox(height: 5,),
            RaisedButton(
              onPressed: () {},
              color: Color(0XFFc4c4c4),
              elevation: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  //Icon(Icons.list,color: Colors.white,),

                  Text(" العروض المميزة ",style: TextStyle(
                    fontSize: 25,
                    color: Colors.black,
                    fontFamily: "CustomIcons",
                    fontWeight:FontWeight.w300,

                  ),),

                ],
              ),
            ),
            Spicial_posts(),
            Padding(
            padding: const EdgeInsets.all(10),
            child:FlatButton(
              onPressed: () {

                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => new Spical_page()));
              },
              child: Row(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'عرض كل الإعلانات المميزة',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontFamily:
                      "CustomIcons",
                    ),
                  ),

                ],
              ),
              //blockButton: true,
              color: Color(0xFFdd685f),
            )),
            SizedBox(height: 10,),
            RaisedButton(
              onPressed: () {},
              color: Color(0XFFc4c4c4),
              elevation: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  //Icon(Icons.list,color: Colors.white,),

                  Text(" العروض المضافة حديثاً ",style: TextStyle(
                    fontSize: 25,
                    color: Colors.black,
                    fontFamily: "CustomIcons",
                    fontWeight:FontWeight.w300,

                  ),),

                ],
              ),
            ),
            latest_posts(),
            SizedBox(height: 5,),
            InfoCard(),
            SizedBox(height: 5,),
            Contact_us_card(),
          ],
        ),
      ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF335876),
        unselectedItemColor: Colors.white,
        selectedItemColor: Color(0xFFdd685f),
        onTap: onTabTapped, // new
        currentIndex: 0,
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
    if(index == 1){
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
          builder: (BuildContext context) => new Profile()));
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


