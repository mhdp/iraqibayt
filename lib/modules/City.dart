import 'package:iraqibayt/modules/Region.dart';

class City {
  int id;
  String name;
  List<Region> regions;

  City({this.id, this.name, this.regions});

  factory City.fromJson(Map<String, dynamic> json) {
    var list = json['regions'] as List;
    //print(list.runtimeType);
    List<Region> regionsList = list.map((i) => Region.fromJson(i)).toList();
    return City(
      id: json['id'] as int,
      name: json['name'] as String,
      regions: regionsList,
    );
  }
}
