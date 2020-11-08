class About {
  int id;
  String title;
  String body;

  About({this.id, this.title, this.body});

  factory About.fromJson(Map<String, dynamic> json) {
    return About(
      id: json['id'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
    );
  }
}
