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

  GPSSign parseGPSSign(String responseBody) {
    Map<String, dynamic> parsed = json.decode(responseBody);
    return GPSSign(parsed['id'], parsed['signId'], parsed['imageUrl'],
        parsed['latitude'], parsed['longitude']);
  }

  // distance can be modified
  Future<List<GPSSign>> GetNearbySigns(
      double latitude, double longitude, double distance) async {
    log('$latitude, $longitude, $distance');
    try {
      final res = await http
          .get(
            Uri.parse(
                "${url}Gpssigns/GetNearbyGpsSign?latitude=$latitude&longitude=$longitude&distance=$distance"),
          )
          .timeout(const Duration(seconds: TIME_OUT));
      if (res.statusCode == 200) {
        log(res.body);
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
    double longitude,
  ) async {
    try {
      final res = await http
          .post(
            Uri.parse("${url}Gpssigns/AddGpsSignDTO"),
            headers: <String, String>{
              "Content-Type": "application/json; charset=UTF-8"
            },
            body: jsonEncode(
              GPSSign(signId, signId, "", latitude, longitude),
            ),
          )
          .timeout(const Duration(seconds: TIME_OUT));
      if (res.statusCode == 201) {
        log(res.body);
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
