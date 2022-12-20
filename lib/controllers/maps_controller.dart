import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:vnrdn_tai/models/GPSSign.dart';

class MapsController extends GetxController {
  static MapsController instance = Get.find();
  Location location = Location();
  final listSigns = [].obs;
  final listNotiSigns = [].obs;
  final zoom = 18.0.obs;

  @override
  Future<void> onInit() async {
    WidgetsFlutterBinding.ensureInitialized();
    super.onInit();
  }

  @override
  dispose() {
    updateZoom(18.0);
    super.dispose();
  }

  updateGpsSigns(value) {
    listSigns(value);
  }

  updateListNotiSigns(value) {
    listNotiSigns(value);
  }

  resetListNotiSigns() {
    listNotiSigns([]);
  }

  updateZoom(value) {
    zoom(value);
  }
}
