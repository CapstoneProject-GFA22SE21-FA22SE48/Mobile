import 'package:get/get.dart';
import 'package:vnrdn_tai/shared/constants.dart';

class GlobalController extends GetxController {
  final test_mode = TEST_TYPE.STUDY.obs;
  final is_error = false.obs;
  final tab = TABS.SEARCH.obs;

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
    }
    tab(value);
    update();
  }
}
