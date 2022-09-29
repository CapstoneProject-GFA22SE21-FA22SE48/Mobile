import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:vnrdn_tai/shared/constants.dart';

class QuestionController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController _animationController;

  late Animation _animation;
  Animation get animation => _animation;

  @override
  void onInit() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: quizTime));
    super.onInit();
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
    _animation.addListener(() {
      update();
    });
    _animationController.forward();
  }
}
