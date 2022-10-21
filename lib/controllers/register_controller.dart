import 'package:flutter/cupertino.dart';

// import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'package:vnrdn_tai/models/UserInfo.dart';

class RegisterController extends GetxController {
  static RegisterController instance = Get.find();
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

  registerQuery(value) {
    // query(value);
  }
}
