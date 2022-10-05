import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/screens/mock-test/question_screen.dart';
import 'package:vnrdn_tai/shared/constants.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

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
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        title: Text(
            '${gc.test_mode == TEST_TYPE.STUDY ? "Chế độ Học " : "Chế độ thi"}'),
      ),
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
                    gc.updateTestMode(TEST_TYPE.TEST);
                    Get.to(QuizScreen(categoryName: "A1"));
                  },
                  child: Text(
                    'A1',
                    style: Theme.of(context).textTheme.headline4?.copyWith(
                        color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                  style: style,
                ),
                SizedBox(height: kDefaultPaddingValue),
                ElevatedButton(
                    onPressed: () {
                      gc.updateTestMode(TEST_TYPE.TEST);
                      Get.to(QuizScreen(categoryName: "A2"));
                    },
                    child: Text(
                      'A2',
                      style: Theme.of(context).textTheme.headline4?.copyWith(
                          color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                    style: style),
                SizedBox(height: kDefaultPaddingValue),
                ElevatedButton(
                    onPressed: () {
                      gc.updateTestMode(TEST_TYPE.TEST);
                      Get.to(QuizScreen(categoryName: "B1, B2"));
                    },
                    child: Text(
                      'B1, B2',
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
