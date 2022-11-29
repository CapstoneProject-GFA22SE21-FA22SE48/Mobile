import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:vnrdn_tai/controllers/auth_controller.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/models/GPSSign.dart';
import 'package:vnrdn_tai/models/SignModificationRequest.dart';
import '../shared/constants.dart';

class SignModificationRequestService {
  AuthController ac = Get.put(AuthController());
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
      final res = await http.get(
          Uri.parse(
            "${url}SignModificationRequests/Scribes/${gc.userId.value}/2",
          ),
          headers: {
            'Authorization': 'Bearer ${ac.token.value}',
          }).timeout(const Duration(seconds: TIME_OUT));
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
  Future<SignModificationRequest?> confirmEvidence(String gpsSignRomId,
      int status, String imageUrl, String adminId, String? signId) async {
    try {
      if (signId != null) {
        imageUrl = '$imageUrl%2F%$signId';
      }
      final res = await http
          .put(
            Uri.parse(
                "${url}SignModificationRequests/GPSSigns/$gpsSignRomId/$status/$adminId"),
            headers: <String, String>{
              "Content-Type": "application/json; charset=UTF-8",
              'Authorization': 'Bearer ${ac.token.value}',
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

  // create Feedback of GPSSigns
  Future<SignModificationRequest?> createScribeRequestGpsSign(
      String imageUrl, String adminId, GPSSign? newGpsSign) async {
    GlobalController gc = Get.put(GlobalController());
    SignModificationRequest request;
    try {
      request = SignModificationRequest(
          newGpsSign!.signId,
          null,
          null,
          newGpsSign.id,
          null,
          null,
          gc.userId.value,
          adminId,
          0,
          imageUrl,
          3,
          null,
          DateTime.now().toLocal().toString(),
          false);
      final res = await http
          .post(Uri.parse("${url}SignModificationRequests/AddGps"),
              headers: <String, String>{
                "Content-Type": "application/json; charset=UTF-8",
                'Authorization': 'Bearer ${ac.token.value}',
              },
              body: jsonEncode(request))
          .timeout(const Duration(seconds: TIME_OUT));
      if (res.statusCode == 201) {
        log(res.body);
        return SignModificationRequestService.parseSignModificationRequest(
            res.body);
      } else {
        log(res.body);
        return null;
      }
    } on TimeoutException {
      throw Exception('Không tải được dữ liệu.');
    }
  }
}
