import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vnrdn_tai/shared/constants.dart';

class TemplatedButtons {
  final ButtonStyle confirmStyle = ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      backgroundColor: kPrimaryButtonColor,
      shadowColor: Colors.grey,
      minimumSize: const Size(80, 40));

  final ButtonStyle cancelStyle = ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      backgroundColor: kDangerButtonColor,
      shadowColor: Colors.grey,
      minimumSize: const Size(80, 40));

  final ButtonStyle disabledStyle = ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      backgroundColor: Colors.grey.shade300,
      shadowColor: Colors.grey,
      minimumSize: const Size(80, 40));

  static TextButton ok(BuildContext context) {
    return TextButton(
      style: TemplatedButtons().confirmStyle,
      onPressed: () {
        Navigator.pop(context, 'OK');
      },
      child: const Text(
        "OK",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  static TextButton okWithscreen(BuildContext context, Widget screen) {
    return TextButton(
      style: TemplatedButtons().confirmStyle,
      onPressed: () {
        Navigator.pop(context, 'OK');
        Get.to(screen);
      },
      child: const Text(
        "OK",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  static TextButton cancel(BuildContext context) {
    return TextButton(
      style: TemplatedButtons().cancelStyle,
      onPressed: () {
        Navigator.pop(context, 'HUỶ BỎ');
      },
      child: const Text(
        "HUỶ BỎ",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  static TextButton deny(BuildContext context) {
    return TextButton(
      style: TemplatedButtons().cancelStyle,
      onPressed: () {
        Navigator.pop(context, 'DENY');
      },
      child: const Text(
        "DENY",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  static TextButton yes(BuildContext context, Widget screen) {
    return TextButton(
      style: TemplatedButtons().confirmStyle,
      onPressed: () {
        Navigator.pop(context, 'CÓ');
        Get.to(screen);
      },
      child: const Text(
        "CÓ",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  static TextButton no(BuildContext context) {
    return TextButton(
      style: TemplatedButtons().disabledStyle,
      onPressed: () {
        Navigator.pop(context, 'KHÔNG');
      },
      child: const Text(
        "KHÔNG",
        style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
      ),
    );
  }
}
