import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:vnrdn_tai/controllers/auth_controller.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/utils/io_utils.dart';

import '../models/UserInfo.dart';
import '../shared/constants.dart';

class AuthService {
  String parseToken(String responseBody) {
    Map<String, dynamic> token = json.decode(responseBody);
    return token["token"];
  }

  Future<String> updateProfile(UserInfo newUser) async {
    try {
      GlobalController gc = Get.put(GlobalController());

      if (gc.userId.value != '') {
        final res = await http.put(
          Uri.parse("${url}Users"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: {jsonEncode(newUser)},
        ).timeout(const Duration(seconds: TIME_OUT));
        if (res.statusCode == 200) {
          return "Thông tin đã được thay đổi";
        } else if (res.statusCode == 500) {
          log(res.body);
          return res.body;
        }
      }
      return '';
    } on TimeoutException {
      throw Exception('Không tải được dữ liệu.');
    }
  }
}
