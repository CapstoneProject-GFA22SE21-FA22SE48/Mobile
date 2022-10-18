import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:http/http.dart' as http;
import 'package:vnrdn_tai/utils/android_io.dart';

import '../models/UserInfo.dart';
import '../shared/constants.dart';

class AuthService {
  String parseToken(String responseBody) {
    Map<String, dynamic> token = json.decode(responseBody);
    log(token["token"]);
    return token["token"];
  }

  Future<bool> isAuthenticated() async {
    String token = '';
    await AndroidIO.getFromStorage("token").then(((value) => token = value));
    return token.isNotEmpty;
  }

  Future<String> loginWithUsername(String username, String password) async {
    try {
      final res = await http
          .post(Uri.parse("${url}Users/AppLogin"),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(UserInfo(username, password, "")))
          .timeout(const Duration(seconds: TIME_OUT));
      if (res.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        return parseToken(res.body);
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
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
              body: jsonEncode(UserInfo("", "", "gmail")))
          .timeout(const Duration(seconds: TIME_OUT));
      if (res.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        return parseToken(res.body);
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        return '';
      }
    } on TimeoutException {
      throw Exception('Không tải được dữ liệu.');
    }
  }
}
