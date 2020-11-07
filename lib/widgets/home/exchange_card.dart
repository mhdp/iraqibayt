import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
                            'أسعار الصرف',
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
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: FutureBuilder(
                                  future: _getExchange(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot snapshot) {
//                if (snapshot.hasError) return Text('Error: ${snapshot.error}');
//                switch (snapshot.connectionState) {
//                  case ConnectionState.none:
//                    return Text('Select lot');
//                  case ConnectionState.waiting:
//                    return Text('Awaiting bids...');
//                  case ConnectionState.active:
//                    return Text('\$${snapshot.data}');
//                  case ConnectionState.done:
//                    return Text('\$${snapshot.data} (closed)');
//                }
                                    if (snapshot.data == null) {
                                      return Container(
                                        height: 50,
                                        child: Center(
                                          child:
                                              new CircularProgressIndicator(),
                                        ),
                                      );
                                    } else {
                                      try {
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              alignment: Alignment.centerRight,
//padding: const EdgeInsets.symmetric(horizontal: 5),
                                              child: Text(
                                                'الدولار الأمريكي مقابل الدينار العراقي',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontFamily: "CustomIcons",
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
                                                      fontSize: 20,
                                                      fontFamily: "CustomIcons",
                                                    ),
                                                  ),
                                                  Text(
                                                    snapshot.data.direction,
                                                    textAlign: TextAlign.right,
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontFamily: "CustomIcons",
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Expanded(
                                                    flex: 40,
                                                    child: Container(
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            'المدينة : ',
                                                            textAlign:
                                                                TextAlign.right,
                                                            style: TextStyle(
                                                              fontSize: 20,
                                                              fontFamily:
                                                                  "CustomIcons",
                                                            ),
                                                          ),
                                                          Text(
                                                            snapshot
                                                                .data.city.name,
                                                            textAlign:
                                                                TextAlign.right,
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              fontFamily:
                                                                  "CustomIcons",
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
                                                            textAlign:
                                                                TextAlign.right,
                                                            style: TextStyle(
                                                              fontSize: 20,
                                                              fontFamily:
                                                                  "CustomIcons",
                                                            ),
                                                          ),
                                                          Text(
                                                            snapshot.data.date,
                                                            textAlign:
                                                                TextAlign.right,
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              fontFamily:
                                                                  "CustomIcons",
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5),
                                              child: Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    flex: 2,
                                                    child: Text(
                                                      'سعر الصرف :',
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontFamily:
                                                            "CustomIcons",
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: Text(
                                                      snapshot.data.toVal
                                                          .toString(),
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.blue,
                                                        fontFamily:
                                                            "CustomIcons",
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
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        fontFamily:
                                                            "CustomIcons",
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    child: TextFormField(
                                                      decoration:
                                                          InputDecoration(
                                                        contentPadding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 0.0),
                                                        fillColor: Colors.white,
                                                        border:
                                                            new OutlineInputBorder(
                                                          borderRadius:
                                                              new BorderRadius
                                                                      .circular(
                                                                  5.0),
                                                          borderSide:
                                                              new BorderSide(),
                                                        ),
                                                      ),
                                                      controller:
                                                          _fromController,
                                                      onChanged:
                                                          (String value) {
                                                        if (value.isEmpty) {
                                                          _toController.text =
                                                              "";
                                                        } else {
                                                          _priceFactor =
                                                              snapshot.data
                                                                      .toVal /
                                                                  snapshot.data
                                                                      .fromVal;
                                                          _toController.text =
                                                              (_priceFactor *
                                                                      double.parse(
                                                                          value))
                                                                  .toString();
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                  Container(
                                                    child: Text(
                                                      'إلى دينار عراقي',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        fontFamily:
                                                            "CustomIcons",
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    child: TextFormField(
                                                      decoration:
                                                          InputDecoration(
                                                        contentPadding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 0.0),
                                                        fillColor: Colors.white,
                                                        border:
                                                            new OutlineInputBorder(
                                                          borderRadius:
                                                              new BorderRadius
                                                                      .circular(
                                                                  5.0),
                                                          borderSide:
                                                              new BorderSide(),
                                                        ),
                                                      ),
                                                      controller: _toController,
                                                      onChanged:
                                                          (String value) {
                                                        if (value.isEmpty) {
                                                          _fromController.text =
                                                              "";
                                                        } else {
                                                          _priceFactor =
                                                              snapshot.data
                                                                      .toVal /
                                                                  snapshot.data
                                                                      .fromVal;
                                                          _fromController
                                                              .text = (double
                                                                      .parse(
                                                                          value) /
                                                                  _priceFactor)
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
                                      } catch (e) {
                                        return Container(
                                          child: Center(
                                            child: Text(
                                                'لا يوجد معلومات عن أسعار الصرف حالياً'),
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
