import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:iraqibayt/modules/Depart.dart';
import 'package:getwidget/getwidget.dart';

class DepartsCard extends StatefulWidget {
  @override
  _DepartsCardState createState() => _DepartsCardState();
}

class _DepartsCardState extends State<DepartsCard> {
  List<Depart> departs = [];
  int dl;

  @override
  void initState() {
    super.initState();
    this._getDeparts().then((value) {
      setState(() {
        dl = value.length;
      });
    });
  }

  Future<List<Depart>> _getDeparts() async {
    var departsResponse = await http.get('https://iraqibayt.com/departs');
    var departsData = json.decode(departsResponse.body);
    Depart tDepart;
    departs = [];

    for (var depart in departsData) {
      if (depart['data'] == 'second depart')
        tDepart = Depart(
            id: depart['id'],
            name: depart['name'],
            image: depart['img'],
            url: depart['url']);
      else
        tDepart = Depart(
            id: depart['id'],
            name: depart['data']['name'],
            image: depart['data']['img'],
            url: depart['url']);

      departs.add(tDepart);
      print('depart length is : ' + departs.length.toString());
    }
    return departs;
  }

  void _setRoute(BuildContext context, int index) {
    switch (index) {
      case 1:
        {
          Navigator.pushReplacementNamed(context, '/posts');
        }
        break;
      case 2:
        {
          Navigator.pushReplacementNamed(context, '/notes');
        }
        break;
      case 4:
        {
          Navigator.pushReplacementNamed(context, '/currencies');
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
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
        height: (dl / 2) * (gridTileHeight),
        child: FutureBuilder(
          future: _getDeparts(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Container(
                height: 100,
                child: Center(
                  child: Text('جاري تحميل أقسام الموقع...'),
                ),
              );
            } else
              return GridView.builder(
                  itemCount: snapshot.data.length,
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 150,
                    crossAxisSpacing: 10, //row margin
                    mainAxisSpacing: 10, //column margin
                    childAspectRatio:
                        1.5 / 1.0, //width / height ration for each tile
                  ),
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      splashColor: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(5),
                      onTap: () => _setRoute(context, index + 1),
                      child: Container(
                          padding: const EdgeInsets.all(10),
                          child: Center(
                            child: Column(
                              children: [
                                Container(
                                  height: gridTileHeight / 3,
                                  width: gridTileHeight / 3,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            'https://iraqibayt.com/storage/app/public/images/' +
                                                snapshot.data[index].image),
                                        fit: BoxFit.fill),
                                  ),
                                ),
                                Text(
                                  snapshot.data[index].name,
                                  style: TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xfff2f2f2),
                            borderRadius: BorderRadius.circular(5.0),
                          )),
                    );
                  });
          },
        ),
      ),
    );
  }
}
