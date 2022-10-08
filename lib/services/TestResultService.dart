import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vnrdn_tai/models/TestResult.dart';
import 'package:vnrdn_tai/shared/constants.dart';

class TestResultSerivce {
  List<TestResult> parseTestResults(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<TestResult>((json) => TestResult.fromJson(json)).toList();
  }

  Future<List<TestResult>> GetTestResultList(userId) async {
    try {
      final res = await http
          .get(Uri.parse(
              url + "TestResults/GetTestResultByUserId?userId=" + userId))
          .timeout(const Duration(seconds: TIME_OUT));
      if (res.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        return parseTestResults(res.body);
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

  Future<bool> saveTestResult(TestResult testResult) async {
    print(jsonEncode(testResult));
    try {
      final res = await http.post(
        Uri.parse(url + 'TestResults/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(testResult),
      );
      if (res.statusCode == 201) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        return true;
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Không tải được dữ liệu.');
      }
    } on TimeoutException {
      throw Exception('Không tải được dữ liệu.');
    } on Exception catch (e) {
      print(e);
      throw Exception('Không thể kết nối');
    }
  }
}
