import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class IOUtils {
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
      log('$value -----------------');
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
}
