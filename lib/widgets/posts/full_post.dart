import 'package:flutter/material.dart';
import 'package:iraqibayt/modules/db_helper.dart';
import 'package:iraqibayt/widgets/firebase_agent.dart';
import 'package:iraqibayt/widgets/posts/post_comments.dart';
import 'package:iraqibayt/widgets/posts/post_details.dart';

DatabaseHelper databaseHelper = new DatabaseHelper();

class FullPost extends StatefulWidget {
  final String post_id;

  FullPost({Key key, this.post_id}) : super(key: key);
  @override
  _FullPost createState() => _FullPost();
}

class _FullPost extends State<FullPost> {
  int _selectedIndex = 0;
  PageController _pageController;

  List<Widget> tabPages = [];

  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);

    tabPages = [
      Posts_detalis(
        post_id: widget.post_id.toString(),
      ),
      Comments(postId: int.parse(widget.post_id)),
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF335876),
        title: Text(
          "تفاصيل الإعلان",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
            fontFamily: "CustomIcons",
          ),
        ),
        actions: [
          FirebaseAgent(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF335876),
        unselectedItemColor: Colors.white,
        selectedItemColor: Color(0xFFdd685f),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.details),
            title: Text(
              'التفاصيل',
              style: TextStyle(fontSize: 16.0, fontFamily: "CustomIcons"),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.comment),
            title: Text(
              'التعليقات',
              style: TextStyle(fontSize: 16.0, fontFamily: "CustomIcons"),
            ),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      body: PageView(
        children: tabPages,
        onPageChanged: onPageChanged,
        controller: _pageController,
      ),
    );
  }

  void onPageChanged(int page) {
    setState(() {
      this._selectedIndex = page;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      this._pageController.animateToPage(index,
          duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    });
  }
}
