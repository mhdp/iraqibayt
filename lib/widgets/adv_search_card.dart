import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:iraqibayt/modules/RCity.dart';
import 'package:iraqibayt/modules/Category.dart';
import 'package:iraqibayt/modules/SortBy.dart';
import 'package:iraqibayt/modules/SubCategory.dart';
import 'package:iraqibayt/modules/Region.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:iraqibayt/widgets/advanced_search.dart';
import 'dart:convert';

class AdvancedSearchCard extends StatefulWidget {
  final int categoryId;
  final List<int> subCategories;
  final int cityId;
  final List<int> regions;
  final int sortById;

  AdvancedSearchCard({
    this.categoryId,
    this.subCategories,
    this.cityId,
    this.regions,
    this.sortById,
  });
  @override
  _AdvancedSearchCardState createState() => _AdvancedSearchCardState();
}

class _AdvancedSearchCardState extends State<AdvancedSearchCard> {
  final List<SortBy> _sortByList = [
    SortBy(id: 1, name: '(تاريخ النشر) من الأحدث للأقدم'),
    SortBy(id: 2, name: '(تاريخ النشر) من الأقدم للأحدث'),
    SortBy(id: 3, name: '(عدد غرف النوم) من الأكثر للأقل عددا'),
    SortBy(id: 4, name: '(عدد غرف النوم) من الأقل للأكثر عددا'),
  ];
  List<RCity> _cities, _rCities;
  List<Region> _regions;
  List<Category> _categories, _rCategories;
  List<SubCategory> _subCategories;

  int catValue;
  String catHint;
  int cityValue;
  String cityHint;
  int sortByValue;
  String sortByHint;

  Future<Map<String, List<Object>>> _getSearchData() async {
    //Fetching Cities Data
    var citiesResponse = await http.get(Uri.parse('https://iraqibayt.com/getCities'));
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
        await http.get(Uri.parse('https://iraqibayt.com/getCategories'));
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
                              value:
                                  widget.subCategories.contains(subs[index].id)
                                      ? true
                                      : false,
                              onChanged: (bool value) {
                                //print(value);

                                if (value)
                                  setState(() {
                                    widget.subCategories.add(subs[index].id);
                                  });
                                else
                                  setState(() {
                                    widget.subCategories.remove(subs[index].id);
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
                              value: widget.regions.contains(regions[index].id)
                                  ? true
                                  : false,
                              onChanged: (bool value) {
                                //print(value);

                                if (value)
                                  setState(() {
                                    widget.regions.add(regions[index].id);
                                  });
                                else
                                  setState(() {
                                    widget.regions.remove(regions[index].id);
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

  @override
  void initState() {
    super.initState();

    catHint = 'جميع الأقسام الرئيسية';
    cityHint = 'جميع المدن';
    sortByHint = 'ترتيب حسب';
    sortByValue = widget.sortById;

    catValue = widget.categoryId;
    cityValue = widget.cityId;
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
                            'محرك بحث العقارات المتقدم',
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
                                                    child: FittedBox(
                                                      child: new DropdownButton<
                                                          int>(
                                                        elevation: 5,
                                                        hint: Container(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child: Text(
                                                            catHint,
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              fontFamily:
                                                                  "CustomIcons",
                                                            ),
                                                          ),
                                                        ),
                                                        value: catValue,
                                                        items: _rCategories.map(
                                                            (Category
                                                                category) {
                                                          return new DropdownMenuItem<
                                                              int>(
                                                            value: category.id,
                                                            child: Container(
                                                              alignment: Alignment
                                                                  .centerRight,
                                                              child: new Text(
                                                                category.name,
                                                                textAlign:
                                                                    TextAlign
                                                                        .right,
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      "CustomIcons",
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        }).toList(),
                                                        onChanged: (int catId) {
                                                          setState(() {
                                                            catValue = catId;

                                                            _subCategories = List
                                                                .from(_getSubCats(
                                                                    catId,
                                                                    _rCategories));
                                                            print(catValue
                                                                    .toString() +
                                                                ' ' +
                                                                catHint);
                                                          });
                                                        },
                                                      ),
                                                    ),
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
                                                    child: DropdownButton<int>(
                                                      elevation: 5,
                                                      hint: Container(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: Text(
                                                          cityHint,
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            fontFamily:
                                                                'CustomIcons',
                                                          ),
                                                        ),
                                                      ),
                                                      value: cityValue,
                                                      items: _rCities
                                                          .map((RCity city) {
                                                        return new DropdownMenuItem<
                                                            int>(
                                                          value: city.id,
                                                          child: Container(
                                                            alignment: Alignment
                                                                .centerRight,
                                                            child: new Text(
                                                              city.name,
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    "CustomIcons",
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      }).toList(),
                                                      onChanged: (int cityId) {
                                                        setState(() {
                                                          cityValue = cityId;

                                                          _regions = List.from(
                                                              _getRegions(
                                                                  cityValue,
                                                                  _rCities));
                                                          print(cityValue);
                                                        });
                                                      },
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
                                                      horizontal: 0.0),
                                              margin: const EdgeInsets.only(
                                                  top: 5.0),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    flex: 70,
                                                    child: FittedBox(
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 5.0),
                                                        child:
                                                            DropdownButton<int>(
                                                          elevation: 5,
                                                          hint: Container(
                                                            alignment: Alignment
                                                                .centerRight,
                                                            child: Text(
                                                              sortByHint,
                                                              style: TextStyle(
                                                                fontSize: 18,
                                                                fontFamily:
                                                                    'CustomIcons',
                                                              ),
                                                            ),
                                                          ),
                                                          value: sortByValue,
                                                          items: _sortByList
                                                              .map((SortBy sb) {
                                                            return new DropdownMenuItem<
                                                                int>(
                                                              value: sb.id,
                                                              child: Container(
                                                                alignment: Alignment
                                                                    .centerRight,
                                                                child: new Text(
                                                                  sb.name,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .right,
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        "CustomIcons",
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          }).toList(),
                                                          onChanged:
                                                              (int sbId) {
                                                            setState(() {
                                                              sortByValue =
                                                                  sbId;
                                                            });

                                                            Navigator.of(
                                                                    context)
                                                                .push(
                                                              new MaterialPageRoute(
                                                                builder: (BuildContext
                                                                        context) =>
                                                                    new AdvancedSearch(
                                                                  categoryId:
                                                                      catValue,
                                                                  subCategories:
                                                                      widget
                                                                          .subCategories,
                                                                  cityId:
                                                                      cityValue,
                                                                  regions: widget
                                                                      .regions,
                                                                  sortBy:
                                                                      sortByValue,
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 30,
                                                    child: GFButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .push(
                                                          new MaterialPageRoute(
                                                            builder: (BuildContext
                                                                    context) =>
                                                                new AdvancedSearch(
                                                              categoryId:
                                                                  catValue,
                                                              subCategories: widget
                                                                  .subCategories,
                                                              cityId: cityValue,
                                                              regions: widget
                                                                  .regions,
                                                              sortBy:
                                                                  sortByValue,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      text: "بحث",
                                                      blockButton: true,
                                                      color: Color(0xff65AECA),
                                                    ),
                                                  ),
                                                ],
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
