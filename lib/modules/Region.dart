class Region {
  int id;
  String name;
  int cityId;
  int countryId;
  int checked;

  Region({this.id, this.name, this.cityId, this.countryId, this.checked});

  factory Region.fromJson(Map<String, dynamic> json) {
    return Region(
      id: json['id'] as int,
      name: json['name'] as String,
      cityId: json['city_id'] as int,
      countryId: json['country_id'] as int,
      checked: json['checked'] as int,
    );
  }
}
