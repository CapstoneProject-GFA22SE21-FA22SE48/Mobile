import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:vnrdn_tai/shared/constants.dart';

class TestSetScreen extends StatelessWidget {
  TestSetScreen({super.key, required this.categoryName});
  String categoryName;

  int getTotalQuestionNo(categoryName) {
    double res = 0;
    switch (categoryName) {
      case 'A1':
        res = 200 / 20;
        break;
      case 'A2':
        res = 200 / 20;
        break;
      case 'B1, B2':
        res = 600 / 30;
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
          title: Text('Chọn đề'),
        ),
        body: SafeArea(
          child: GridView.count(
            crossAxisCount: 4,
            children: List.generate(getTotalQuestionNo(categoryName), (index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    'Đề số ${index + 1}',
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                        color: Colors.green, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  style: style,
                ),
              );
            }),
          ),
        ));
  }
}
