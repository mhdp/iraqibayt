class Favorite {
  int id;
  int userId;
  int postId;
  String postTitle;

  Favorite({
    this.id,
    this.userId,
    this.postId,
    this.postTitle,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      postId: json['post_id'] as int,
      postTitle: json['post']['title'] ?? 'title ' as String,
    );
  }
}
