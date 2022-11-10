import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:getwidget/getwidget.dart';
import 'package:vnrdn_tai/screens/container_screen.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:vnrdn_tai/shared/constants.dart';

Future<File> compressFile(File file) async {
  final filePath = file.absolute.path;

  final lastIndex = filePath.lastIndexOf(new RegExp(r'.jp'));
  final splitted = filePath.substring(0, (lastIndex));
  final outPath = "${splitted}_out${filePath.substring(lastIndex)}";
  var result = (await FlutterImageCompress.compressAndGetFile(
    // minHeight: 640,
    // minWidth: 640,
    file.absolute.path,
    outPath,
    // quality: 50,
  ))!;


  print(file.lengthSync());
  print(result.lengthSync());

  return result;
}

upload(File imageFile, {bool cont = true}) async {
  if (!cont) return "[]";
  // open a bytestream
  var _imageFile = await compressFile(imageFile);
  // var _imageFile = imageFile;

  var stream = http.ByteStream(DelegatingStream.typed(_imageFile.openRead()));
  // get file length
  var length = await _imageFile.length();
  // string to uri
  var uri = Uri.parse(ai_url);

  // create multipart request
  var request = http.MultipartRequest("POST", uri);
  print(uri);
  // multipart that takes file
  var multipartFile = http.MultipartFile('file', stream, length,
      filename: basename(_imageFile.path));

  request.files.add(multipartFile);

  Map<String, String> headers = {
    "Content-Type": "multipart/form-data",
    "Accept-Encoding": "gzip, deflate, br",
    "Accept": "*/*",
    "Connection": "keep-alive"
  };
  // add file to multipart
  request.headers.addAll(headers);
  // send
  print('sent');
  try {
    var response = await request.send();
    return await response.stream.bytesToString();
  } on Exception catch (ex) {
    print(ex);
  }
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
      .replaceAll("eleven", "mười một")
      .replaceAll("twelve", "mười hai")
      .replaceAll("thirteen", "mười ba")
      .replaceAll("fourteen", "mười bốn")
      .replaceAll("fifteen", "mười lăm")
      .replaceAll("sixteen", "mười sáu")
      .replaceAll("seventeen", "mười bảy")
      .replaceAll("eighteen", "mười tám")
      .replaceAll("nineteen", "mười chín")
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
