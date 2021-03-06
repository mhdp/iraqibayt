import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  List<Weather> _weathers, _rWeather = [];
  String cityHint;
  int cityId;
  int counter = 0;
  Timer timer_weather;

  void startTimer() {
    // Start the periodic timer which prints something every 1 seconds
    timer_weather = new Timer.periodic(new Duration(seconds: 8), (time) {
      if (_rWeather.isNotEmpty) {
        if (counter < _rWeather.length) {
          setState(() {
            cityId = _rWeather[counter].city.id;
            cityHint = _rWeather[counter].city.name;
          });
          counter++;
        } else
          counter = 0;
      }
    });
  }

//  Future _getBaghdadId() async {
//    var response =
//        await http.get('https://iraqibayt.com/api/cities/Baghdad/get_id');
//    var data = json.decode(response.body);
//
//    City baghdad;
//    for (var record in data) baghdad = City.fromJson(record);
//
//    return baghdad.id;
//  }

  @override
  void initState() {
    super.initState();
    cityHint = 'اختر مدينة';

    _getWeatherData().then((value) {
      List<Weather> initList = List.from(value);

      setState(() {
        cityId = initList[0].city.id;
      });
    });

    startTimer();

//    _getBaghdadId().then((value) {
//      setState(() {
//        cityId = value;
//      });
//    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<List<Weather>> _getWeatherData() async {
    var weatherResponse = await http.get('https://iraqibayt.com/getWeather');
    var weatherData = json.decode(weatherResponse.body);
    //Map<String, List<Weather>> dataMap = new Map<String, List<Weather>>();
    //_cities = [];
    _weathers = [];
    Weather tWeather;
    //City tCity;

    //print(weatherData);

    for (var weather in weatherData) {
      tWeather = Weather.fromJson(weather);
//      //tCity = City.fromJson(record['city']);
//      print(tWeather.day);
      _weathers.add(tWeather);
//      //_cities.add(tCity);

    }
    //print(_weathers.length);

//    dataMap.putIfAbsent('w_list', () => _weathers);
//    dataMap.putIfAbsent('c_list', () => _cities);

    return _weathers;
  }

  Weather _getWeatherDataByCity(List<Weather> wList, int cid) {
    Weather targetWeather;
    for (Weather weather in wList) {
      if (weather.city.id == cid) targetWeather = weather;
    }
    return targetWeather;
  }

  void minus(int id, String hint) {
    timer_weather.cancel();
    setState(() {
      cityId = id;
      cityHint = hint;
    });
  }

  void _showCitiesDialog(context, List<Weather> cities) {
    showDialog(
        context: context,
        builder: (BuildContext bc) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            elevation: 16,
            child: StatefulBuilder(builder: (context, setState) {
              return Container(
                height: cities.length <= 4
                    ? MediaQuery.of(context).size.height * 0.1 * cities.length
                    : MediaQuery.of(context).size.height * 0.6,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5.0),
                      child: Center(
                        child: Text(
                          'اختر المدينة',
                          style: TextStyle(
                            fontFamily: 'CustomIcons',
                            fontSize: 20.0,
                            color: Color(0xff275879),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Divider(
                        thickness: 1.0,
                        color: Colors.black54,
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: cities.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              title: Text(
                                cities[index].city.name,
                                style: TextStyle(fontFamily: 'CustomIcons'),
                              ),
                              onTap: () {
                                minus(cities[index].city.id,
                                    cities[index].city.name);
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        return Row(
          children: [
            Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(4.0),
                onTap: () {},
                child: Card(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.grey, width: 0.5),
                    borderRadius: BorderRadius.circular(0),
                  ),
                  clipBehavior: Clip.antiAlias,
                  margin: const EdgeInsets.only(
                    top: 15,
                  ),
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
                            'أحوال الطقس',
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
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: FutureBuilder(
                                  future: _getWeatherData(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot snapshot) {
//                                    if (snapshot.hasError)
//                                      print(snapshot.error);
//                                    switch (snapshot.connectionState) {
//                                      case ConnectionState.none:
//                                        return Text('Select lot');
//                                      case ConnectionState.waiting:
//                                        return Text('Awaiting bids...');
//                                      case ConnectionState.active:
//                                        return Text('\$${snapshot.data}');
//                                      case ConnectionState.done:
//                                        return Text(
//                                            '\$${snapshot.data} (closed)');
//                                    }
                                    if (snapshot.data == null) {
                                      return Container(
                                        height: 50,
                                        child: Center(
                                          child:
                                              new CircularProgressIndicator(),
                                        ),
                                      );
                                    } else {
                                      _rWeather = (snapshot.data).toList();

//                                      var keysList = receivedMap.keys.toList();
//                                      _rWeather = receivedMap[keysList[0]];
//                                      _rCities = receivedMap[keysList[1]];
                                      //when i set the cityId to first item , the dropdown cant  change output item
                                      //cityId = _rCities[0].id;

                                      try {
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Row(
                                              children: [
                                                Text(
                                                  'المدينة : ',
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontFamily: "CustomIcons",
                                                    //fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                /*Container(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  //padding: const EdgeInsets.symmetric(horizontal: 5),
                                                  child: DropdownButton<int>(
                                                    elevation: 5,
                                                    hint: Container(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      width: 100.0,
                                                      child: Text(
                                                        cityHint,
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            fontFamily:
                                                                'CustomIcons'),
                                                      ),
                                                    ),
                                                    value: cityId,
                                                    items: _rWeather
                                                        .map((Weather weather) {
                                                      return new DropdownMenuItem<
                                                          int>(
                                                        value: weather.city.id,
                                                        child: Container(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.5,
                                                          child: Center(
                                                            child: Text(
                                                              weather.city.name,
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    "CustomIcons",
                                                              ),
                                                            ),
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
                                                ),*/
                                                Container(
                                                  child: FlatButton(
                                                    color: Colors.white,
                                                    textColor: Colors.black,
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    splashColor: Colors.orange,
                                                    onPressed: () {
                                                      _showCitiesDialog(
                                                          context, _rWeather);
                                                      setState(() {});
                                                    },
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Text(
                                                          cityHint,
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            color: Colors.black,
                                                            fontFamily:
                                                                "CustomIcons",
                                                          ),
                                                        ),
                                                        Icon(
                                                          Icons.arrow_drop_down,
                                                          color: Colors.black,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Container(
                                              alignment: Alignment.center,
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      'التاريخ : ',
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontFamily:
                                                            "CustomIcons",
                                                        //fontWeight:FontWeight.bold,
                                                      ),
                                                    ),
                                                    flex: 17,
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      _getWeatherDataByCity(
                                                              _rWeather, cityId)
                                                          .day,
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    flex: 25,
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                        height: 100,
                                                        child: FittedBox(
                                                          child: SvgPicture
                                                              .network(
                                                            'https://iraqibayt.com/storage/app/public/weather/' +
                                                                _getWeatherDataByCity(
                                                                        _rWeather,
                                                                        cityId)
                                                                    .wIcon
                                                                    .toString(),
                                                            alignment: Alignment
                                                                .center,
                                                          ),
                                                        )),
                                                    flex: 50,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  'درجة الحرارة : ',
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontFamily: "CustomIcons",
                                                    //fontWeight:FontWeight.bold,
                                                  ),
                                                ),
                                                Container(
                                                  child: Column(
                                                    children: <Widget>[
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 5.0,
                                                                horizontal: 30),
                                                        height: 50,
                                                        alignment:
                                                            Alignment.center,
                                                        child: Image.asset(
                                                          'assets/images/min_temp.png',
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                      Text(
                                                        'الدنيا',
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          fontFamily:
                                                              "CustomIcons",
                                                          //fontWeight:FontWeight.bold,
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            'C ',
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                            ),
                                                          ),
                                                          Text(
                                                            _getWeatherDataByCity(
                                                                    _rWeather,
                                                                    cityId)
                                                                .minTemperature,
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  alignment: Alignment.center,
                                                  child: Column(
                                                    children: <Widget>[
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 5.0,
                                                                horizontal: 30),
                                                        height: 50,
                                                        child: Image.asset(
                                                          'assets/images/max_temp.png',
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                      Text(
                                                        ' العليا',
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          fontFamily:
                                                              "CustomIcons",
                                                          //fontWeight:FontWeight.bold,
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            'C ',
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                            ),
                                                          ),
                                                          Text(
                                                            _getWeatherDataByCity(
                                                                    _rWeather,
                                                                    cityId)
                                                                .maxTemperature,
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        );
                                      } catch (e) {
                                        return Container(
                                          child: Center(
                                            child: Text(
                                              'لا يوجد معلومات عن الطقس حالياً',
                                              style: TextStyle(
                                                fontFamily: "CustomIcons",
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                  },
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
          ],
        );
      },
    );
  }
}
