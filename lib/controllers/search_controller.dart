import 'package:get/get.dart';

class SearchController extends GetxController {
  final vehicleCategory = "xe máy".obs;
  final vehicleCategoryNo = 0.obs;

  final signCategory = "Biển báo cấm".obs;
  final signCategoryNo = 0.obs;

  final query = "".obs;
  final isFromAnalysis = false.obs;


  @override
  Future<void> onInit() async {
    super.onInit();
  }

  @override
  dispose() {
    super.dispose();
  }

  updateIsFromAnalysis(value) {
    isFromAnalysis(value);
  }

  updateQuery(value) {
    query(value);
  }

  updateSignCategoryNo(value) {
    signCategoryNo(value);
  }

  updateSignCategory(value) {
    signCategory(value);
  }

  updateVehicleCategoryNo(value) {
    vehicleCategoryNo(value);
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
