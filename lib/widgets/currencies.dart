import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:iraqibayt/modules/Exchange.dart';

class Currencies extends StatelessWidget {
  final List<Exchange> localExchanges = [
    Exchange(
        id: 0,
        from: 'دولار أمريكي',
        fromVal: 1.0,
        to: 'دينار عراقي',
        toVal: 1200.0,
        direction: 'مركزي العراق'),
    Exchange(
        id: 1,
        from: 'اليورو',
        fromVal: 1.0,
        to: 'دينار عراقي',
        toVal: 1500.0,
        direction: 'مركزي العراق'),
    Exchange(
        id: 2,
        from: 'جنيه إسترليني',
        fromVal: 1.0,
        to: 'دينار عراقي',
        toVal: 1000.0,
        direction: 'مركزي العراق'),
    Exchange(
        id: 3,
        from: 'دولار استرالي',
        fromVal: 1.0,
        to: 'دينار عراقي',
        toVal: 800.0,
        direction: 'مركزي العراق'),
  ];

  final List<Exchange> internationalExchanges = [
    Exchange(
        id: 0,
        from: 'دولار أمريكي',
        fromVal: 1.0,
        to: 'دينار عراقي',
        toVal: 1200.0,
        direction: 'مركزي العراق'),
    Exchange(
        id: 1,
        from: 'دولار أمريكي',
        fromVal: 1.0,
        to: 'ليرة تركية ',
        toVal: 50.0,
        direction: 'مركزي العراق'),
    Exchange(
        id: 2,
        from: 'دولار أمريكي',
        fromVal: 1.0,
        to: 'ليرة سورية',
        toVal: 2500.0,
        direction: 'مركزي العراق'),
    Exchange(
        id: 3,
        from: 'دولار أمريكي',
        fromVal: 1.0,
        to: 'اليورو',
        toVal: 0.85,
        direction: 'مركزي العراق'),
    Exchange(
        id: 4,
        from: 'دولار أمريكي',
        fromVal: 1.0,
        to: 'دولار استرالي',
        toVal: 1.4,
        direction: 'مركزي العراق'),
    Exchange(
        id: 5,
        from: 'دولار أمريكي',
        fromVal: 1.0,
        to: 'روبل روسي',
        toVal: 80.0,
        direction: 'مركزي العراق'),
    Exchange(
        id: 6,
        from: 'دولار أمريكي',
        fromVal: 1.0,
        to: 'جنيه إسترليني',
        toVal: 0.8,
        direction: 'مركزي العراق'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          Container(
            child: GFCard(
              boxFit: BoxFit.cover,
              title: GFListTile(
                //padding: const EdgeInsets.symmetric(horizontal: 70),
                color: Colors.blue,
                title: Text(
                  'نتائج نافذة بيع العملة الأجنبية لليوم',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
              content: Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          child: Text(
                            'التاريخ :',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      child: Text(
                        'اجمالي البيع لأغراض تعزيز الارصدة في الخارج (حوالات،إعتمادات): 142,663,082دولار امريكي علماً أن :',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        'سعر بيع المبالغ المحولة لحسابات المصارف في الخارج (1190) دينار لكل دولار.',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        'سعر البيع النقدي (1190) دينارلكل دولار.     ',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            child: GFCard(
              boxFit: BoxFit.cover,
              title: GFListTile(
                //padding: const EdgeInsets.symmetric(horizontal: 10),
                color: Colors.blue,
                title: Text(
                  'جدول أسعار صرف العملات في العراق',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
              content: DataTable(
                columns: <DataColumn>[
                  DataColumn(
                    label: Text(
                      'كل 1.0',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.lightBlue,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'تساوي',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.lightBlue,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'الجهة',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.lightBlue,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
                rows: localExchanges
                    .map(
                      (exchange) => DataRow(
                        cells: [
                          DataCell(
                            Text(
                              exchange.from,
                              style: TextStyle(
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          DataCell(
                            Text(
                              exchange.toVal.toString() + ' IQD',
                              style: TextStyle(
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          DataCell(
                            Text(
                              exchange.direction,
                              style: TextStyle(
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          Container(
            child: GFCard(
              boxFit: BoxFit.cover,
              title: GFListTile(
                //padding: const EdgeInsets.symmetric(horizontal: 10),
                color: Colors.blue,
                title: Text(
                  'جدول أسعار صرف العملات العالمية مقابل الدولار',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
              content: DataTable(
                columns: <DataColumn>[
                  DataColumn(
                    label: Text(
                      'العملة',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.lightBlue,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'لكل 1.0 دولار',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.lightBlue,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
                rows: internationalExchanges
                    .map(
                      (exchange) => DataRow(
                        cells: [
                          DataCell(
                            Text(
                              exchange.to,
                              style: TextStyle(
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          DataCell(
                            Text(
                              exchange.toVal.toString(),
                              style: TextStyle(
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
