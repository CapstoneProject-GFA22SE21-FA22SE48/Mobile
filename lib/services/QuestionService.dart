import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/models/Question.dart';

class QuestionSerivce {
  final String url = "http://10.0.2.2:5000/api/";
  List<Question> parseQuestions(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Question>((json) => Question.fromJson(json)).toList();
  }

  Future<List<Question>> GetQuestionList() async {
    try {
      final res = await http
          .get(Uri.parse(url + "Questions"))
          .timeout(const Duration(seconds: 10));
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

  Future<List<Question>> GetRandomTestSetBytestCategoryId(
      String categoryName) async {
    try {
      final res = await http
          .get(Uri.parse(url + "TestCategories?categoryName=" + categoryName))
          .timeout(const Duration(seconds: 10));
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
