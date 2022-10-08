import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vnrdn_tai/screens/container_screen.dart';

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
