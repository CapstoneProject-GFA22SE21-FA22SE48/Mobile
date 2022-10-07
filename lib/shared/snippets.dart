import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
