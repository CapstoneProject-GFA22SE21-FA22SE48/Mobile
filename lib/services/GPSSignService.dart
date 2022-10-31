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

  // distance can be modified
  Future<List<GPSSign>> getNearbySigns(
      double latitude, double longtitude, double distance) async {
    try {
      final res = await http
          .get(
            Uri.parse(
                "${url}Users/GetNearbySigns?latitude=$latitude&longtitude=$longtitude&distance=$distance"),
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
}
