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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'questionId': questionId,
      'description': description,
      'isCorrect': isCorrect,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'questionId': questionId,
      'description': description,
      'isCorrect': isCorrect,
    };
  }

  Answer(this.id, this.questionId, this.description, this.isCorrect);
}
