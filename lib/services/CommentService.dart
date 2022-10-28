import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:vnrdn_tai/controllers/global_controller.dart';

import '../models/Comment.dart';
import '../shared/constants.dart';

class CommentService {
  List<Comment> parseComments(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Comment>((json) => Comment.fromJson(json)).toList();
    ;
  }

  // post
  Future<List<Comment>> getComments() async {
    GlobalController gc = Get.put(GlobalController());
    try {
      final res = await http
          .post(Uri.parse("${url}Comments/Members/${gc.userId.value}"))
          .timeout(const Duration(seconds: TIME_OUT));
      if (res.statusCode == 200) {
        return parseComments(res.body);
      } else {
        log(res.body);
        return [];
      }
    } on TimeoutException {
      throw Exception('Không tải được dữ liệu.');
    }
  }

  // post
  Future<String> createComment(String comment) async {
    GlobalController gc = Get.put(GlobalController());
    try {
      final res = await http
          .post(Uri.parse("${url}Comments"),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(
                  Comment(null, gc.userId.value, comment, DateTime.now())))
          .timeout(const Duration(seconds: TIME_OUT));
      if (res.statusCode == 201) {
        return res.body;
      } else {
        log(res.body);
        return '';
      }
    } on TimeoutException {
      throw Exception('Không tải được dữ liệu.');
    }
  }

  // delete
  Future<String> deleteComment(String comment) async {
    GlobalController gc = Get.put(GlobalController());
    try {
      final res = await http
          .delete(Uri.parse("${url}Comments"),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(
                  Comment(null, gc.userId.value, comment, DateTime.now())))
          .timeout(const Duration(seconds: TIME_OUT));
      if (res.statusCode == 201) {
        return res.body;
      } else {
        log(res.body);
        return '';
      }
    } on TimeoutException {
      throw Exception('Không tải được dữ liệu.');
    }
  }
}
