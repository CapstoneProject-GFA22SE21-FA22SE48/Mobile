import 'package:flutter/cupertino.dart';

// import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:vnrdn_tai/models/UserInfo.dart';

class LoginController extends GetxController {
  static LoginController instance = Get.find();
  late Rx<UserInfo?> _user;

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

  loginQuery(value) {
    // query(value);
  }
}
