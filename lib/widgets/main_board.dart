import 'package:flutter/material.dart';
import 'package:iraqibayt/widgets/currencies.dart';
import 'package:iraqibayt/widgets/home/home.dart';

class MainBoard extends StatefulWidget {
  static const routeName = '/main_board';
  @override
  _MainBoardState createState() => _MainBoardState();
}

class _MainBoardState extends State<MainBoard>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
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
      extendBody: true,
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 50,
              pinned: true,
              floating: true,
              forceElevated: boxIsScrolled,
              bottom: TabBar(
                isScrollable: true,
                tabs: [
                  Tab(
                    //icon: Icon(Icons.home),
                    child: Text(
                      "الرئيسية",
                    ),
                  ),
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
                ],
                controller: _tabController,
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            Home(),
            Currencies(),
            Container(
              child: Icon(Icons.directions_bus),
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}
