import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vnrdn_tai/screens/container_screen.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:vnrdn_tai/shared/constants.dart';

upload(File imageFile) async {
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
  print(response.statusCode);
  
  return await response.stream.bytesToString();;
}

handleError(value) {
  Get.snackbar('Lỗi', '$value', colorText: Colors.red, isDismissible: true);
  Get.offAll(() => ContainerScreen());
}

loadingScreen() {
  return Padding(
    padding: const EdgeInsets.only(top: 200.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: 200.0,
          child: Stack(
            children: <Widget>[
              Center(
                child: Container(
                  width: 200,
                  height: 200,
                  child: new CircularProgressIndicator(
                    strokeWidth: 15,
                  ),
                ),
              ),
              Center(child: Text("Đang tải dữ liệu...")),
            ],
          ),
        ),
      ],
    ),
  );
}
