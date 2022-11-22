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

  Future<bool> isAuthenticated() async {
    String token = '';
    await IOUtils.getFromStorage("token").then(((value) => token = value));
    if (token.isNotEmpty) {
      return IOUtils.setUserInfoController(token);
    }

    return false;
  }

  Future<String> loginWithUsername(String username, String password) async {
    try {
      final res = await http
          .post(Uri.parse("${url}Users/AppLogin"),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(UserInfo(username, password, "", "", "", 2)))
          .timeout(const Duration(seconds: TIME_OUT));
      if (res.statusCode == 200) {
        return parseToken(res.body);
      } else {
        log(res.body);
        return '';
      }
    } on TimeoutException {
      throw Exception('Không tải được dữ liệu.');
    }
  }

  Future<String> loginWithGmail(String gmail) async {
    try {
      final res = await http
          .post(Uri.parse("${url}Users/AppLogin"),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(UserInfo("", "", "gmail", "", "", 2)))
          .timeout(const Duration(seconds: TIME_OUT));
      if (res.statusCode == 200) {
        return parseToken(res.body);
      } else {
        return '';
      }
    } on TimeoutException {
      throw Exception('Không tải được dữ liệu.');
    }
  }

  Future<String> register(String username, String password, String? email,
      String? avatar, String? displayName) async {
    try {
      final res = await http
          .post(Uri.parse("${url}Users/Register"),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(
                  UserInfo(username, password, email, avatar, displayName, 2)))
          .timeout(const Duration(seconds: TIME_OUT));
      if (res.statusCode == 201) {
        log(res.body);
        return res.body;
      } else {
        log(res.body);
        return res.body;
      }
    } on TimeoutException {
      throw Exception('Không tải được dữ liệu.');
    }
  }

  Future<String> getUserByEmail(String email) async {
    try {
      final res = await http
          .post(Uri.parse("${url}Users/GetUserByEmail"),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(email))
          .timeout(const Duration(seconds: TIME_OUT));
      if (res.statusCode == 200) {
        return res.body;
      } else if (res.statusCode == 404) {
        log(res.body);
        return 'notfound';
      } else {
        return '';
      }
    } on TimeoutException {
      throw Exception('Không tải được dữ liệu.');
    }
  }

  Future<String> changePassword(String oldP, String newP) async {
    try {
      GlobalController gc = Get.put(GlobalController());

      if (gc.userId.value != '') {
        final res = await http
            .put(
              Uri.parse(
                  "${url}Users/${gc.userId.value}/ChangePassword?oldPassword=$oldP&newPassword=$newP"),
            )
            .timeout(const Duration(seconds: TIME_OUT));
        if (res.statusCode == 200) {
          return "Mật khẩu đã được thay đổi";
        } else if (res.statusCode == 403) {
          log(res.body);
          return res.body;
        }
      }
      return '';
    } on TimeoutException {
      throw Exception('Không tải được dữ liệu.');
    }
  }

  Future<String> forgotPassword(String newP) async {
    try {
      AuthController ac = Get.put(AuthController());
      log(ac.email.value);

      if (ac.email.value != '') {
        final res = await http
            .put(
              Uri.parse("${url}Users/ForgotPassword"),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(UserInfo("", newP, ac.email.value, "", "", 0)),
            )
            .timeout(const Duration(seconds: TIME_OUT));
        if (res.statusCode == 200) {
          return "Mật khẩu đã được thay đổi";
        } else if (res.statusCode == 403) {
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
