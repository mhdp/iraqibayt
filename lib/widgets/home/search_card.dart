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

  int selectedRCounter, selectedSCounter;
  bool _isAllRSelected, _isAllSSelected, _subsFirstTime, _regionsFirstTime;

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

                                  _regionsFirstTime = true;
                                  _isAllRSelected = true;
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
                                  _isAllSSelected = true;
                                  _subsFirstTime = true;
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
    if (_subsFirstTime) {
      setState(() {
        _subsFirstTime = false;
        selectedSCounter = _subCategories.length;
      });
    }
    _updateSelectedSubCats();
    print(_isAllSSelected);
    print(
        _subCategories.length.toString() + '--' + selectedSCounter.toString());

    showDialog(
        context: context,
        builder: (BuildContext bc) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            elevation: 16,
            child: StatefulBuilder(builder: (context, setState) {
              return Container(
                height: _subCategories.length <= 4
                    ? MediaQuery.of(context).size.height *
                        0.1 *
                        _subCategories.length
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
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CheckboxListTile(
                          title: Text(
                            'تحديد الكل',
                            style: TextStyle(fontFamily: 'CustomIcons'),
                          ),
                          value: _isAllSSelected,
                          onChanged: (bool value) {
                            if (!value) {
                              for (var sub in _subCategories) {
                                setState(() {
                                  sub.checked = 0;
                                });
                              }

                              setState(() {
                                _isAllSSelected = value;
                                selectedSCounter = 0;
                              });
                            } else {
                              for (var sub in _subCategories) {
                                setState(() {
                                  sub.checked = 1;
                                });
                              }

                              setState(() {
                                _isAllSSelected = value;
                                selectedSCounter = _subCategories.length;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _subCategories.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CheckboxListTile(
                              title: Text(
                                _subCategories[index].name,
                                style: TextStyle(fontFamily: 'CustomIcons'),
                              ),
                              value: _isAllSSelected
                                  ? true
                                  : _subCategories[index].checked == 1
                                      ? true
                                      : false,
                              onChanged: (bool value) {
                                //print(value);

                                if (value) {
                                  setState(() {
                                    _subCategories[index].checked = 1;
                                    selectedSCounter++;
                                  });
                                  _updateSelectedSubCats();
                                } else {
                                  setState(() {
                                    _subCategories[index].checked = 0;
                                    selectedSCounter--;
                                  });
                                  _updateSelectedSubCats();
                                }

                                print(_subCategories.length.toString() +
                                    '--' +
                                    selectedSCounter.toString());
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
    if (_regionsFirstTime) {
      setState(() {
        _regionsFirstTime = false;
        selectedRCounter = _regions.length;
      });
    }
    _updateSelectedRegions();
    print(_isAllRSelected);
    print(_regions.length.toString() + '--' + selectedRCounter.toString());

    showDialog(
        context: context,
        builder: (BuildContext bc) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            elevation: 16,
            child: StatefulBuilder(builder: (context, setState) {
              return Container(
                height: _regions.length <= 4
                    ? MediaQuery.of(context).size.height * 0.1 * _regions.length
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
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CheckboxListTile(
                          title: Text(
                            'تحديد الكل',
                            style: TextStyle(fontFamily: 'CustomIcons'),
                          ),
                          value: _isAllRSelected,
                          onChanged: (bool value) {
                            if (!value) {
                              for (var region in _regions) {
                                setState(() {
                                  region.checked = 0;
                                });
                              }

                              setState(() {
                                _isAllRSelected = value;
                                selectedRCounter = 0;
                              });
                            } else {
                              for (var region in _regions) {
                                setState(() {
                                  region.checked = 1;
                                });
                              }

                              setState(() {
                                _isAllRSelected = value;
                                selectedRCounter = _regions.length;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _regions.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CheckboxListTile(
                              title: Text(
                                _regions[index].name,
                                style: TextStyle(fontFamily: 'CustomIcons'),
                              ),
                              value: _isAllRSelected
                                  ? true
                                  : _regions[index].checked == 1
                                      ? true
                                      : false,
                              onChanged: (bool value) {
                                //print(value);

                                if (value) {
                                  setState(() {
                                    _regions[index].checked = 1;
                                    selectedRCounter++;
                                  });
                                  _updateSelectedRegions();
                                } else {
                                  setState(() {
                                    _regions[index].checked = 0;
                                    selectedRCounter--;
                                  });
                                  _updateSelectedRegions();
                                }

                                print(_regions.length.toString() +
                                    '--' +
                                    selectedRCounter.toString());
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

  void _updateSelectedRegions() {
    if (_regions.length == selectedRCounter)
      setState(() {
        _isAllRSelected = true;
      });
    else
      setState(() {
        _isAllRSelected = false;
      });
  }

  void _updateSelectedSubCats() {
    if (_subCategories.length == selectedSCounter)
      setState(() {
        _isAllSSelected = true;
      });
    else
      setState(() {
        _isAllSSelected = false;
      });
  }

  @override
  void initState() {
    super.initState();
    catHint = 'جميع الأقسام الرئيسية';
    cityHint = 'جميع المدن';
    _isAllRSelected = true;
    _isAllSSelected = true;
    _subsFirstTime = true;
    _regionsFirstTime = true;
    selectedRCounter = 0;
    selectedSCounter = 0;

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
    print('Enter Dispose section => ');
    setState(() {
      _subsFirstTime = true;
    });
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
                  margin: const EdgeInsets.only(top: 10.0, bottom: 10),
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
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          0),
                                                              side: BorderSide(
                                                                  color: Colors
                                                                      .black)),
                                                      onPressed: () {
                                                        _showCategoriesDialog(
                                                            context,
                                                            _rCategories);
                                                        setState(() {});
                                                      },
                                                      child: FittedBox(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: <Widget>[
                                                            Text(
                                                              catHint,
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    "CustomIcons",
                                                              ),
                                                            ),
                                                            Icon(
                                                              Icons
                                                                  .arrow_drop_down,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
//
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              child: Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    flex: 50,
                                                    child: FlatButton(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          0),
                                                              side: BorderSide(
                                                                  color: Colors
                                                                      .black)),
                                                      onPressed: () {
                                                        _showSubcatsDialog(
                                                            context,
                                                            _subCategories);
                                                      },
                                                      child: FittedBox(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: <Widget>[
                                                            Text(
                                                              'اختر الأقسام الفرعية',
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    "CustomIcons",
                                                              ),
                                                            ),
                                                            Icon(
                                                              Icons
                                                                  .arrow_drop_down,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ],
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
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          0),
                                                              side: BorderSide(
                                                                  color: Colors
                                                                      .black)),
                                                      color: Colors.white,
                                                      textColor: Colors.black,
                                                      splashColor:
                                                          Colors.orange,
                                                      onPressed: () {
                                                        _showCitiesDialog(
                                                            context, _rCities);
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
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  "CustomIcons",
                                                            ),
                                                          ),
                                                          Icon(
                                                            Icons
                                                                .arrow_drop_down,
                                                            color: Colors.black,
                                                          ),
                                                        ],
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
                                                      child: FlatButton(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        0),
                                                            side: BorderSide(
                                                                color: Colors
                                                                    .black)),
                                                        onPressed: () {
                                                          _showRegionsDialog(
                                                              context,
                                                              _regions);
                                                        },
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: <Widget>[
                                                            Text(
                                                              'اختر المناطق',
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    "CustomIcons",
                                                              ),
                                                            ),
                                                            Icon(
                                                              Icons
                                                                  .arrow_drop_down,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ],
                                                        ),
                                                      )),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  top: 5.0),
                                              child: FlatButton(
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
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Text(
                                                      'بحث',
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.white,
                                                        fontFamily:
                                                            "CustomIcons",
                                                      ),
                                                    ),
                                                    Icon(
                                                      Icons.search,
                                                      color: Colors.white,
                                                    ),
                                                  ],
                                                ),
                                                //blockButton: true,
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
