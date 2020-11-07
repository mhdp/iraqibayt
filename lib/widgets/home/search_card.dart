import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:iraqibayt/modules/RCity.dart';
import 'package:iraqibayt/modules/Category.dart';
import 'package:iraqibayt/modules/SubCategory.dart';
import 'package:iraqibayt/modules/Region.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchCard extends StatefulWidget {
  @override
  _SearchCardState createState() => _SearchCardState();
}

class _SearchCardState extends State<SearchCard> {
  List<RCity> _cities, _rCities;
  List<Region> _regions;
  List<Category> _categories, _rCategories;
  List<SubCategory> _subCategories;
  Region initRegion;
  RCity initCity;
  SubCategory initSubCategory;
  Category initCategory;

  int catValue;
  String catHint;
  int subCatValue;
  String subCatHint;
  int cityValue;
  String cityHint;
  int regionValue;
  String regionHint;

  Future<Map<String, List<Object>>> _getSearchData() async {
    //Fetching Cities Data
    var citiesResponse = await http.get('https://iraqibayt.com/getCities');
    var citiesData = json.decode(citiesResponse.body);
    Map<String, List<Object>> dataMap2 = new Map<String, List<Object>>();
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

    dataMap2.putIfAbsent('cat_list', () => _categories);
    dataMap2.putIfAbsent('cit_list', () => _cities);

    return dataMap2;
  }

  List<SubCategory> _getSubCats(int cat_id, List<Category> catList) {
    for (Category cat in catList) if (cat.id == cat_id) return cat.subCatList;
  }

  List<Region> _getRegions(int cit_id, List<RCity> citList) {
    for (RCity cit in citList) if (cit.id == cit_id) return cit.regions;
  }

  @override
  void initState() {
    super.initState();
//    _regions = List<Region>();
//    _subCategories = List<SubCategory>();
//    _finalCities = List<RCity>();
//    _finalCategories = List<Category>();
    catHint = '1';
    subCatHint = '2';
    cityHint = '3';
    regionHint = '4';
    catValue = 1;
    subCatValue = 1;
    cityValue = 33;
    regionValue = 124;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GFCard(
        title: GFListTile(
          padding: const EdgeInsets.symmetric(horizontal: 60),
          color: Color(0xff275879),
          title: Text(
            'محرك بحث العقارات',
            style: TextStyle(fontSize: 18, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
        content: FutureBuilder(
          future: _getSearchData(),
          builder: (BuildContext context,
              AsyncSnapshot<Map<String, List<Object>>> snapshot) {
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
                height: 50,
                child: Center(
                  child: new CircularProgressIndicator(),
                ),
              );
            } else {
              Map<String, List<Object>> receivedMap = Map.from(snapshot.data);
              var keysList = receivedMap.keys.toList();
              _rCategories = receivedMap[keysList[0]];
              _rCities = receivedMap[keysList[1]];

              //catValue = _rCategories[0].id;
              _subCategories = _getSubCats(catValue, _rCategories);
              //subCatValue = _subCategories[0].id;
              //cityValue = _rCities[0].id;
              _regions = _getRegions(cityValue, _rCities);
              //regionValue = _regions[0].id;
//              catHint = _rCategories[0].name;
//              subCatHint = _subCategories[0].name;
//              cityHint = _rCities[0].name;
//              regionHint = _regions[0].name;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 45,
                          child: new DropdownButton<int>(
                            elevation: 5,
                            hint: Container(
                              alignment: Alignment.centerRight,
                              child: Text(
                                catHint,
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            value: catValue,
                            items: _rCategories.map((Category category) {
                              return new DropdownMenuItem<int>(
                                value: category.id,
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  child: new Text(
                                    category.name,
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (int catId) {
                              setState(() {
                                catValue = catId;
                                //catHint = _getCatHint(catValue, _rCategories);

                                _subCategories =
                                    List.from(_getSubCats(catId, _rCategories));
                                subCatValue = _subCategories[0].id;

                                //_subCategories = List.from(_rCategories[catId].subCatList);
                                print(catValue.toString() + ' ' + catHint);
                              });
                            },
                          ),
                        ),
                        Expanded(
                          flex: 55,
                          child: DropdownButton<int>(
                            elevation: 5,
                            hint: Container(
                              alignment: Alignment.centerRight,
                              child: Text(
                                subCatHint,
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            value: subCatValue,
                            items: _subCategories.map((subcategory) {
                              return new DropdownMenuItem<int>(
                                value: subcategory.id,
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  child: new Text(
                                    subcategory.name,
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (int subCatId) {
                              setState(() {
                                subCatValue = subCatId;
                                //subCatHint = _subCategories[subCatId].name;
                                print(subCatValue);
                              });
                            },
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
                          child: DropdownButton<int>(
                            elevation: 5,
                            hint: Container(
                              alignment: Alignment.centerRight,
                              child: Text(
                                cityHint,
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            value: cityValue,
                            items: _rCities.map((RCity city) {
                              return new DropdownMenuItem<int>(
                                value: city.id,
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  child: new Text(
                                    city.name,
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (int cityId) {
                              setState(() {
                                cityValue = cityId;

                                _regions =
                                    List.from(_getRegions(cityValue, _rCities));
                                regionValue = _regions[0].id;
                                print(cityValue);
                              });
                            },
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: DropdownButton<int>(
                            elevation: 5,
                            hint: Container(
                              alignment: Alignment.centerRight,
                              child: Text(
                                regionHint,
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            value: regionValue,
                            items: _regions.map((Region region) {
                              return new DropdownMenuItem<int>(
                                value: region.id,
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  child: new Text(
                                    region.name,
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (int regionId) {
                              setState(() {
                                regionValue = regionId;
                                //regionHint = _regions[regionId].name;
                                print(regionValue);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    margin: const EdgeInsets.only(top: 5.0),
                    child: GFButton(
                      onPressed: () {},
                      text: "بحث",
                      blockButton: true,
                      color: Color(0xff65AECA),
                    ),
                  )
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
