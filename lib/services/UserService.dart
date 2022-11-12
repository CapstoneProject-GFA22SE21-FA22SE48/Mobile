import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/models/dtos/AdminDTO.dart';
import 'package:vnrdn_tai/models/dtos/ProfileDTO.dart';
import 'package:vnrdn_tai/services/AuthService.dart';
import 'package:vnrdn_tai/utils/io_utils.dart';

import '../models/UserInfo.dart';
import '../shared/constants.dart';

class UserService {
  List<AdminDTO> parseAdmins(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<AdminDTO>((json) => AdminDTO(
            json['id'],
            json['username'],
            json['pendingRequests'],
            json['email'],
            json['avatar'],
            json['displayName'],
            json['role']))
        .toList();
  }

  Future<List<AdminDTO>> getAdmins() async {
    try {
      GlobalController gc = Get.put(GlobalController());

      if (gc.userId.value != '') {
        final res = await http
            .get(Uri.parse("${url}Users/Admins"))
            .timeout(const Duration(seconds: TIME_OUT));
        if (res.statusCode == 200) {
          log(res.body);
          return parseAdmins(res.body);
        } else if (res.statusCode == 500) {
          log(res.body);
          return [];
        }
      }
      return [];
    } on TimeoutException {
      throw Exception('Không tải được dữ liệu.');
    }
  }

  Future<String> updateProfile(
      String avatar, String email, String displayName) async {
    try {
      GlobalController gc = Get.put(GlobalController());

      if (gc.userId.value != '') {
        final res = await http
            .put(
              Uri.parse("${url}Users/${gc.userId.value}/UpdateProfile"),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(ProfileDTO(email, avatar, displayName)),
            )
            .timeout(const Duration(seconds: TIME_OUT));
        if (res.statusCode == 200) {
          log(res.body);
          String token = AuthService().parseToken(res.body);
          IOUtils.setUserInfoController(token);
          IOUtils.saveToStorage('token', token);
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

  Future<String> deactivate() async {
    try {
      GlobalController gc = Get.put(GlobalController());

      if (gc.userId.value != '') {
        final res = await http
            .put(Uri.parse("${url}Users/SelfDeactivate/${gc.userId.value}"))
            .timeout(const Duration(seconds: TIME_OUT));
        if (res.statusCode == 200) {
          return "Ngưng hoạt động thành công.";
        } else if (res.statusCode == 400) {
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
