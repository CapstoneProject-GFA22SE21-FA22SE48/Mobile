import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/screens/mock-test/quiz_screen.dart';
import 'package:vnrdn_tai/screens/mock-test/test_set_screen.dart';
import 'package:vnrdn_tai/shared/constants.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  getScreen(GlobalController gc, String categoryName) {
    if (gc.test_mode.value == TEST_TYPE.STUDY) {
      Get.to(TestSetScreen(categoryName: categoryName));
    } else {
      Get.to(QuizScreen(categoryName: categoryName));
    }
  }

  @override
  Widget build(BuildContext context) {
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
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Chọn loại bằng',
                    style: Theme.of(context).textTheme.headline4?.copyWith(
                        color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: kDefaultPaddingValue),
                  ElevatedButton(
                    onPressed: () {
                      getScreen(gc, 'A1');
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
                        getScreen(gc, 'A2');
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
                        getScreen(gc, 'B1, B2');
                      },
                      child: Text(
                        'B1, B2',
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
