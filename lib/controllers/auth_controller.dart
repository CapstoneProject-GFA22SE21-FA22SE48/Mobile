import 'package:flutter/cupertino.dart';

// import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'package:vnrdn_tai/models/UserInfo.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  late Rx<UserInfo?> _user;
  final email = ''.obs;
  final status = 0.obs;

  // FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Future<void> onInit() async {
    WidgetsFlutterBinding.ensureInitialized();
    super.onInit();
  }

  @override
  dispose() {
    super.dispose();
  }

  updateEmail(value) {
    email(value);
  }

  updateStatus(value) {
    status(value);
  }
}
