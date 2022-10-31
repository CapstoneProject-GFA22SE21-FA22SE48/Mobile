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
    ;
  }

  // post
  Future<List<Comment>> getComments() async {
    GlobalController gc = Get.put(GlobalController());
    log(gc.userId.value);
    try {
      final res = await http
          .get(Uri.parse("${url}Comments/Members/${gc.userId.value}"))
          .timeout(const Duration(seconds: TIME_OUT));
      if (res.statusCode == 200) {
        log(res.body);
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
  Future<String> createComment(String content) async {
    GlobalController gc = Get.put(GlobalController());
    log(url);
    try {
      final res = await http
          .post(
              Uri.parse(
                  "${url}Comments/${gc.userId.value.isNotEmpty ? gc.userId.value : emptyUserId}"),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(content))
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

  // delete
  Future<String> deleteComment(String content) async {
    GlobalController gc = Get.put(GlobalController());
    try {
      final res = await http
          .delete(Uri.parse("${url}Comments"),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(CommentSendDTO(gc.userId.value, content)))
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
