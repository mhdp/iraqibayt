class System {
  int id;
  String name;
  String type;
  String description;

  System({this.id, this.name, this.type, this.description});

  factory System.fromJson(Map<String, dynamic> json) {
    return System(
      id: json['id'] as int,
      name: json['name'] as String,
      type: json['type'] as String,
      description: json['description'] as String,
    );
  }
}
