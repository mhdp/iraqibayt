import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:iraqibayt/modules/City.dart';
import 'package:iraqibayt/modules/Category.dart';
import 'package:iraqibayt/modules/subCategory.dart';
import 'package:iraqibayt/modules/Region.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchCard extends StatefulWidget {
  @override
  _SearchCardState createState() => _SearchCardState();
}

class _SearchCardState extends State<SearchCard> {
  List<City> _cities, _rCities;
  List<Region> _regions;
  List<Category> _categories, _rCategories;
  List<SubCategory> _subCategories;

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
    Map<String, List<Object>> dataMap = new Map<String, List<Object>>();
    _cities = [];
    _regions = [];
    City tCity;

    for (var record in citiesData) {
      tCity = City.fromJson(record);
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
      _categories.add(tCategory);
    }

    dataMap.putIfAbsent('cat_list', () => _categories);
    dataMap.putIfAbsent('cit_list', () => _cities);

    return dataMap;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    catHint = 'جميع الأقسام الرئيسية';
    subCatHint = 'جميع الأقسام الفرعية';
    cityHint = 'جميع المدن';
    regionHint = 'جميع المناطق';

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
              _subCategories = [];
              _regions = [];

              catValue = 0;
              subCatValue = 0;
              cityValue = 0;
              regionValue = 0;
              //cityId = _rCities[0].id;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 45,
                          child: DropdownButton<int>(
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
                                catHint = _rCategories[catId].name;
                                _subCategories =
                                    List.from(_rCategories[catId].subCatList);
                                print(catValue);
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
                            items: _subCategories.map((subategory) {
                              return new DropdownMenuItem<int>(
                                value: subategory.id,
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  child: new Text(
                                    subategory.name,
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (int subCatId) {
                              setState(() {
                                subCatValue = subCatId;
                                subCatHint = _subCategories[subCatId].name;
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
                            items: _rCities.map((City city) {
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
                                cityHint = _rCities[cityId].name;
                                _regions = List.from(_rCities[cityId].regions);
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
                                regionHint = _regions[regionId].name;
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
