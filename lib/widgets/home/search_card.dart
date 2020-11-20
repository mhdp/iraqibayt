import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:iraqibayt/modules/City.dart';
import 'package:iraqibayt/modules/RCity.dart';
import 'package:iraqibayt/modules/Category.dart';
import 'package:iraqibayt/modules/SubCategory.dart';
import 'package:iraqibayt/modules/Region.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:iraqibayt/widgets/advanced_search.dart';

class SearchCard extends StatefulWidget {
  @override
  _SearchCardState createState() => _SearchCardState();
}

class _SearchCardState extends State<SearchCard> {
  List<RCity> _cities, _rCities;
  List<Region> _regions;
  List<Category> _categories, _rCategories;
  List<SubCategory> _subCategories;

  int catValue;
  String catHint;
  int cityValue;
  String cityHint;

  List<int> _subsIds, _regionsIds;

  Future<Map<String, List<Object>>> _getSearchData() async {
    //Fetching Cities Data
    var citiesResponse = await http.get('https://iraqibayt.com/getCities');
    var citiesData = json.decode(citiesResponse.body);
    Map<String, List<Object>> searchDataMap = new Map<String, List<Object>>();
    _cities = [];
    RCity tCity;

    for (var record in citiesData) {
      tCity = RCity.fromJson(record);
      //print(tCity.name + '->');
      //print(tCity.regions);
      _cities.add(tCity);
    }

    //Fetching Categories Data
    var categoriesResponse =
        await http.get('https://iraqibayt.com/getCategories');
    var categoriesData = json.decode(categoriesResponse.body);
    _categories = [];
    Category tCategory;

    for (var record in categoriesData) {
      tCategory = Category.fromJson(record);
      //print(tCategory.name);
      _categories.add(tCategory);
    }

    searchDataMap.putIfAbsent('cat_list', () => _categories);
    searchDataMap.putIfAbsent('cit_list', () => _cities);

    return searchDataMap;
  }

  List<SubCategory> _getSubCats(int cat_id, List<Category> catList) {
    for (Category cat in catList) if (cat.id == cat_id) return cat.subCatList;
  }

  List<Region> _getRegions(int cit_id, List<RCity> citList) {
    for (RCity cit in citList) if (cit.id == cit_id) return cit.regions;
  }

