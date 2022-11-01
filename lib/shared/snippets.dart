import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:getwidget/getwidget.dart';
import 'package:vnrdn_tai/screens/container_screen.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:vnrdn_tai/shared/constants.dart';

upload(File imageFile, {bool cont = true}) async {
  print(cont);
  if (!cont) return "[]";
  // open a bytestream
  var stream =
      new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
  // get file length
  var length = await imageFile.length();

  // string to uri
  var uri = Uri.parse(ai_url);

  // create multipart request
  var request = http.MultipartRequest("POST", uri);

  // multipart that takes file
  var multipartFile = http.MultipartFile('file', stream, length,
      filename: basename(imageFile.path));

  // add file to multipart
  request.files.add(multipartFile);

  // send
  var response = await request.send();
  return await response.stream.bytesToString();
}

numberEngToVietWord(String input) {
  var res = input;
  res = res
      .replaceAll("zero", "không")
      .replaceAll("one", "một")
      .replaceAll("two", "hai")
      .replaceAll("three", "ba")
      .replaceAll("four", "bốn")
      .replaceAll("five", "năm")
      .replaceAll("six", "sáu")
      .replaceAll("seven", "bảy")
      .replaceAll("eight", "tám")
      .replaceAll("nine", "chín")
      .replaceAll("ten", "mười")
      .replaceAll("twenty", "hai mươi")
      .replaceAll("thirty", "ba mươi")
      .replaceAll("fourty", "bốn mươi")
      .replaceAll("fifty", "năm mươi")
      .replaceAll("sixty", "sáu mươi")
      .replaceAll("seventy", "bảy mươi")
      .replaceAll("eighty", "tám mươi")
      .replaceAll("ninety", "chín mươi")
      .replaceAll("hundred", "trăm")
      .replaceAll("thousand", "nghìn")
      .replaceAll("million", "triệu")
      .replaceAll("billion", "tỷ");
  return res;
}

defaultDivider() {
  return const Divider(
    height: 10,
    thickness: 1,
    color: Colors.black,
  );
}

handleError(value) {
  Get.snackbar('Lỗi', '$value', colorText: Colors.red, isDismissible: true);
  Get.offAll(() => ContainerScreen());
}

loadingScreen() {
  return const Center(
    child: GFLoader(
      size: GFSize.LARGE,
      loaderstrokeWidth: 5.4,
    ),
  );
}
