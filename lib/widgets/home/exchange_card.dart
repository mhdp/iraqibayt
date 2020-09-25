import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class WeatherCard extends StatefulWidget {
  @override
  _WeatherCardState createState() => _WeatherCardState();
}

class _WeatherCardState extends State<WeatherCard> {
//  final List<City> cities = [
//    City(id: '1', name: 'بغداد'),
//    City(id: '2', name: 'الأنبار'),
//    City(id: '3', name: 'أربيل'),
//  ];
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: GFCard(
            title: GFListTile(
              padding: const EdgeInsets.symmetric(horizontal: 70),
              color: Colors.blue,
              title: Text(
                'أسعار الصرف',
                style: TextStyle(fontSize: 18, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    'الدولار الأمريكي مقابل الدينار العراقي',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    '(الحارثية)',
                    style: TextStyle(fontSize: 15, color: Colors.blueGrey),
                    textAlign: TextAlign.center,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        ':المدينة ',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        ':التاريخ',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  height: 100,
                  child: Image.asset(
                    'assets/images/weather.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 30),
                            height: 60,
                            alignment: Alignment.center,
                            child: Image.asset(
                              'assets/images/min_temp.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                          Text(
                            '27 C',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 30),
                            height: 60,
                            child: Image.asset(
                              'assets/images/max_temp.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                          Text(
                            '31 C',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
