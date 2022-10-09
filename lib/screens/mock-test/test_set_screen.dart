import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:vnrdn_tai/screens/mock-test/quiz_screen.dart';
import 'package:vnrdn_tai/shared/constants.dart';

class TestSetScreen extends StatelessWidget {
  TestSetScreen(
      {super.key, required this.categoryName, required this.categoryId});
  String categoryName;
  String categoryId;

  int getTotalQuestionNo(categoryName) {
    double res = 0;
    switch (categoryName) {
      case 'A1':
        res = 200 / 25;
        break;
      case 'A2':
        res = 200 / 25;
        break;
      case 'B1, B2':
        res = 600 / 25;
        break;
    }
    return res.round();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          elevation: 0,
          title: Text('Chọn đề (mỗi đề 25 câu)'),
        ),
        body: SafeArea(
          child: GridView.count(
            crossAxisCount: 4,
            children: List.generate(getTotalQuestionNo(categoryName), (index) {
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(() => QuizScreen(categoryId: categoryId, separator: index));
                  },
                  
                  child: Text(
                    "Đề số ${index + 1}",
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                        color: Colors.green, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  style: buttonStyle,
                ),
              );
            }),
          ),
        ));
  }
}
