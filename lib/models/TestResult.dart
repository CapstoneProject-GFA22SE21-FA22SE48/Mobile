import 'dart:convert';

import 'package:vnrdn_tai/models/Answer.dart';
import 'package:vnrdn_tai/models/TestResultDetail.dart';

class TestResult {
  final String? id;
  late final String userId;
  late final String testCategoryId;
  final List<TestResultDetail> testResultDetails;
  final String createdDate;

  factory TestResult.fromJson(Map<String, dynamic> data) {
    return TestResult(
        data['id'],
        data['userId'],
        data['testCategoryId'],
        data['createdDate'],
        data['testResultDetails']
            .map((entry) => TestResultDetail(entry['id'], entry['testResultId'],
                entry['questionId'], entry['answerId'], entry['isCorrect']))
            .toList()
            .cast<TestResultDetail>());
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'testCategoryId': testCategoryId,
      'testResultDetails': testResultDetails
    };
  }

  TestResult(this.id, this.userId, this.testCategoryId, this.createdDate,
      this.testResultDetails);
}
