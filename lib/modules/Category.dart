import 'package:iraqibayt/modules/SubCategory.dart';

class Category {
  int id;
  String name;
  List<SubCategory> subCatList;

  Category({this.id, this.name, this.subCatList});

  factory Category.fromJson(Map<String, dynamic> json) {
    var list = json['sub_cats'] as List;
    //print(list.runtimeType);
    List<SubCategory> subcatList =
        list.map((i) => SubCategory.fromJson(i)).toList();
    return Category(
      id: json['id'] as int,
      name: json['name'] as String,
      subCatList: subcatList,
    );
  }
}
