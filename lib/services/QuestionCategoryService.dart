import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:vnrdn_tai/models/TestCategory.dart';
import 'package:vnrdn_tai/models/QuestionCategory.dart';
import 'package:vnrdn_tai/shared/constants.dart';

class QuestionCategoryService {
  List<QuestionCategory> parseQuestions(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<QuestionCategory>((json) => QuestionCategory.fromJson(json))
        .toList();
  }

  Future<List<QuestionCategory>> GetQuestionCategoriesByTestCategory(
      String testCategoryId) async {
    try {
      final res = await http
          .get(Uri.parse(url +
              "QuestionCategories/GetQuestionCategoriesByTestCategoryId/" +
              testCategoryId))
          .timeout(const Duration(seconds: TIME_OUT));
      if (res.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        return parseQuestions(res.body);
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Không tải được dữ liệu.');
      }
    } on TimeoutException {
      throw Exception('Không tải được dữ liệu.');
    }
  }
}
