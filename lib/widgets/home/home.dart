import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:iraqibayt/widgets/home/exchange_card.dart';
import 'package:iraqibayt/widgets/home/search_card.dart';
import 'package:iraqibayt/widgets/home/weather_card.dart';
import 'package:iraqibayt/widgets/home/departs_card.dart';
import 'package:iraqibayt/widgets/posts/add_post.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
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
      appBar: AppBar(
        title: Text('البيت العراقي'),
        backgroundColor: Color(0xFF335876),

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
      body: Container(
        child: ListView(
          //mainAxisSize: MainAxisSize.min,
          scrollDirection: Axis.vertical,
          children: <Widget>[
            WeatherCard(),
            ExchangeCard(),
            DepartsCard(),
            SearchCard(),
          ],
        ),
      ),
    );
  }
}
