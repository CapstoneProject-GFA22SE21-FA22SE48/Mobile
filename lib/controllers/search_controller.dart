import 'package:get/get.dart';

class SearchController extends GetxController {
  final vehicleCategory = "xe máy".obs;

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  @override
  dispose() {
    super.dispose();
  }

  updateVehicleCategory(value) {
    switch (value) {
      case 0:
        vehicleCategory('xe máy');
        break;
      case 1:
        vehicleCategory('xe ô tô');
        break;
      case 2:
        vehicleCategory('khác');
        break;
    }
  }
}
