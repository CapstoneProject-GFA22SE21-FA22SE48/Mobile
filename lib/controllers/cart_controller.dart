import 'package:get/get.dart';
import 'package:vnrdn_tai/models/dtos/searchLawDTO.dart';

class CartController extends GetxController {
  final laws = <SearchLawDTO>[].obs;
  final fineToWord = "".obs;
  final fine = 0.0.obs;

  updateLaws(value) {
    laws(value);
  }

  updateFine(value) {
    fine(value);
  }

  updateFineToWord(value) {
    fineToWord(value);
  }

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  @override
  dispose() {
    super.dispose();
  }
}
