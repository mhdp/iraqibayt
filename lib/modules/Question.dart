class Question {
  int id;
  String ask;
  int time;
  int quizId;

  Question({this.id, this.ask, this.time, this.quizId});

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as int,
      ask: json['ask'] as String,
      time: json['time'] as int,
      quizId: json['cat_quiz_id'] as int,
    );
  }
}
