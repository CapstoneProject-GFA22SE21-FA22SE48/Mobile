import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/screens/mock-test/category_screen.dart';
import 'package:vnrdn_tai/screens/mock-test/quiz_screen.dart';
import 'package:vnrdn_tai/screens/mock-test/test_set_screen.dart';
import 'package:vnrdn_tai/shared/constants.dart';

class ChooseModeScreen extends StatelessWidget {
  const ChooseModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalController gc = Get.find<GlobalController>();
    gc.updateTestMode(TEST_TYPE.STUDY);
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
              child: Center(
                child: Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Chọn chế độ',
                    style: Theme.of(context).textTheme.headline4?.copyWith(
                        color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: kDefaultPaddingValue),
                  ElevatedButton(
                    onPressed: () {
                      gc.updateTestMode(TEST_TYPE.STUDY);
                      Get.to(() => CategoryScreen());
                    },
                    child: Text(
                      'Học',
                      style: Theme.of(context).textTheme.headline4?.copyWith(
                          color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                    style: style,
                  ),
                  SizedBox(height: kDefaultPaddingValue),
                  ElevatedButton(
                      onPressed: () {
                        gc.updateTestMode(TEST_TYPE.TEST);
                        Get.to(() => CategoryScreen());
                      },
                      child: Text(
                        'Thi thử',
                        style: Theme.of(context).textTheme.headline4?.copyWith(
                            color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                      style: style)
                ],
            ),
          ),
              ))
        ],
      ),
    );
  }
}
