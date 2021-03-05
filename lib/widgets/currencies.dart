import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:getwidget/getwidget.dart';
import 'package:http/http.dart' as http;
import 'package:iraqibayt/modules/Exchange.dart';
import 'package:iraqibayt/modules/Currency.dart';
import 'package:iraqibayt/modules/ICurrency.dart';
import 'package:flutter_html/style.dart';
import 'package:iraqibayt/widgets/chats/chats.dart';
import 'package:iraqibayt/widgets/firebase_agent.dart';
import 'package:iraqibayt/widgets/my_account.dart';
import 'package:iraqibayt/widgets/notifications.dart';
import 'package:iraqibayt/widgets/posts/add_post.dart';
import 'package:iraqibayt/widgets/posts/posts_home.dart';
import 'package:iraqibayt/widgets/profile.dart';

import 'ContactUs.dart';
import 'home/home.dart';
import 'my_icons_icons.dart';

class Currencies extends StatefulWidget {
  @override
  _CurrenciesState createState() => _CurrenciesState();
}

class _CurrenciesState extends State<Currencies> {
  List<Currency> _currencies, _rCurs;
  List<ICurrency> _icurrencies, _rICurs;
  List<Exchange> _localExchanges = [];

  Future<Map<String, List<Object>>> _getInterExc() async {
    var iExcResponse = await http.get('https://iraqibayt.com/api/openExchange');
    var iExcData = json.decode(iExcResponse.body);
    Map<String, List<Object>> dataMap = new Map<String, List<Object>>();
    Currency tCurrency;
    ICurrency tiCurrency;
    _icurrencies = [];
    _currencies = [];
    int index = 0;

    iExcData['result'].forEach((key, value) {
      tiCurrency =
          ICurrency(id: index, shortName: key, forOneDollar: value.toDouble());
      //print(tiCurrency.forOneDollar);
      _icurrencies.add(tiCurrency);
    });

    for (var cur in iExcData['curs']) {
      tCurrency = Currency.fromJson(cur);
      //print(tCurrency.shortName);
      _currencies.add(tCurrency);
    }
    //print('icurrencies length is : ' + _icurrencies.length.toString());
    //print('currencies length is : ' + _currencies.length.toString());

    dataMap.putIfAbsent('ic_list', () => _icurrencies);
    dataMap.putIfAbsent('c_list', () => _currencies);

    return dataMap;
  }

  Future<String> _getExcHeader() async {
    String headerData;
    var response = await http.get('https://iraqibayt.com/api/excHeader');
    var data = json.decode(response.body);
    headerData = json.encode(data);

    headerData = headerData.replaceAll('\\n', '');
    headerData = headerData.replaceAll('\"', '');

    //print('ExcH output : ' + headerData);

    return headerData;
  }

  Future<List<Exchange>> _getLocalExc() async {
    var excResponse = await http.get('https://iraqibayt.com/api/localExchange');
    var excData = json.decode(excResponse.body);

    Exchange tExc;
    _localExchanges = [];

    for (var exchange in excData) {
      tExc = Exchange.fromJson(exchange);

      _localExchanges.add(tExc);
    }

    //print('localExchanges length is : ' + _localExchanges.length.toString());

    return _localExchanges;
  }

  bool _isInCurs(ICurrency icurrency, List<Currency> curList) {
    for (Currency cur in curList) {
      if (cur.shortName == icurrency.shortName) return true;
    }

    //return Currency(id: 0, name: '*', shortName: 'XXX', active: 0);
    return false;
  }

  String _getCurName(ICurrency icurrency, List<Currency> curList) {
    for (Currency cur in curList) {
      if (cur.shortName == icurrency.shortName) return cur.name;
    }

    //return Currency(id: 0, name: '*', shortName: 'XXX', active: 0);
    return '';
  }

