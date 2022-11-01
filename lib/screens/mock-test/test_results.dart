import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/controllers/question_controller.dart';
import 'package:vnrdn_tai/models/TestCategory.dart';
import 'package:vnrdn_tai/models/TestResult.dart';
import 'package:vnrdn_tai/screens/container_screen.dart';
import 'package:vnrdn_tai/screens/mock-test/quiz_screen.dart';
import 'package:vnrdn_tai/screens/mock-test/test_set_screen.dart';
import 'package:vnrdn_tai/screens/mock-test/test_result_detail.dart';
import 'package:vnrdn_tai/services/TestCategoryService.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'package:vnrdn_tai/shared/snippets.dart';

class TestRestulScreen extends StatelessWidget {
  const TestRestulScreen({super.key, required this.testResults});
  final List<TestResult> testResults;

  @override
  Widget build(BuildContext context) {
    GlobalController gc = Get.find<GlobalController>();
    return Scaffold(
      // backgroundColor: Color.fromARGB(255, 255, 242, 202),
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        // elevation: 4,
        title: const Text('Kết quả 10 lần thi gần nhất'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(kDefaultPaddingValue),
          child: Center(
            child: testResults.isNotEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(0),
                        // ignore: sized_box_for_whitespace
                        child: Container(
                          height: 86.h,
                          width: 100.w,
                          child: ListView.separated(
                              itemCount: testResults.length,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: kDefaultPaddingValue),
                              itemBuilder: (context, index) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Get.to(() => TestResultDetailScreen(
                                            title:
                                                'Bạn đã trả lời ${testResults[index].testResultDetails.length} trên 25 câu.',
                                            tr: testResults[index]));
                                      },
                                      style: kDefaultButtonStyle,
                                      child: Row(
                                        children: [
                                          Text(
                                            "Bài thi lúc ${DateFormat('hh:mm dd/MM/yyyy').format(DateTime.parse(testResults[index].createdDate))}",
                                            style: const TextStyle(
                                                color: Colors.black54,
                                                fontSize: 20),
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Icon(
                                                Icons
                                                    .arrow_circle_right_outlined,
                                                color: Colors.blueAccent,
                                                size: 30),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              }),
                        ),
                      )
                    ],
                  )
                //NEEDHEALING
                : const Text(
                    'Tiếc quá! \nBạn chưa thi nên không có kết quả',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: kDisabledTextColor,
                        fontSize: FONTSIZES.textLarge),
                  ),
          ),
        ),
      ),
    );
  }
}
