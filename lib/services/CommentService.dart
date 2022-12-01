import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:vnrdn_tai/controllers/auth_controller.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/models/dtos/CommentSendDTO.dart';

import '../models/Comment.dart';
import '../shared/constants.dart';

class CommentService {
  List<Comment> parseComments(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Comment>((json) => Comment.fromJson(json)).toList();
  }

  Comment parseComment(String responseBody) {
    final parsed = json.decode(responseBody);
    return Comment(
      parsed['id'],
      parsed['userId'],
      parsed['avatar'],
      parsed['displayName'],
      parsed['content'],
      parsed['rating'],
      parsed['createdDate'],
    );
  }

  Future<List<Comment>> getComments() async {
    GlobalController gc = Get.put(GlobalController());
    AuthController ac = Get.put(AuthController());
    try {
      final res = await http.get(
        Uri.parse("${url}Comments/All"),
        headers: {
          'Authorization': 'Bearer ${ac.token.value}',
        },
      ).timeout(const Duration(seconds: TIME_OUT));
      if (res.statusCode == 200) {
        List<Comment> list = parseComments(res.body);
        list.sort(((a, b) => b.createdDate.compareTo(a.createdDate)));
        return list;
      } else {
        return [];
      }
    } on TimeoutException {
      throw Exception('Không tải được dữ liệu.');
    }
  }

  Future<String> createComment(String content, int rating) async {
    GlobalController gc = Get.put(GlobalController());
    AuthController ac = Get.put(AuthController());
    try {
      final res = await http
          .post(Uri.parse("${url}Comments/${gc.userId.value}"),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
                'Authorization': 'Bearer ${ac.token.value}',
              },
              body: jsonEncode(
                  CommentSendDTO(gc.userId.value, content.trim(), rating)))
          .timeout(const Duration(seconds: TIME_OUT));
      if (res.statusCode == 201) {
        return res.body;
      } else {
        return '';
      }
    } on TimeoutException {
      throw Exception('Không tải được dữ liệu.');
    }
  }
}
