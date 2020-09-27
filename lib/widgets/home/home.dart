import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:iraqibayt/widgets/home/exchange_card.dart';
import 'package:iraqibayt/widgets/home/weather_card.dart';
import 'package:iraqibayt/widgets/home/departs_card.dart';

//import 'package:getwidget/getwidget.dart';

class Home extends StatefulWidget {
  static const routeName = '/home';
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  TabController _tabController;
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 2);
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: AppBar(
//        centerTitle: true,
//        bottom: TabBar(
//          isScrollable: true,
//          controller: _tabController,
//          tabs: [
//            Tab(
//              //icon: Icon(Icons.search),
//              child: Text(
//                "تجربة",
//              ),
//            ),
//            Tab(
//              //icon: Icon(Icons.restaurant),
//              child: Text(
//                "تجربة",
//              ),
//            ),
//            Tab(
//              //icon: Icon(Icons.home),
//              child: Text(
//                "الرئيسية",
//              ),
//            ),
//          ],
//        ),
//      ),
//      body: TabBarView(
//        controller: _tabController,
//        children: <Widget>[
//          Container(
//            child: Icon(Icons.directions_bike),
//            color: Colors.red,
//          ),
//          Container(
//            child: Icon(Icons.directions_bus),
//            color: Colors.blue,
//          ),
//          Container(
//            child: SingleChildScrollView(
//              child: Column(
//                crossAxisAlignment: CrossAxisAlignment.stretch,
//                children: [
//                  WeatherCard(),
//                  ExchangeCard(),
//                ],
//              ),
//            ),
//          ),
//        ],
//      ),
      extendBody: true,
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              pinned: true,
              floating: true,
              forceElevated: boxIsScrolled,
              bottom: TabBar(
                isScrollable: true,
                controller: _tabController,
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
          ];
        },
        body: TabBarView(
          controller: _tabController,
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(child: WeatherCard()),
                  Expanded(child: ExchangeCard()),
                  Expanded(child: DepartsCard()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
