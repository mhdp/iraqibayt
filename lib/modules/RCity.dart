import 'package:iraqibayt/modules/Region.dart';

class RCity {
  int id;
  String name;
  List<Region> regions;

  RCity({this.id, this.name, this.regions});

  factory RCity.fromJson(Map<String, dynamic> json) {
    var list = json['regions'] as List;
    //print(list.runtimeType);
    List<Region> regionsList = list.map((i) => Region.fromJson(i)).toList();
    return RCity(
      id: json['id'] as int,
      name: json['name'] as String,
      regions: regionsList,
    );
  }
}
