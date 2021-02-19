class Chat {
  int id;
  int send;
  int receive;
  int postId;
  String body;
  String createdAt;

  Chat({
    this.id,
    this.send,
    this.receive,
    this.postId,
    this.body,
    this.createdAt,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'] as int,
      send: json['send'] as int,
      receive: json['recive'] as int,
      postId: json['post_id'] as int,
      body: json['body'] as String,
      createdAt: json['created_at'] as String,
    );
  }
}
