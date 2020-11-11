class Answer {
  int id;
  String answer;
  int right;
  int askId;

  Answer({this.id, this.answer, this.right, this.askId});

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      id: json['id'] as int,
      answer: json['answer'] as String,
      right: json['right'] as int,
      askId: json['ask_quiz_id'] as int,
    );
  }
}
