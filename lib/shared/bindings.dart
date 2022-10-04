import 'package:get/get.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';

class GlobalBinding extends Bindings{
  @override
 void dependencies() {
   Get.lazyPut(() => GlobalController());
 }
}