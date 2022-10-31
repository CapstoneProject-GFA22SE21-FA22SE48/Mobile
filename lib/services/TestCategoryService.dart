import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:vnrdn_tai/models/TestCategory.dart';
import 'package:vnrdn_tai/models/dtos/TestCategoryDTO.dart';
import 'package:vnrdn_tai/shared/constants.dart';

class TestCategoryService {
  List<TestCategory> parseQuestions(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<TestCategory>((json) => TestCategory.fromJson(json))
        .toList();
  }

  List<TestCategoryDTO> parseDTO(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<TestCategoryDTO>((json) => TestCategoryDTO.fromJson(json))
        .toList();
  }

  Future<List<TestCategoryDTO>> GetTestCategories() async {
    try {
      final res = await http
          .get(Uri.parse(url + "TestCategories/Count"))
          .timeout(const Duration(seconds: TIME_OUT));
      if (res.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        log(res.body);
        return parseDTO(res.body);
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Không tải được dữ liệu.');
      }
    } on TimeoutException {
      throw Exception('Không tải được dữ liệu.');
    }
  }

  Future<List<TestCategoryDTO>> GetQuestionsCount() async {
    try {
      final res = await http
          .get(Uri.parse("${url}TestCategories/Count"))
          .timeout(const Duration(seconds: TIME_OUT));
      if (res.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        log(res.body);
        return parseDTO(res.body);
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
