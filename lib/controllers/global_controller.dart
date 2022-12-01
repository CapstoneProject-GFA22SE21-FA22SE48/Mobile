import 'dart:ffi';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'dart:developer';

import 'package:vnrdn_tai/utils/io_utils.dart';

class GlobalController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final test_mode = TEST_TYPE.STUDY.obs;
  final modelLoad = false.obs;
  final is_error = false.obs;
  final tab = TABS.SEARCH.obs;
  final sideBar = 0.obs;
  final username = ''.obs;
  final userId = ''.obs;

  final query = "".obs;

  final pushNotiMode = true.obs;

  final oldObSecure = true.obs;
  final newObSecure = true.obs;
  final confirmObSecure = true.obs;

  final isLoading = false.obs;

  late List<CameraDescription> _cameras;
  List<CameraDescription> get cameras => this._cameras;

  @override
  Future<void> onInit() async {
    WidgetsFlutterBinding.ensureInitialized();
    _cameras = await availableCameras();

    await Permission.notification.request().isGranted.then((value) {
      updatePushNotiMode(value);
    });

    // init user

    //
    super.onInit();
  }

  @override
  dispose() {
    // ---

    // ---
    super.dispose();
  }

  updateModelLoad(value) {
    modelLoad(value);
  }

  updateTestMode(value) {
    test_mode(value);
  }

  updateError(value) {
    is_error(value);
  }

  updateUsername(value) {
    username(value);
  }

  updateUserId(value) {
    userId(value);
  }

  updateSideBar(value) {
    sideBar(value);
  }

  updatePushNotiMode(value) async {
    pushNotiMode(value);
    // await Permission.notification.
  }

  updateOldObSecure(value) {
    oldObSecure(value);
  }

  updateNewObSecure(value) {
    newObSecure(value);
  }

  updateConfirmObSecure(value) {
    confirmObSecure(value);
  }

  updateTab(value) {
    switch (value) {
      case 0:
        value = TABS.SEARCH;
        break;
      case 1:
        value = TABS.MOCK_TEST;
        break;
      case 2:
        value = TABS.ANALYSIS;
        break;
      case 3:
        value = TABS.MINIMAP;
        break;
      // case 4:
      //   value = TABS.WELCOME;
      //   break;
      // case 5:
      //   value = TABS.LOGIN;
      //   break;
      // case 6:
      //   value = TABS.SIGNUP;
      //   break;
    }
    tab(value);

    update();
  }

  updateIsLoading(value) {
    isLoading(value);
  }
}
