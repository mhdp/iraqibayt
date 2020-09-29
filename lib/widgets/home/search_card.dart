import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:iraqibayt/modules/City.dart';
import 'package:iraqibayt/modules/Category.dart';
import 'package:iraqibayt/modules/subCategory.dart';
import 'package:iraqibayt/modules/Region.dart';

class SearchCard extends StatefulWidget {
  @override
  _SearchCardState createState() => _SearchCardState();
}

class _SearchCardState extends State<SearchCard> {
  final List<City> cities = [
    City(id: 0, name: 'جميع المدن'),
    City(id: 1, name: 'بغداد'),
    City(id: 2, name: 'الأنبار'),
    City(id: 3, name: 'أربيل'),
  ];
  final List<Region> regions = [
    Region(id: 0, name: 'جميع المناطق'),
    Region(id: 1, name: 'الجادرية'),
    Region(id: 2, name: 'الكرخ'),
    Region(id: 3, name: 'المنصور'),
    Region(id: 4, name: 'الكرادة'),
  ];
  final List<Category> categories = [
    Category(id: 0, name: 'جميع الأقسام'),
    Category(id: 1, name: 'عقارات للبيع'),
    Category(id: 2, name: 'عقارات للإيجار'),
  ];
  final List<SubCategory> subCategories = [
    SubCategory(id: 0, name: 'جميع الأقسام الفرعية'),
    SubCategory(id: 1, name: 'أرض سكنية للبيع'),
    SubCategory(id: 2, name: 'شقق للبيع'),
    SubCategory(id: 3, name: 'بيوت للبيع'),
    SubCategory(id: 4, name: 'أرض زراعية للبيع'),
    SubCategory(id: 5, name: 'عمارة سكنية للبيع'),
  ];

  int catValue;
  String catHint;
  int subCatValue;
  String subCatHint;
  int cityValue;
  String cityHint;
  int regionValue;
  String regionHint;

  @override
  Widget build(BuildContext context) {
    catHint = categories[0].name;
    subCatHint = subCategories[0].name;
    cityHint = cities[0].name;
    regionHint = regions[0].name;

    return Container(
      child: GFCard(
        title: GFListTile(
          padding: const EdgeInsets.symmetric(horizontal: 60),
          color: Colors.blue,
          title: Text(
            'محرك بحث العقارات',
            style: TextStyle(fontSize: 18, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
        content: Column(
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
                      items: categories.map((Category category) {
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
                          catHint = categories[catId].name;
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
                          catHint,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      value: subCatValue,
                      items: subCategories.map((SubCategory subategory) {
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
                          subCatHint = subCategories[subCatId].name;
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
                      items: cities.map((City city) {
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
                          cityHint = cities[cityId].name;
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
                      items: regions.map((Region region) {
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
                          regionHint = regions[regionId].name;
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
              ),
            )
          ],
        ),
      ),
    );
  }
}
