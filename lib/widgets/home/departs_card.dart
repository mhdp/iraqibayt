import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:iraqibayt/modules/Depart.dart';
import 'package:getwidget/getwidget.dart';
import 'package:iraqibayt/widgets/abouts.dart';
import 'package:iraqibayt/widgets/posts/posts_home.dart';
import 'package:iraqibayt/widgets/systems.dart';
import 'package:iraqibayt/widgets/tips.dart';

import '../currencies.dart';
import '../notes.dart';

class DepartsCard extends StatefulWidget {
  @override
  _DepartsCardState createState() => _DepartsCardState();
}

class _DepartsCardState extends State<DepartsCard> {
  List<Depart> departs = [];
  var is_loading = true;
  int dl;

  @override
  void initState() {
    super.initState();
    this._getDeparts().then((value) {
      setState(() {
        dl = value.length;
        is_loading = false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
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
      //print('depart length is : ' + departs.length.toString());
    }
    return departs;
  }

  void _setRoute(BuildContext context, int index) {
    switch (index) {
      case 1:
        {
          Navigator.of(context).push(
            new MaterialPageRoute(
                builder: (BuildContext context) => new Posts_Home()),
          );
        }
        break;
      case 2:
        {
          Navigator.of(context).push(
            new MaterialPageRoute(
                builder: (BuildContext context) => new Notes()),
          );
        }
        break;
      case 3:
        {
          Navigator.of(context).push(
            new MaterialPageRoute(
                builder: (BuildContext context) => new Tips()),
          );
        }
        break;
      case 4:
        {
          Navigator.of(context).push(
            new MaterialPageRoute(
                builder: (BuildContext context) => new Currencies()),
          );
        }
        break;
      case 5:
        {
          Navigator.of(context).push(
            new MaterialPageRoute(
                builder: (BuildContext context) => new Systems()),
          );
        }
        break;
      case 7:
        {
          Navigator.of(context).push(
            new MaterialPageRoute(
                builder: (BuildContext context) => new Abouts()),
          );
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
                            'أقسام الموقع',
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
                              child: is_loading
                                  ? Center(
                                      child: new GFLoader(
                                          type: GFLoaderType.circle),
                                    )
                                  : Container(
                                      height: (dl / 2) * (gridTileHeight + 9.0),
                                      child: FutureBuilder(
                                        future: _getDeparts(),
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
                                              return GridView.builder(
                                                  itemCount:
                                                      snapshot.data.length,
                                                  gridDelegate:
                                                      SliverGridDelegateWithMaxCrossAxisExtent(
                                                    maxCrossAxisExtent: 150,
                                                    crossAxisSpacing:
                                                        10, //row margin
                                                    mainAxisSpacing:
                                                        10, //column margin
                                                    childAspectRatio: 1.5 /
                                                        1.0, //width / height ration for each tile
                                                  ),
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return InkWell(
                                                      splashColor:
                                                          Theme.of(context)
                                                              .primaryColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      onTap: () => _setRoute(
                                                          context, index + 1),
                                                      child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10),
                                                          child: Center(
                                                            child: Column(
                                                              children: [
                                                                Container(
                                                                  height:
                                                                      gridTileHeight /
                                                                          3,
                                                                  width:
                                                                      gridTileHeight /
                                                                          3,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    image: DecorationImage(
                                                                        image: NetworkImage('https://iraqibayt.com/storage/app/public/images/' +
                                                                            snapshot.data[index].image),
                                                                        fit: BoxFit.fill),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 10.0,
                                                                ),
                                                                Text(
                                                                  snapshot
                                                                      .data[
                                                                          index]
                                                                      .name,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    fontFamily:
                                                                        "CustomIcons",
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Color(
                                                                0xfff2f2f2),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5.0),
                                                          )),
                                                    );
                                                  });
                                            } catch (e) {
                                              return Container(
                                                child: Center(
                                                  child: Text(
                                                      'لا يوجد معلومات عن أقسام الموقع حالياً'),
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
