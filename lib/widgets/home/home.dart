import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:iraqibayt/widgets/home/exchange_card.dart';
import 'package:iraqibayt/widgets/home/search_card.dart';
import 'package:iraqibayt/widgets/home/weather_card.dart';
import 'package:iraqibayt/widgets/home/departs_card.dart';

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
        title: Text(
          'الرئيسية',
          style: TextStyle(
            color: Colors.white,
            fontFamily: "CustomIcons",
          ),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Color(0xff275879),
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
