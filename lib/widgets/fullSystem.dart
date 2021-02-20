import 'package:flutter/material.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:iraqibayt/widgets/firebase_agent.dart';

class FullSystem extends StatelessWidget {
  final String title;
  final String description;

  FullSystem({this.title, this.description});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          child: Text(
            title,
            style: TextStyle(
              fontFamily: "CustomIcons",
            ),
          ),
        ),
        backgroundColor: Color(0xff275879),
        actions: [
          FirebaseAgent(),
        ],
      ),
      body: InkWell(
        borderRadius: BorderRadius.circular(4.0),
        onTap: () {},
        child: Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.grey, width: 0.5),
            borderRadius: BorderRadius.circular(10),
          ),
          clipBehavior: Clip.antiAlias,
          margin: const EdgeInsets.all(10.0),
          //color: Colors.grey,
          elevation: 0,

          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
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
                                data: description != null
                                    ? description
                                    : '<p>لا يحتوي القسم على ملف نصي<p>',
                                style: {
                                  'body': Style(
                                    fontSize: FontSize(16.0),
                                    fontFamily: "CustomIcons",
                                  )
                                },
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
        ),
      ),
    );
  }
}
