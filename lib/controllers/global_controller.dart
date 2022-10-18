import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'dart:developer';

class GlobalController extends GetxController {
  final test_mode = TEST_TYPE.STUDY.obs;
  final is_error = false.obs;
  final tab = TABS.SEARCH.obs;

  final query = "".obs;

  late List<CameraDescription> _cameras;
  List<CameraDescription> get cameras => this._cameras;

  @override
  Future<void> onInit() async {
    WidgetsFlutterBinding.ensureInitialized();
    _cameras = await availableCameras();
    super.onInit();
  }

  @override
  dispose() {
    // ---
    log('data: $tab');
    // ---
    super.dispose();
  }

  updateQuery(value) {
    query(value);
  }

  updateTestMode(value) {
    test_mode(value);
  }

  updateError(value) {
    is_error(value);
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
      case 4:
        value = TABS.WELCOME;
        break;
      case 5:
        value = TABS.LOGIN;
        break;
      case 6:
        value = TABS.SIGNUP;
        break;
    }
    tab(value);
    log(tab.value.name);
    update();
  }
}
