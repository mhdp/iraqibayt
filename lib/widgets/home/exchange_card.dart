import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:iraqibayt/modules/Exchange.dart';

class ExchangeCard extends StatefulWidget {
  @override
  _ExchangeCardState createState() => _ExchangeCardState();
}

class _ExchangeCardState extends State<ExchangeCard> {
  Exchange _exchange;
  TextEditingController _fromController;
  TextEditingController _toController;
  double _priceFactor;

  Future<Exchange> _getExchange() async {
    var excResponse = await http.get('https://iraqibayt.com/getExchange');
    var exc = json.decode(excResponse.body);

    _exchange = Exchange.fromJson(exc);

    return _exchange;
  }

  @override
  void initState() {
    super.initState();
    _fromController = TextEditingController();
    _toController = TextEditingController();
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GFCard(
        boxFit: BoxFit.cover,
        title: GFListTile(
          padding: const EdgeInsets.symmetric(horizontal: 70),
          color: Color(0xff275879),
          title: Text(
            'أسعار الصرف',
            style: TextStyle(fontSize: 18, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
        content: FutureBuilder(
          future: _getExchange(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
//
//            if (snapshot.hasError) return Text('Error: ${snapshot.error}');
//            switch (snapshot.connectionState) {
//              case ConnectionState.none:
//                return Text('Select lot');
//              case ConnectionState.waiting:
//                return Text('Awaiting bids...');
//              case ConnectionState.active:
//                return Text('\$${snapshot.data}');
//              case ConnectionState.done:
//                return Text('\$${snapshot.data} (closed)');
//            }
            if (snapshot.data == null) {
              return Container(
                height: 100,
                child: Center(
                  child: new CircularProgressIndicator(),
                ),
              );
            } else
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerRight,
                    //padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      'الدولار الأمريكي مقابل الدينار العراقي',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Text(
                          'الجهة : ',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          snapshot.data.direction,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
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
                                  snapshot.data.city.name,
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
                                  snapshot.data.date,
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
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: Text(
                            'سعر الصرف :',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            snapshot.data.toVal.toString(),
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Text(
                            'من دولار أمريكي',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Container(
                          child: TextFormField(
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 0.0),
                              fillColor: Colors.white,
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(5.0),
                                borderSide: new BorderSide(),
                              ),
                            ),
                            controller: _fromController,
                            onChanged: (String value) {
                              if (value.isEmpty) {
                                _toController.text = "";
                              } else {
                                _priceFactor =
                                    snapshot.data.toVal / snapshot.data.fromVal;
                                _toController.text =
                                    (_priceFactor * double.parse(value))
                                        .toString();
                              }
                            },
                          ),
                        ),
                        Container(
                          child: Text(
                            'إلى دينار عراقي',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Container(
                          child: TextFormField(
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 0.0),
                              fillColor: Colors.white,
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(5.0),
                                borderSide: new BorderSide(),
                              ),
                            ),
                            controller: _toController,
                            onChanged: (String value) {
                              if (value.isEmpty) {
                                _fromController.text = "";
                              } else {
                                _priceFactor =
                                    snapshot.data.toVal / snapshot.data.fromVal;
                                _fromController.text =
                                    (double.parse(value) / _priceFactor)
                                        .toString();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              );
          },
        ),
      ),
    );
  }
}
