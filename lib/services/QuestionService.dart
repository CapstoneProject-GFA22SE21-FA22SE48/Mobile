import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:vnrdn_tai/controllers/auth_controller.dart';
import 'package:vnrdn_tai/models/Question.dart';
import 'package:vnrdn_tai/shared/constants.dart';

class QuestionSerivce {
  AuthController ac = Get.put(AuthController());

  List<Question> parseQuestions(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Question>((json) => Question.fromJson(json)).toList();
  }

  Future<List<Question>> GetQuestionList() async {
    try {
      final res = await http.get(Uri.parse("${url}Questions"), headers: {
        'Authorization': 'Bearer ${ac.token.value}',
      }).timeout(const Duration(seconds: TIME_OUT));
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
    } on Exception {
      throw Exception('Không thể kết nối');
    }
  }

  // ignore: non_constant_identifier_names
  Future<List<Question>> GetRandomTestSetBytestCategoryId(
      String categoryId) async {
    try {
      final res = await http.get(
          Uri.parse(
              "${url}Questions/GetRandomTestSetByCategoryId?categoryId=$categoryId"),
          headers: {
            'Authorization': 'Bearer ${ac.token.value}',
          }).timeout(const Duration(seconds: TIME_OUT));
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

  Future<List<Question>> GetStudySetByCategoryAndSeparator(
      String categoryId, String questionCategoryId, int separator) async {
    try {
      final res = await http.get(
        // ignore: prefer_interpolation_to_compose_strings
        Uri.parse(url +
            "Questions/GetStudySetByCategoryAndSeparator?categoryId=" +
            categoryId +
            "&questionCategoryId=" +
            questionCategoryId +
            "&separator=" +
            separator.toString()),
        headers: {
          'Authorization': 'Bearer ${ac.token.value}',
        },
      ).timeout(const Duration(seconds: TIME_OUT));
      if (res.statusCode == 200) {
        return parseQuestions(res.body);
      } else {
        throw Exception('Không tải được dữ liệu.');
      }
    } on TimeoutException {
      throw Exception('Không tải được dữ liệu.');
    }
  }
}
