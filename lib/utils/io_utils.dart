import 'dart:developer';

import 'package:get/get.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vnrdn_tai/controllers/auth_controller.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';

class IOUtils {
  static Future initialize() async {
    await getFromStorage('token');
  }

  static Future<bool> saveToStorage(String key, String value) async {
    try {
      // obtain shared preferences
      final prefs = await SharedPreferences.getInstance();
      // set value
      await prefs.setString(key, value);
      return true;
    } on Exception {
      throw Exception('Setting $key causes error.');
    }
  }

  static Future<String> getFromStorage(String key) async {
    try {
      // obtain shared preferences
      final prefs = await SharedPreferences.getInstance();
      // get value
      String? value = prefs.getString(key);
      return value ?? '';
    } on Exception {
      throw Exception('Getting $key causes error.');
    }
  }

  static Future<bool> removeData(String key) async {
    try {
      // obtain shared preferences
      final prefs = await SharedPreferences.getInstance();
      // remove var
      return await prefs.remove(key);
    } on FormatException {
      throw Exception('Removing $key causes error.');
    }
  }

  static Future<bool> removeAllData() async {
    try {
      // obtain shared preferences
      final prefs = await SharedPreferences.getInstance();
      // remove var
      return await prefs.clear();
    } on FormatException {
      throw Exception('Clearing data causes error.');
    }
  }

  static Future<bool> removeUserData(List<String> keys) async {
    try {
      bool cont = true;
      // remove vars
      for (var key in keys) {
        removeData(key).then((value) => cont = value);

        if (!cont) {
          return false;
        }
      }
      return cont;
    } on FormatException {
      throw Exception('Removing $keys causes error.');
    }
  }

  static bool setUserInfoController(String token) {
    int allDone = 0;
    GlobalController gc = Get.put(GlobalController());
    AuthController ac = Get.put(AuthController());

    Jwt.parseJwt(token).forEach((key, value) {
      // IOUtils.saveToStorage(key, value.toString());
      switch (key) {
        case 'Id':
          gc.updateUserId(value);
          allDone++;
          break;
        case 'Username':
          gc.updateUsername(value);
          allDone++;
          break;
        case 'Email':
          ac.updateEmail(value);
          allDone++;
          break;
        case 'Role':
          ac.updateRole(int.parse(value));
          allDone++;
          break;
        case 'Status':
          ac.updateStatus(int.parse(value));
          allDone++;
          break;
        case 'Avatar':
          ac.updateAvatar(value);
          allDone++;
          break;
        case 'DisplayName':
          ac.updateDisplayName(value);
          allDone++;
          break;
      }
    });
    return allDone > 3;
  }

  static void clearUserInfoController() {
    GlobalController gc = Get.put(GlobalController());
    AuthController ac = Get.put(AuthController());

    gc.updateUserId('');
    gc.updateUsername('');
    ac.updateEmail('');
    ac.updateRole(2);
    ac.updateStatus(5);
    ac.updateAvatar('');
    ac.updateDisplayName('');
  }
}
