import 'package:flutter/material.dart';
import 'package:iraqibayt/modules/Depart.dart';
import 'package:iraqibayt/widgets/home/depart_item.dart';

class DepartsCard extends StatelessWidget {
  final List<Depart> departs = [
    Depart(id: 1, name: 'العقارات'),
    Depart(id: 2, name: 'هل تعلم'),
    Depart(id: 3, name: 'نصائح عن العقارات'),
    Depart(id: 4, name: 'أسعار العملات'),
    Depart(id: 5, name: 'قوانين العراق'),
    Depart(id: 6, name: 'مسابقات'),
    Depart(id: 7, name: 'عن العراق'),
    Depart(id: 8, name: 'إحصائيات عالمية'),
    Depart(id: 9, name: 'البيت العراقي القديم'),
    Depart(id: 10, name: 'الوقت الآن'),
  ];
  @override
  Widget build(BuildContext context) {
    return GridView(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        crossAxisSpacing: 10, //row margin
        mainAxisSpacing: 10, //column margin
        maxCrossAxisExtent: 200, //max width for each tile
        childAspectRatio: 3.5 / 3.0, //width / height ration for each tile
      ),
      children: departs.map((depart) {
        return DepartItem(
          depart.id,
          depart.name,
        );
      }).toList(),
    );
  }
}
