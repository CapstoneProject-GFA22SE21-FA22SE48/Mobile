import 'package:vnrdn_tai/models/Answer.dart';

class TestResultDetail {
  final String? id;
  final String? testResultId;
  late final String questionId;
  late final String answerId;
  late final bool isCorrect;

  factory TestResultDetail.fromJson(Map<String, dynamic> data) {
    return TestResultDetail(
      data['id'],
      data['testResultId'],
      data['questionId'],
      data['answerId'],
      data['isCorrect'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'testResultId': testResultId,
      'questionId': questionId,
      'answerId': answerId,
      'isCorrect': isCorrect
    };
  }

  TestResultDetail(this.id, this.testResultId, this.questionId, this.answerId,
      this.isCorrect);
}
