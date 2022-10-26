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
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        title: const Text('Lịch sử thi'),
      ),
      body: Stack(
        children: [
          const Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              'Kết quả 10 lần thi gần nhất',
              style: TextStyle(
                  fontSize: FONTSIZES.textLarger, fontWeight: FontWeight.bold),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: Center(
                child: testResults.length > 0
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(0),
                            // ignore: sized_box_for_whitespace
                            child: Container(
                              height: 70.h,
                              width: 90.w,
                              child: ListView.separated(
                                  itemCount: testResults.length,
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(
                                          height: kDefaultPaddingValue),
                                  itemBuilder: (context, index) {
                                    return Row(
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
                                                "Bài thi lúc ${DateFormat('d/m/yyyy hh:mm').format(DateTime.parse(testResults[index].createdDate))}",
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20),
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Icon(
                                                    Icons
                                                        .arrow_circle_right_outlined,
                                                    color: Colors.green,
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
                    : Text(
                        'Tiếc quá! \nBạn chưa có lấy nổi một lần thi nên không có gì để hiện cả',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: kDisabledTextColor,
                            fontSize: FONTSIZES.textLarge),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
