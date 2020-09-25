import 'package:flutter/material.dart';
import 'package:iraqibayt/widgets/home/exchange_card.dart';
import 'package:iraqibayt/widgets/home/weather_card.dart';
//import 'package:getwidget/getwidget.dart';

class Home extends StatefulWidget {
  static const routeName = '/home';
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this, initialIndex: 2);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        bottom: TabBar(
          isScrollable: true,
          controller: tabController,
          tabs: [
            Tab(
              //icon: Icon(Icons.search),
              child: Text(
                "تجربة",
              ),
            ),
            Tab(
              //icon: Icon(Icons.restaurant),
              child: Text(
                "تجربة",
              ),
            ),
            Tab(
              //icon: Icon(Icons.home),
              child: Text(
                "الرئيسية",
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: <Widget>[
          Container(
            child: Icon(Icons.directions_bike),
            color: Colors.red,
          ),
          Container(
            child: Icon(Icons.directions_bus),
            color: Colors.blue,
          ),
          Container(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  WeatherCard(),
                  ExchangeCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
