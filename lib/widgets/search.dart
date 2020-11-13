import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:iraqibayt/widgets/home/search_card.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> with SingleTickerProviderStateMixin {
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
      //drawer: NavDrawer(),
      appBar: AppBar(
        title: Text(
          'العقارات',
          style: TextStyle(
            fontFamily: "CustomIcons",
          ),
        ),
        backgroundColor: Color(0xFF335876),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            SearchCard(),
          ],
        ),
      ),
    );
  }
}