  void _showCitiesDialog(context, List<RCity> cities) {
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
                                cities[index].name,
                                style: TextStyle(fontFamily: 'CustomIcons'),
                              ),
                              onTap: () {
                                setState(() {
                                  cityValue = cities[index].id;

                                  _regions = List.from(
                                      _getRegions(cityValue, _rCities));
                                  print(cityValue);
                                });

                                Navigator.of(context, rootNavigator: true)
                                    .pop();

                                setState(() {
                                  cityHint = cities[index].name;
                                });
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

  void _showCategoriesDialog(context, List<Category> categories) {
    showDialog(
        context: context,
        builder: (BuildContext bc) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            elevation: 16,
            child: StatefulBuilder(builder: (context, setState) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.6,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5.0),
                      child: Center(
                        child: Text(
                          'اختر القسم الرئيسي',
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
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              title: Text(
                                categories[index].name,
                                style: TextStyle(fontFamily: 'CustomIcons'),
                              ),
                              onTap: () {
                                setState(() {
                                  catValue = categories[index].id;

                                  _subCategories = List.from(
                                      _getSubCats(catValue, _rCategories));
                                  print(catValue);
                                });

                                Navigator.of(context, rootNavigator: true)
                                    .pop();

                                setState(() {
                                  catHint = categories[index].name;
                                });
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

  void _showSubcatsDialog(context, List<SubCategory> subs) {
    showDialog(
        context: context,
        builder: (BuildContext bc) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            elevation: 16,
            child: StatefulBuilder(builder: (context, setState) {
              return Container(
                height: subs.length <= 4
                    ? MediaQuery.of(context).size.height * 0.1 * subs.length
                    : MediaQuery.of(context).size.height * 0.6,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5.0),
                      child: Center(
                        child: Text(
                          'اختر الأقسام الفرعية',
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
                        itemCount: subs.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CheckboxListTile(
                              title: Text(
                                subs[index].name,
                                style: TextStyle(fontFamily: 'CustomIcons'),
                              ),
                              value: subs[index].checked == 1 ? true : false,
                              onChanged: (bool value) {
                                //print(value);

                                if (value)
                                  setState(() {
                                    subs[index].checked = 1;
                                    _subCategories[index].checked = 1;
                                  });
                                else
                                  setState(() {
                                    subs[index].checked = 0;
                                    _subCategories[index].checked = 0;
                                  });
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

  void _showRegionsDialog(context, List<Region> regions) {
    showDialog(
        context: context,
        builder: (BuildContext bc) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            elevation: 16,
            child: StatefulBuilder(builder: (context, setState) {
              return Container(
                height: regions.length <= 4
                    ? MediaQuery.of(context).size.height * 0.1 * regions.length
                    : MediaQuery.of(context).size.height * 0.6,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5.0),
                      child: Center(
                        child: Text(
                          'اختر المناطق',
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
                        itemCount: regions.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CheckboxListTile(
                              title: Text(
                                regions[index].name,
                                style: TextStyle(fontFamily: 'CustomIcons'),
                              ),
                              value: regions[index].checked == 1 ? true : false,
                              onChanged: (bool value) {
                                //print(value);

                                if (value)
                                  setState(() {
                                    regions[index].checked = 1;
                                    _regions[index].checked = 1;
                                  });
                                else
                                  setState(() {
                                    regions[index].checked = 0;
                                    _regions[index].checked = 0;
                                  });
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

  Future _getBaghdadId() async {
    var response =
        await http.get('https://iraqibayt.com/api/cities/Baghdad/get_id');
    var data = json.decode(response.body);

    City baghdad;
    for (var record in data) baghdad = City.fromJson(record);

    return baghdad.id;
  }

  @override
  void initState() {
    super.initState();
    catHint = 'جميع الأقسام الرئيسية';
    cityHint = 'جميع المدن';

    catValue = 1;
    _getBaghdadId().then((value) {
      setState(() {
        cityValue = value;
      });
    });

    _subsIds = new List<int>();
    _regionsIds = new List<int>();
  }

  @override
  void dispose() {
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
                borderRadius: BorderRadius.circular(0),
                onTap: () {},
                child: Card(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.grey, width: 0.5),
                    borderRadius: BorderRadius.circular(0),
                  ),
                  clipBehavior: Clip.antiAlias,
                  margin: const EdgeInsets.only(top:10.0,bottom: 10),
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
                            'محرك بحث العقارات',
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
                                  future: _getSearchData(),
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
                                        Map<String, List<Object>> receivedMap =
                                            Map.from(snapshot.data);
                                        var keysList =
                                            receivedMap.keys.toList();
                                        _rCategories = receivedMap[keysList[0]];
                                        _rCities = receivedMap[keysList[1]];

                                        //catValue = _rCategories[0].id;
                                        _subCategories =
                                            _getSubCats(catValue, _rCategories);
                                        //subCatValue = _subCategories[0].id;
                                        //cityValue = _rCities[0].id;
                                        _regions =
                                            _getRegions(cityValue, _rCities);

                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              child: Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    flex: 50,
                                                    child: FlatButton(
                                                      onPressed: () {
                                                        _showCategoriesDialog(
                                                            context,
                                                            _rCategories);
                                                      },
                                                      child: Text(
                                                        catHint,
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black54,
                                                          fontFamily:
                                                              "CustomIcons",
                                                        ),
                                                      ),
                                                    ),
//                                                    child: FittedBox(
//                                                      child: new DropdownButton<
//                                                          int>(
//                                                        elevation: 5,
//                                                        hint: Container(
//                                                          alignment: Alignment
//                                                              .centerRight,
//                                                          child: Text(
//                                                            catHint,
//                                                            style: TextStyle(
//                                                              fontSize: 18,
//                                                              fontFamily:
//                                                                  "CustomIcons",
//                                                            ),
//                                                          ),
//                                                        ),
//                                                        value: catValue,
//                                                        items: _rCategories.map(
//                                                            (Category
//                                                                category) {
//                                                          return new DropdownMenuItem<
//                                                              int>(
//                                                            value: category.id,
//                                                            child: Container(
//                                                              alignment: Alignment
//                                                                  .centerRight,
//                                                              child: new Text(
//                                                                category.name,
//                                                                textAlign:
//                                                                    TextAlign
//                                                                        .right,
//                                                                style:
//                                                                    TextStyle(
//                                                                  fontFamily:
//                                                                      "CustomIcons",
//                                                                ),
//                                                              ),
//                                                            ),
//                                                          );
//                                                        }).toList(),
//                                                        onChanged: (int catId) {
//                                                          setState(() {
//                                                            catValue = catId;
//                                                            //catHint = _getCatHint(catValue, _rCategories);
//
//                                                            _subCategories = List
//                                                                .from(_getSubCats(
//                                                                    catId,
//                                                                    _rCategories));
////                                                          subCatValue =
////                                                              _subCategories[0]
////                                                                  .id;
//                                                            //_subCategories = List.from(_rCategories[catId].subCatList);
//                                                            print(catValue
//                                                                    .toString() +
//                                                                ' ' +
//                                                                catHint);
//                                                          });
//                                                        },
//                                                      ),
//                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 50,
                                                    child: FlatButton(
                                                      onPressed: () {
                                                        _showSubcatsDialog(
                                                            context,
                                                            _subCategories);
                                                      },
                                                      child: Text(
                                                        'اختر الأقسام الفرعية',
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black54,
                                                          fontFamily:
                                                              "CustomIcons",
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              child: Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    flex: 5,
//                                                    child: DropdownButton<int>(
//                                                      elevation: 5,
//                                                      hint: Container(
//                                                        alignment: Alignment
//                                                            .centerRight,
//                                                        child: Text(
//                                                          cityHint,
//                                                          style: TextStyle(
//                                                            fontSize: 18,
//                                                            fontFamily:
//                                                                'CustomIcons',
//                                                          ),
//                                                        ),
//                                                      ),
//                                                      value: cityValue,
//                                                      items: _rCities
//                                                          .map((RCity city) {
//                                                        return new DropdownMenuItem<
//                                                            int>(
//                                                          value: city.id,
//                                                          child: Container(
//                                                            alignment: Alignment
//                                                                .centerRight,
//                                                            child: new Text(
//                                                              city.name,
//                                                              textAlign:
//                                                                  TextAlign
//                                                                      .right,
//                                                              style: TextStyle(
//                                                                fontFamily:
//                                                                    "CustomIcons",
//                                                              ),
//                                                            ),
//                                                          ),
//                                                        );
//                                                      }).toList(),
//                                                      onChanged: (int cityId) {
//                                                        setState(() {
//                                                          cityValue = cityId;
//
//                                                          _regions = List.from(
//                                                              _getRegions(
//                                                                  cityValue,
//                                                                  _rCities));
//                                                          //regionValue = _regions[0].id;
//                                                          print(cityValue);
//                                                        });
//                                                      },
//                                                    ),
                                                    child: FlatButton(
                                                      color: Colors.white,
                                                      textColor: Colors.black,
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      splashColor:
                                                          Colors.orange,
                                                      onPressed: () {
                                                        _showCitiesDialog(
                                                            context, _rCities);
                                                      },
                                                      child: Text(
                                                        cityHint,
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          color: Colors.grey,
                                                          fontFamily:
                                                              "CustomIcons",
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                      flex: 5,
                                                      child: FlatButton(
                                                        onPressed: () {
                                                          _showRegionsDialog(
                                                              context,
                                                              _regions);
                                                        },
                                                        child: Text(
                                                          'اختر المناطق',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            color:
                                                                Colors.black54,
                                                            fontFamily:
                                                                "CustomIcons",
                                                          ),
                                                        ),
                                                      )),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20.0),
                                              margin: const EdgeInsets.only(
                                                  top: 5.0),
                                              child: GFButton(
                                                onPressed: () {
                                                  //print('cat:' +catValue.toString());
                                                  _subCategories
                                                      .forEach((element) {
                                                    if (element.checked == 1)
                                                      _subsIds.add(element.id);
                                                    //print('scat:' +element.toString());
                                                  });
                                                  //print('cit:' + cityValue.toString());
                                                  _regions.forEach((element) {
                                                    if (element.checked == 1)
                                                      _regionsIds
                                                          .add(element.id);
                                                    //print('reg:' +element.toString());
                                                  });

                                                  Navigator.of(context).push(
                                                    new MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          new AdvancedSearch(
                                                        categoryId: catValue,
                                                        subCategories: _subsIds,
                                                        cityId: cityValue,
                                                        regions: _regionsIds,
                                                        sortBy: 1,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                text: "بحث",
                                                blockButton: true,
                                                color: Color(0xff65AECA),
                                              ),
                                            )
                                          ],
                                        );
                                      } catch (e) {
                                        print(e.toString());
                                        return Container(
                                          child: Center(
                                            child: Text(
                                              'لا يوجد معلومات عن محرك البحث حالياً',
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
