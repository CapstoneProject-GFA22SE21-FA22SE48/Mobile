import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/models/GPSSign.dart';
import 'package:vnrdn_tai/models/SignModificationRequest.dart';
import '../shared/constants.dart';

class SignModificationRequestService {
  static List<SignModificationRequest> parseSignModificationRequestList(
      String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<SignModificationRequest>(
            (json) => SignModificationRequest.fromJson(json))
        .toList();
  }

  static SignModificationRequest parseSignModificationRequest(
      String responseBody) {
    final parsed = Map<String, dynamic>.from(json.decode(responseBody));
    return SignModificationRequest.fromJson(parsed);
  }

  // get all SignModificationRequests of Claimed (2) status
  Future<List<SignModificationRequest>> getClaimedRequests() async {
    GlobalController gc = Get.put(GlobalController());
    try {
      final res = await http
          .get(
            Uri.parse(
              "${url}SignModificationRequests/Scribes/${gc.userId.value}/2",
            ),
          )
          .timeout(const Duration(seconds: TIME_OUT));
      if (res.statusCode == 200) {
        log(res.body);
        return parseSignModificationRequestList(res.body);

      } else {
        log(res.body);
        return [];
      }
    } on TimeoutException {
      throw Exception('Không tải được dữ liệu.');
    }
  }

  // put an update of Confirmation with image as evidence
  Future<SignModificationRequest?> confirmEvidence(
      String gpsSignRomId, int status, String imageUrl, String adminId) async {
    try {
      // chưa có ở BE
      final res = await http
          .put(
            // need add /$status
            Uri.parse(
                "${url}SignModificationRequests/GPSSigns/$gpsSignRomId/$status/$adminId"),
            headers: <String, String>{
              "Content-Type": "application/json; charset=UTF-8"
            },
            body: jsonEncode(imageUrl),
          )
          .timeout(const Duration(seconds: TIME_OUT));
      if (res.statusCode == 200) {
        log(res.body);
        return parseSignModificationRequest(res.body);
      } else {
        log(res.body);
        return null;
      }
    } on TimeoutException {
      throw Exception('Không tải được dữ liệu.');
    }
  }
}
