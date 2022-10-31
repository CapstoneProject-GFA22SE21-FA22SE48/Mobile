import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:vnrdn_tai/controllers/question_controller.dart';
import 'package:sizer/sizer.dart';
import 'package:vnrdn_tai/screens/mock-test/score_screen.dart';
import 'package:vnrdn_tai/shared/constants.dart';

class ProgressBar extends StatelessWidget {
  const ProgressBar({
    Key? key,
  }) : super(key: key);

  Future<void> confirmSubmission() async {
    Get.dialog(
      AlertDialog(
        title: const Text('Nộp bài'),
        content: const Text('Bạn có chắc là bạn muốn nộp bài không?'),
        actions: [
          TextButton(
            child: const Text("Xác nhận"),
            onPressed: () => Get.to(ScoreScreen()),
          ),
          TextButton(
            child: const Text("Không"),
            onPressed: () => Get.back(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    QuestionController qc = Get.find<QuestionController>();
    return GetBuilder<QuestionController>(
        init: qc,
        builder: (controller) {
          controller.runTimer();
          return WillPopScope(
            onWillPop: () async {
              return await true;
            },
            child: Stack(children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Container(
                      width: 66.w,
                      height: 5.h,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 3),
                          borderRadius: BorderRadius.circular(50)),
                      child: Stack(
                        children: [
                          LayoutBuilder(
                            builder: (ctx, constraint) => Container(
                              width: constraint.maxWidth *
                                  controller.animation.value,
                              decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: [
                                      Color.fromARGB(255, 255, 61, 2),
                                      Color.fromARGB(255, 86, 176, 250),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(50)),
                            ),
                          ),
                          Positioned.fill(
                              child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Đã qua ${(controller.animation.value * quizTime).round() < 60 ? '${(controller.animation.value * quizTime).round()} giây' : '${(controller.animation.value * quizTime / 60).round()} phút'}',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      FaIcon(
                                        FontAwesomeIcons.clock,
                                        color: Colors.white,
                                      )
                                    ],
                                  )))
                        ],
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ButtonTheme(
                          child: ElevatedButton(
                              onPressed: () {
                                confirmSubmission();
                              },
                              style: ElevatedButton.styleFrom(
                                  textStyle: const TextStyle(
                                      fontSize: FONTSIZES.textPrimary),
                                  backgroundColor: Colors.blueAccent,
                                  shadowColor: Colors.grey,
                                  alignment: Alignment.center,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              child: Text("Nộp bài"))),
                    )
                  ],
                ),
              ),
            ]),
          );
        });
  }
}
