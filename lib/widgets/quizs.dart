import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:getwidget/getwidget.dart';
import 'package:iraqibayt/modules/Quiz.dart';
import 'package:iraqibayt/widgets/quizMain.dart';
import 'package:responsive_grid/responsive_grid.dart';

class Quizs extends StatefulWidget {
  @override
  _QuizsState createState() => _QuizsState();
}

class _QuizsState extends State<Quizs> {
  List<Quiz> quizs = [];
  var is_loading = true;
  int ql;

  @override
  void initState() {
    super.initState();
    this._getQuizs().then((value) {
      setState(() {
        ql = value.length;
        is_loading = false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<List<Quiz>> _getQuizs() async {
    var quizsResponse =
        await http.get('https://iraqibayt.com/api/quiz/category/all');
    var quizsData = json.decode(quizsResponse.body);
    Quiz tQuiz;
    quizs = [];

    for (var quiz in quizsData) {
      tQuiz = Quiz.fromJson(quiz);

      quizs.add(tQuiz);
      //print('depart length is : ' + departs.length.toString());
    }
    return quizs;
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double screenHeight =
        MediaQuery.of(context).size.height - statusBarHeight - kToolbarHeight;
    final double gridTileHeight = screenHeight / 6.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'مسابقات',
          style: TextStyle(
            fontFamily: "CustomIcons",
          ),
        ),
        backgroundColor: Color(0xff275879),
      ),
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          is_loading
              ? Container(
                  padding: const EdgeInsets.all(40.0),
                  child: new Center(
                    child: new GFLoader(type: GFLoaderType.circle),
                  ),
                )
              : ResponsiveGridRow(
                  children: [
                    for (var i = 0; i < quizs.length; i++)
                      ResponsiveGridCol(
                        xs: 6,
                        md: 4,
                        child: Container(
                            margin: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xFFebebeb),
                            ),
                            height: 100,
                            alignment: Alignment(0, 0),
                            //color: Colors.grey,
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                    new MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            new QuizMain(
                                              id: quizs[i].id,
                                              title: quizs[i].name,
                                            )));
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: gridTileHeight / 3,
                                    width: gridTileHeight / 3,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              'https://iraqibayt.com/storage/app/public/images/' +
                                                  quizs[i].image),
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    quizs[i].name,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: "CustomIcons",
                                    ),
                                  )
                                ],
                              ),
                            )),
                      ),
                  ],
                ),
        ]),
      ),
    );
  }
}
