import 'package:get/get.dart';
import 'package:vnrdn_tai/shared/constants.dart';

class GlobalController extends GetxController {
  final test_mode = TEST_TYPE.STUDY.obs;

  updateTestMode(value) {
    test_mode(value);
  }
}
