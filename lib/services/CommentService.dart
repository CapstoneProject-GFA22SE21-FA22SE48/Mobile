import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
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
    try {
      final res = await http
          .get(Uri.parse("${url}Comments/All"))
          .timeout(const Duration(seconds: TIME_OUT));
      if (res.statusCode == 200) {
        log(res.body);
        List<Comment> list = parseComments(res.body);
        list.sort(((a, b) => b.createdDate.compareTo(a.createdDate)));
        return list;
      } else {
        log(res.body);
        return [];
      }
    } on TimeoutException {
      throw Exception('Không tải được dữ liệu.');
    }
  }

  Future<String> createComment(String content, int rating) async {
    GlobalController gc = Get.put(GlobalController());
    try {
      log(gc.userId.value);
      final res = await http
          .post(Uri.parse("${url}Comments/${gc.userId.value}"),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body:
                  jsonEncode(CommentSendDTO(gc.userId.value, content, rating)))
          .timeout(const Duration(seconds: TIME_OUT));
      if (res.statusCode == 201) {
        log(res.body);
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
