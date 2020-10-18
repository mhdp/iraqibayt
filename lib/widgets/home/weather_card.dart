import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:iraqibayt/modules/City.dart';
import 'package:iraqibayt/modules/Weather.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';

class WeatherCard extends StatefulWidget {
  @override
  _WeatherCardState createState() => _WeatherCardState();
}

class _WeatherCardState extends State<WeatherCard> {
  List<City> _cities, _rCities;
  List<Weather> _weathers, _rWeather;
  String cityHint;
  int cityId;



  @override
  void initState() {
    super.initState();
    cityHint = 'اختر مدينة';
    cityId = 2;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<Map<String, List<Object>>> _getWeatherData() async {
    var weatherResponse = await http.get('https://iraqibayt.com/getWeather');
    var weatherData = json.decode(weatherResponse.body);
    Map<String, List<Object>> dataMap = new Map<String, List<Object>>();
    _cities = [];
    _weathers = [];
    Weather tWeather;
    City tCity;

    for (var record in weatherData) {
      tWeather = Weather.fromJson(record);
      tCity = City.fromJson(record['city']);

      _weathers.add(tWeather);
      _cities.add(tCity);
    }

    dataMap.putIfAbsent('w_list', () => _weathers);
    dataMap.putIfAbsent('c_list', () => _cities);

    return dataMap;
  }

  Weather _getWeatherDataByCity(List<Weather> wList, int cid) {
    Weather targetWeather;
    for (Weather weather in wList) {
      if (weather.city.id == cid) targetWeather = weather;
    }
    return targetWeather;
  }

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
            content: FutureBuilder(
              future: _getWeatherData(),
              builder: (BuildContext context,
                  AsyncSnapshot<Map<String, List<Object>>> snapshot) {
                if (snapshot.data == null) {
                  return Container(
                    height: 50,
                    child: Center(
                      child: new CircularProgressIndicator(),
                    ),
                  );
                } else {
                  Map<String, List<Object>> receivedMap =
                      Map.from(snapshot.data);
                  var keysList = receivedMap.keys.toList();
                  _rWeather = receivedMap[keysList[0]];
                  _rCities = receivedMap[keysList[1]];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerRight,
                        //padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: DropdownButton<int>(
                          elevation: 5,
                          hint: Container(
                            alignment: Alignment.centerRight,
                            width: 200.0,
                            child: Text(
                              cityHint,
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          value: cityId,
                          items: _rCities.map((City city) {
                            return new DropdownMenuItem<int>(
                              value: city.id,
                              child: Container(
                                alignment: Alignment.centerRight,
                                width: 200.0,
                                child: new Text(
                                  city.name,
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (int cId) {
                            setState(() {
                              cityId = cId;
                              print(cId);
                            });
                          },
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              flex: 40,
                              child: Container(
                                child: Row(
                                  children: [
                                    Text(
                                      'المدينة : ',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      _getWeatherDataByCity(_rWeather, cityId)
                                          .city
                                          .name,
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 60,
                              child: Container(
                                child: Row(
                                  children: [
                                    Text(
                                      'التاريخ : ',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      _getWeatherDataByCity(_rWeather, cityId)
                                          .day,
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        height: 100,
                        child: SvgPicture.network(
                            'https://iraqibayt.com/storage/app/public/weather/' +
                                _getWeatherDataByCity(_rWeather, cityId)
                                    .wIcon
                                    .toString()),
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
                                  _getWeatherDataByCity(_rWeather, cityId)
                                          .minTemperature +
                                      ' C',
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
                                  _getWeatherDataByCity(_rWeather, cityId)
                                          .maxTemperature +
                                      ' C',
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
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }
}
