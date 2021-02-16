class NotificationSample {
  int id;
  int addBy;
  int sentTo;
  int postId;
  String type;
  String content;
  String url;
  String createdAt;

  NotificationSample({
    this.id,
    this.addBy,
    this.sentTo,
    this.postId,
    this.type,
    this.content,
    this.url,
    this.createdAt,
  });

  factory NotificationSample.fromJson(Map<String, dynamic> json) {
    return NotificationSample(
      id: json['id'] as int,
      addBy: json['add_by'] as int,
      sentTo: json['send_to'] as int,
      postId: json['post_id'] as int,
      type: json['type'] as String,
      content: json['content'] as String,
      url: json['url'] as String,
      createdAt: json['created_at'] as String,
    );
  }
}
