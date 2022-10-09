import 'dart:convert';

import 'package:vnrdn_tai/models/Answer.dart';
import 'package:vnrdn_tai/models/TestResult.dart';
import 'package:vnrdn_tai/models/TestResultDetail.dart';

class TestAttempDTO {
  final String? imageUrl;
  final String questionContent;
  final String chosenAnswerContent;
  final String correctAnswerContent;
  final bool isCorrect;

  factory TestAttempDTO.fromJson(Map<String, dynamic> data) {
    return TestAttempDTO(
        data['imageUrl'],
        data['questionContent'],
        data['chosenAnswerContent'],
        data['correctAnswerContent'],
        data['isCorrect']);
  }

  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
      'questionContent': questionContent,
      'chosenAnswerContent': chosenAnswerContent,
      'correctAnswerContent': correctAnswerContent,
      'isCorrect': isCorrect
    };
  }

  TestAttempDTO(this.imageUrl, this.questionContent, this.chosenAnswerContent,
      this.correctAnswerContent, this.isCorrect);
}
