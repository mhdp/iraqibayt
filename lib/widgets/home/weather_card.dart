import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:iraqibayt/modules/City.dart';

class WeatherCard extends StatefulWidget {
  @override
  _WeatherCardState createState() => _WeatherCardState();
}

class _WeatherCardState extends State<WeatherCard> {
  final List<City> cities = [
    City(id: 1, name: 'بغداد'),
    City(id: 2, name: 'الأنبار'),
    City(id: 3, name: 'أربيل'),
  ];
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        return Container(
          child: GFCard(
            boxFit: BoxFit.cover,
            title: GFListTile(
              padding: const EdgeInsets.symmetric(horizontal: 70),
              color: Colors.blue,
              title: Text(
                'أحوال الطقس',
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
                  child: DropdownButton<int>(
                    elevation: 5,
                    hint: Container(
                      alignment: Alignment.centerRight,
                      width: 150.0,
                      child: Text(
                        'اختر مدينة',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    items: cities.map((City city) {
                      return new DropdownMenuItem<int>(
                        value: city.id,
                        child: Container(
                          alignment: Alignment.centerRight,
                          width: 150.0,
                          child: new Text(
                            city.name,
                            textAlign: TextAlign.right,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (_) {},
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Container(
                          child: Text(
                            ':المدينة ',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          child: Text(
                            ':التاريخ',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
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
                                vertical: 5.0, horizontal: 30),
                            height: 50,
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
                                vertical: 5.0, horizontal: 30),
                            height: 50,
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
