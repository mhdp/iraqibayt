import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InfoCard extends StatefulWidget {
  @override
  _InfoCardState createState() => _InfoCardState();
}

class _InfoCardState extends State<InfoCard> {
  List info_list = List();
  String info_text;
  int counter = 0;
  var timer;

  _getdata() async {
    var statisticsResponse = await http.get('https://iraqibayt.com/Info');
    var responce = json.decode(statisticsResponse.body);
    setState(() {
      info_list = responce;
    });

    startTimer();
  }

  void startTimer() {
    if (info_list.isNotEmpty) {
      var rng = new Random();

      counter = rng.nextInt(info_list.length - 1);
    }
    // Start the periodic timer which prints something every 1 seconds
    timer = new Timer.periodic(new Duration(seconds: 10), (time) {
      if (info_list.isNotEmpty) {
        if (counter < info_list.length) {
          setState(() {
            info_text = info_list[counter]["name"];
          });
          counter++;
        } else
          counter = 0;
      }
    });
  }

  void initState() {
    super.initState();

    setState(() {
      info_text = 'معلومة';
    });

    _getdata();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey, width: 0.5),
        borderRadius: BorderRadius.circular(0),
      ),
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(top: 15.0, bottom: 15.0),
      //color: Colors.grey,
      elevation: 0,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(0),
            child: Container(
              padding: const EdgeInsets.all(3.0),
              color: Color(0xff275879),
              child: Text(
                'هل تعلم',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: "CustomIcons",
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(info_text,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontFamily: "CustomIcons",
                )),
          ),
        ],
      ),
    );
  }
}
