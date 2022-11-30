import 'package:vnrdn_tai/models/Answer.dart';

class Question {
  final String id;
  final String testCategoryId;
  final String questionCategoryId;
  final String content;
  final String? imageUrl;
  final int? status;
  final List<Answer> answers;

  factory Question.fromJson(Map<String, dynamic> data) {
    return Question(
      data['id'],
      data['testCategoryId'],
      data['questionCategoryId'],
      data['content'],
      data['imageUrl'],
      data['status'],
      data['answers']
          .map((entry) => Answer(entry['id'], entry['questionId'],
              entry['description'], entry['isCorrect']))
          .toList()
          .cast<Answer>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'testCategoryId': testCategoryId,
      'questionCategoryId': questionCategoryId,
      'content': content,
      'imageUrl': imageUrl,
      'status': status,
      'answers': answers
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'testCategoryId': testCategoryId,
      'questionCategoryId': questionCategoryId,
      'content': content,
      'imageUrl': imageUrl,
      'status': status,
      'answers': answers
    };
  }

  Question(this.id, this.testCategoryId, this.questionCategoryId, this.content,
      this.imageUrl, this.status, this.answers);
}
