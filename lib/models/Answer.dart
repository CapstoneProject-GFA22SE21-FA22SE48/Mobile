import 'dart:ffi';

class Answer {
  final String id;
  final String questionId;
  final String description;
  final bool isCorrect;

  factory Answer.fromJson(Map<String, dynamic> data) {
    return Answer(
      data['id'],
      data['questionId'],
      data['description'],
      data['isCorrect'],
    );
  }

  Answer(this.id, this.questionId, this.description, this.isCorrect);
}
