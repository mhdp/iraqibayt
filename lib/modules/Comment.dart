class Comment {
  int id;
  int userId;
  int postId;
  String body;
  String createdAt;
  String authorName;

  Comment(
      {this.id,
      this.userId,
      this.postId,
      this.body,
      this.createdAt,
      this.authorName});

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      postId: json['post_id'] as int,
      body: json['body'] as String,
      createdAt: json['created_at'] as String,
      authorName: json['user']['name'] as String,
    );
  }
}