  @override
  void initState() {
    super.initState();

    //_getCurrencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFc4c4c4),
      appBar: AppBar(
        title: Text(
          'أسعار العملات',
          style: TextStyle(
            fontFamily: "CustomIcons",
          ),
        ),
        backgroundColor: Color(0xff275879),
        actions: [
          FirebaseAgent(),
        ],
      ),
      body: Container(
        child: ListView(

          scrollDirection: Axis.vertical,
          children: <Widget>[
            Container(
              child: GFCard(
                //padding: const EdgeInsets.all(0),
                margin: const EdgeInsets.only(top: 10),
                boxFit: BoxFit.cover,
                title: GFListTile(
                  //padding: const EdgeInsets.symmetric(horizontal: 70),
                  color: Color(0xff275879),
                  title: Text(
                    'نتائج نافذة بيع العملة الأجنبية لليوم',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontFamily: "CustomIcons",
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                content: FutureBuilder(
                  future: _getExcHeader(),
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
                        children: <Widget>[
                          Expanded(
                            child: Html(
                              data: snapshot.data,
                              style: {
                                'body': Style(
                                  fontSize: FontSize(16.0),
                                  fontFamily: "CustomIcons",
                                )
                              },
                            ),
                          ),
                        ],
                      );
                  },
                ),
              ),
            ),
            Container(
              child: GFCard(
                margin: const EdgeInsets.only(top: 10),
                boxFit: BoxFit.cover,
                title: GFListTile(
                  //padding: const EdgeInsets.symmetric(horizontal: 10),
                  color: Color(0xff275879),
                  title: Text(
                    'جدول أسعار صرف العملات في العراق',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontFamily: "CustomIcons",
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                content: FutureBuilder(
                    future: _getLocalExc(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.data == null) {
                        return Container(
                          height: 100,
                          child: Center(
                            child: new CircularProgressIndicator(),
                          ),
                        );
                      } else {
                        _localExchanges = snapshot.data;
                        return DataTable(
                          columns: <DataColumn>[
                            DataColumn(
                              label: Text(
                                'كل 1',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.lightBlue,
                                  fontFamily: "CustomIcons",
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'تساوي',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.lightBlue,
                                  fontFamily: "CustomIcons",
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'الجهة',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.lightBlue,
                                  fontFamily: "CustomIcons",
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                          rows: _localExchanges
                              .map(
                                (exchange) => DataRow(
                                  cells: [
                                    DataCell(
                                      Text(
                                        exchange.from.name,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: "CustomIcons",
                                        ),
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        exchange.toVal.toString() + ' IQD',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: "CustomIcons",
                                        ),
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        exchange.direction,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: "CustomIcons",
                                        ),
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              .toList(),
                        );
                      }
                    }),
              ),
            ),
            Container(
              child: GFCard(
                margin: const EdgeInsets.only(top: 10),
                boxFit: BoxFit.cover,
                title: GFListTile(
                  //padding: const EdgeInsets.symmetric(horizontal: 10),
                  color: Color(0xff275879),
                  title: Text(
                    'جدول أسعار صرف العملات العالمية مقابل الدولار',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontFamily: "CustomIcons",
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                content: FutureBuilder(
                    future: _getInterExc(),
                    builder: (BuildContext context,
                        AsyncSnapshot<Map<String, List<Object>>> snapshot) {
                      if (snapshot.data == null) {
                        return Container(
                          height: 100,
                          child: Center(
                            child: new CircularProgressIndicator(),
                          ),
                        );
                      } else {
                        Map<String, List<Object>> receivedMap =
                            Map.from(snapshot.data);
                        var keysList = receivedMap.keys.toList();
                        _rICurs = receivedMap[keysList[0]];
                        _rCurs = receivedMap[keysList[1]];

                        var toRemove = [];
                        //Filtering _rICurs :
                        _rICurs.forEach((icur) {
                          if (!_isInCurs(icur, _rCurs)) toRemove.add(icur);
                        });
                        _rICurs.removeWhere(
                            (element) => toRemove.contains(element));
                        _rICurs.removeWhere(
                            (element) => element.shortName == 'USD');

                        //Replace shortName with fullName :
                        _rICurs.forEach((icur) {
                          icur.shortName = _getCurName(icur, _rCurs);
                        });

                        return DataTable(
                          columns: <DataColumn>[
                            DataColumn(
                              label: Text(
                                'العملة',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.lightBlue,
                                  fontFamily: "CustomIcons",
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'لكل 1 دولار',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.lightBlue,
                                  fontFamily: "CustomIcons",
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                          rows: _rICurs.map(
                            (icur) {
                              return DataRow(
                                cells: <DataCell>[
                                  DataCell(
                                    Text(
                                      icur.shortName,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: "CustomIcons",
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      icur.forOneDollar.toString(),
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: "CustomIcons",
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ).toList(),
                        );
                      }
                    }),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF335876),
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.white,
        onTap: onTabTapped, // new
        //currentIndex: 0,
        type: BottomNavigationBarType.fixed, // new
        items: [
          new BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'الرئيسية',
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'الإعلانات',
          ),
          new BottomNavigationBarItem(
              icon: Icon(Icons.post_add),
              label: 'أضف إعلان'
          ),
          new BottomNavigationBarItem(
              icon: Icon(MyIcons.user),
              label: 'حسابي'
          ),
          new BottomNavigationBarItem(
              icon: Icon(Icons.mail),
              label: 'ملاحظات'
          ),
          new BottomNavigationBarItem(
              icon: Icon(Icons.message),
              label: 'الرسائل'
          ),
          new BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'الإشعارات'
          ),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    if(index == 0){
      Navigator.of(context).push(
        new MaterialPageRoute(
            builder: (BuildContext context) => new Home()),
      );
    }else if(index == 1){
      Navigator.of(context).push(
        new MaterialPageRoute(
            builder: (BuildContext context) => new Posts_Home()),
      );
    }else if(index == 2){
      Navigator.of(context).push(
        new MaterialPageRoute(
            builder: (BuildContext context) => new Add_Post()),
      );
    }else if(index == 3){
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => new MyAccount()));
    }else if(index == 4){
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => new ContactUs()));
    }else if (index == 5) {
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => new Chats()));
    } else if (index == 6) {
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => new Notifications()));
    }
    /*setState(() {
      _currentIndex = index;
      print(index.toString());
    });*/
  }
}

//
//Container(
//child: Column(
//children: [
//Row(
//children: [
//Container(
//child: Text(
//'التاريخ :',
//textAlign: TextAlign.right,
//style: TextStyle(
//fontSize: 18,
//),
//),
//),
//],
//),
//Container(
//child: Text(
//'اجمالي البيع لأغراض تعزيز الارصدة في الخارج (حوالات،إعتمادات): 142,663,082دولار امريكي علماً أن :',
//textAlign: TextAlign.right,
//style: TextStyle(
//fontSize: 18,
//),
//),
//),
//Container(
//child: Text(
//'سعر بيع المبالغ المحولة لحسابات المصارف في الخارج (1190) دينار لكل دولار.',
//textAlign: TextAlign.right,
//style: TextStyle(
//fontSize: 18,
//),
//),
//),
//Container(
//child: Text(
//'سعر البيع النقدي (1190) دينارلكل دولار.     ',
//textAlign: TextAlign.right,
//style: TextStyle(
//fontSize: 18,
//),
//),
//),
//],
//),
//),
