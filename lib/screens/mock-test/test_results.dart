import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/controllers/question_controller.dart';
import 'package:vnrdn_tai/models/Category.dart';
import 'package:vnrdn_tai/models/TestResult.dart';
import 'package:vnrdn_tai/screens/container_screen.dart';
import 'package:vnrdn_tai/screens/mock-test/quiz_screen.dart';
import 'package:vnrdn_tai/screens/mock-test/test_set_screen.dart';
import 'package:vnrdn_tai/services/TestCategoryService.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'package:vnrdn_tai/shared/snippets.dart';

class TestRestulScreen extends StatelessWidget {
  const TestRestulScreen({super.key, required this.testResults});
  final List<TestResult> testResults;

  @override
  Widget build(BuildContext context) {
    GlobalController gc = Get.find<GlobalController>();
    print(testResults[0].createdDate);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          elevation: 0,
          title: Text('Kết quả những lần thi trước'),
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
                    Padding(
                      padding: const EdgeInsets.all(0),
                      child: Container(
                        height: 70.h,
                        width: 80.w,
                        child: ListView.separated(
                            itemCount: testResults.length,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            separatorBuilder: (context, index) =>
                                SizedBox(height: kDefaultPaddingValue),
                            itemBuilder: (context, index) {
                              return ElevatedButton(
                                onPressed: () {},
                                child: Text(
                                  "Bài thi lúc ${DateFormat('yyyy-MM-dd hh:mm').format(DateTime.parse(testResults[index].createdDate))}",
                                  style: TextStyle(color: Colors.black),
                                ),
                                style: style,
                              );
                            }),
                      ),
                    )
                  ],
                ),
              ),
            ))
          ],
        ));
  }
}
