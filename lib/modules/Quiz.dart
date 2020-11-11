class Quiz {
  int id;
  String name;
  String image;

  Quiz({this.id, this.name, this.image});

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'] as int,
      name: json['name'] as String,
      image: json['img'] as String,
    );
  }
}
