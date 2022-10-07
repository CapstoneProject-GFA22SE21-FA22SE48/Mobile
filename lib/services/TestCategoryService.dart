import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vnrdn_tai/models/Category.dart';
import 'package:vnrdn_tai/shared/constants.dart';

class TestCategoryService {
  final String url = "http://10.0.2.2:5000/api/";
  List<TestCategory> parseQuestions(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<TestCategory>((json) => TestCategory.fromJson(json))
        .toList();
  }

  Future<List<TestCategory>> GetTestCategories() async {
    try {
      final res = await http
          .get(Uri.parse(url + "TestCategories"))
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
