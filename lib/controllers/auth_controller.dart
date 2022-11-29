import 'package:flutter/cupertino.dart';

// import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:vnrdn_tai/models/UserInfo.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  late Rx<UserInfo?> _user;
  final token = ''.obs;
  final email = ''.obs;
  final status = 0.obs;
  final avatar = ''.obs;
  final displayName = ''.obs;
  final role = 2.obs;

  // FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Future<void> onInit() async {
    WidgetsFlutterBinding.ensureInitialized();
    super.onInit();
  }

  @override
  dispose() {
    instance.dispose();
    super.dispose();
  }

  updateToken(value) {
    token(value);
  }

  updateEmail(value) {
    email(value);
  }

  updateRole(value) {
    role(value);
  }

  updateStatus(value) {
    status(value);
  }

  updateAvatar(value) {
    avatar(value);
  }

  updateDisplayName(value) {
    displayName(value);
  }
}
