import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:vnrdn_tai/models/GPSSign.dart';
import '../shared/constants.dart';

class GPSSignService {
  List<GPSSign> parseGPSSigns(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<GPSSign>((json) => GPSSign.fromJson(json)).toList();
  }

  Future<GPSSign> parseGPSSign(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<GPSSign>((json) => GPSSign.fromJson(parsed));
  }

  // distance can be modified
  Future<List<GPSSign>> GetNearbySigns(
      double latitude, double longtitude, double distance) async {
    try {
      final res = await http
          .get(
            Uri.parse(
                "${url}Gpssigns/GetNearbySigns?latitude=$latitude&longtitude=$longtitude&distance=$distance"),
          )
          .timeout(const Duration(seconds: TIME_OUT));
      if (res.statusCode == 200) {
        return parseGPSSigns(res.body);
      } else {
        log(res.body);
        return [];
      }
    } on TimeoutException {
      throw Exception('Không tải được dữ liệu.');
    }
  }

  Future<GPSSign?> AddGpsSign(
    String signId,
    double latitude,
    double longtitude,
  ) async {
    try {
      final res = await http
          .post(
            Uri.parse("${url}Gpssigns/AddGpsSignDTO"),
            headers: <String, String>{
              "Content-Type": "application/json; charset=UTF-8"
            },
            body: jsonEncode(
              GPSSign(signId, signId, null, latitude, longtitude),
            ),
          )
          .timeout(const Duration(seconds: TIME_OUT));
      if (res.statusCode == 201) {
        return parseGPSSign(res.body);
      } else {
        log(res.body);
        return null;
      }
    } on TimeoutException {
      throw Exception('Không tải được dữ liệu.');
    }
  }
}
