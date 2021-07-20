class Post {
  int id;
  String title;
  String time;

  Post({this.id, this.title, this.time});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as int,
      title: json['title'] as String,
      time: json['created_at'] as String,
    );
  }
}
