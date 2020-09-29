import 'package:flutter/material.dart';
import 'package:iraqibayt/modules/Depart.dart';
import 'package:iraqibayt/widgets/home/depart_item.dart';
import 'package:getwidget/getwidget.dart';

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
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    //final double appBarHeight = appBar.preferredSize.height;
    final double screenHeight =
        MediaQuery.of(context).size.height - statusBarHeight - kToolbarHeight;
    final double gridTileHeight = screenHeight / 6.0;

    return GFCard(
      title: GFListTile(
        padding: const EdgeInsets.symmetric(horizontal: 70),
        color: Colors.blue,
        title: Text(
          'أقسام الموقع',
          style: TextStyle(fontSize: 18, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
      content: Container(
        height: (departs.length / 2) * (gridTileHeight),
        //padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 10, //row margin
          mainAxisSpacing: 10, //column margin
          childAspectRatio: 1.5 / 1.0, //width / height ration for each tile
          children: departs.map((depart) {
            return DepartItem(
              depart.id,
              depart.name,
            );
          }).toList(),
        ),
      ),
    );
  }
}
