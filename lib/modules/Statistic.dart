class Statistic {
  int id;
  String title;
  String body;

  Statistic({this.id, this.title, this.body});

  factory Statistic.fromJson(Map<String, dynamic> json) {
    return Statistic(
      id: json['id'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
    );
  }
}
