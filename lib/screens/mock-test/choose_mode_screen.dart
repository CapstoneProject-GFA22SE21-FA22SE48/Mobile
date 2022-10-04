import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/screens/mock-test/question_screen.dart';
import 'package:vnrdn_tai/shared/constants.dart';

class ChooseModeScreen extends StatelessWidget {
  const ChooseModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
        textStyle: const TextStyle(fontSize: 20),
        backgroundColor: Colors.white,
        shadowColor: Colors.grey,
        alignment: Alignment.center,
        minimumSize: Size(200, 100),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)));
    GlobalController gc = Get.find<GlobalController>();
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
              child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Choose your mode',
                  style: Theme.of(context).textTheme.headline4?.copyWith(
                      color: Colors.green, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: kDefaultPaddingValue),
                ElevatedButton(
                  onPressed: () {
                    gc.updateTestMode(TEST_TYPE.STUDY);
                    Get.to(QuizScreen());
                  },
                  child: Text(
                    'Study',
                    style: Theme.of(context).textTheme.headline4?.copyWith(
                        color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                  style: style,
                ),
                SizedBox(height: kDefaultPaddingValue),
                ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      'Test',
                      style: Theme.of(context).textTheme.headline4?.copyWith(
                          color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                    style: style)
              ],
            ),
          ))
        ],
      ),
    );
  }
}
