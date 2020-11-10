import 'package:flutter/material.dart';
import 'package:flutter_html/style.dart';
import 'package:iraqibayt/modules/System.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_html/flutter_html.dart';
import 'package:iraqibayt/widgets/fullTip.dart';

class Tips extends StatefulWidget {
  @override
  _TipsState createState() => _TipsState();
}

class _TipsState extends State<Tips> {
  List<System> tips;

  Future<List<System>> _getTips() async {
    var tipsResponse = await http.get('https://iraqibayt.com/api/tips');
    var tipsData = json.decode(tipsResponse.body);
    System tSystem;
    tips = [];

    for (var tip in tipsData) {
      tSystem = System.fromJson(tip);

      tips.add(tSystem);
      print('tips length is : ' + tips.length.toString());
    }
    return tips;
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double screenHeight =
        MediaQuery.of(context).size.height - statusBarHeight - kToolbarHeight;
    int brIndex;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'نصائح عن العقارات',
          style: TextStyle(
            fontFamily: "CustomIcons",
          ),
        ),
        backgroundColor: Color(0xff275879),
      ),
      body: Container(
        height: screenHeight,
        padding: const EdgeInsets.only(top: 20.0),
        child: FutureBuilder(
          future: _getTips(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Container(
                height: 100,
                child: Center(
                  child: new CircularProgressIndicator(),
                ),
              );
            } else
              return Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: screenHeight,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          brIndex =
                              snapshot.data[index].description.indexOf('br');
                          print(brIndex);
                          return InkWell(
                            borderRadius: BorderRadius.circular(4.0),
                            onTap: () {},
                            child: Card(
                              shape: RoundedRectangleBorder(
                                side:
                                    BorderSide(color: Colors.grey, width: 0.5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              clipBehavior: Clip.antiAlias,
                              margin: const EdgeInsets.all(10.0),
                              //color: Colors.grey,
                              elevation: 0,

                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(0),
                                    child: Container(
                                      padding: const EdgeInsets.all(3.0),
                                      color: Color(0xff275879),
                                      child: Text(
                                        snapshot.data[index].name,
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontFamily: "CustomIcons",
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(0),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Container(
                                            padding: const EdgeInsets.all(3.0),
                                            color: Color(0xffEBEBEB),
                                            child: Column(
                                              children: [
                                                Html(
                                                  data: snapshot.data[index]
                                                          .description
                                                          .substring(
                                                              brIndex + 5,
                                                              brIndex + 105) +
                                                      '...',
                                                  style: {
                                                    'body': Style(
                                                      fontSize: FontSize(16.0),
                                                      fontFamily: "CustomIcons",
                                                    )
                                                  },
                                                ),
                                                FlatButton(
                                                  onPressed: () {
                                                    Navigator.of(context).push(
                                                      new MaterialPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            new FullTip(
                                                          title: snapshot
                                                              .data[index].name,
                                                          description: snapshot
                                                              .data[index]
                                                              .description,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Text(
                                                    'إقرأ المزيد',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.blue,
                                                      fontFamily: "CustomIcons",
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
          },
        ),
      ),
    );
  }
}
