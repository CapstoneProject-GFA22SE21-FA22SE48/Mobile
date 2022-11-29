import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:vnrdn_tai/controllers/auth_controller.dart';
import 'package:vnrdn_tai/models/TestCategory.dart';
import 'package:vnrdn_tai/models/TestResult.dart';
import 'package:vnrdn_tai/models/dtos/testAttemptDTO.dart';
import 'package:vnrdn_tai/shared/constants.dart';

class TestResultSerivce {
  AuthController ac = Get.put(AuthController());
  List<TestResult> parseTestResultsTestResult(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<TestResult>((json) => TestResult.fromJson(json)).toList();
  }

  List<TestAttempDTO> parseTestResultsTestAttemptDTO(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<TestAttempDTO>((json) => TestAttempDTO.fromJson(json))
        .toList();
  }

  Future<List<TestResult>> GetTestResultList(userId, testCategoryId) async {
    try {
      final res = await http.get(
        Uri.parse(
            '${url}TestResults/GetTestResultByUserId?userId=$userId&&testCategoryId=$testCategoryId'),
        headers: {
          'Authorization': 'Bearer ${ac.token.value}',
        },
      ).timeout(const Duration(seconds: TIME_OUT));
      if (res.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        return parseTestResultsTestResult(res.body);
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Không tải được dữ liệu.');
      }
    } on TimeoutException {
      throw Exception('Không tải được dữ liệu.');
    } catch (ex) {
      throw Exception('Không thể kết nối');
    }
  }

  Future<List<TestResult>> GetWrongList(userId) async {
    try {
      final res = await http.get(
          Uri.parse('${url}TestResults/GetTestResultByUserId?userId=$userId'),
          headers: {
            'Authorization': 'Bearer ${ac.token.value}',
          }).timeout(const Duration(seconds: TIME_OUT));
      if (res.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        return parseTestResultsTestResult(res.body);
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Không tải được dữ liệu.');
      }
    } on TimeoutException {
      throw Exception('Không tải được dữ liệu.');
    } catch (ex) {
      throw Exception('Không thể kết nối');
    }
  }

  Future<List<TestAttempDTO>> GetTestAttemptDTOs(
      testResultId, userId, testCategoryId) async {
    try {
      final res = await http.get(
          // ignore: prefer_interpolation_to_compose_strings
          Uri.parse("${url}TestResults/GetTestAttemptDTOs?testResultId=" +
              testResultId +
              "&userId=" +
              userId +
              "&testCategoryId=" +
              testCategoryId),
          headers: {
            'Authorization': 'Bearer ${ac.token.value}',
          }).timeout(const Duration(seconds: TIME_OUT));
      if (res.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        return parseTestResultsTestAttemptDTO(res.body);
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
    try {
      final res = await http.post(
        Uri.parse('${url}TestResults'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${ac.token.value}',
        },
        body: jsonEncode(testResult),
      );
      if (res.statusCode == 201) {
        return true;
      } else {
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
