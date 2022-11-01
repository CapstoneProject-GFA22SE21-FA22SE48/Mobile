import 'package:get/get.dart';
import 'package:vnrdn_tai/models/dtos/searchLawDTO.dart';

class CartController extends GetxController {
  final laws = <SearchLawDTO>[].obs;

  updateLaws(value) {
    laws(value);
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
