import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:vnrdn_tai/models/Keyword.dart';
import 'package:vnrdn_tai/shared/constants.dart';

class KeywordSerivce {
  List<Keyword> parseKeywords(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Keyword>((json) => Keyword.fromJson(json)).toList();
  }

  Future<List<Keyword>> GetKeywordList() async {
    try {
      final res = await http
          .get(Uri.parse("${url}Keywords"))
          .timeout(const Duration(seconds: TIME_OUT));
      if (res.statusCode == 200) {
        log(res.body);
        return parseKeywords(res.body);
      } else {
        throw Exception('Không tải được dữ liệu.');
      }
    } on TimeoutException {
      throw Exception('Không tải được dữ liệu.');
    } on Exception {
      throw Exception('Không thể kết nối');
    }
  }
}
