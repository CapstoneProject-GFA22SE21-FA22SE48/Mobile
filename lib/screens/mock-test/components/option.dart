import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/controllers/question_controller.dart';
import 'package:vnrdn_tai/models/Question.dart';
import 'package:vnrdn_tai/shared/constants.dart';

class Option extends StatelessWidget {
  Option({
    Key? key,
    required this.question,
    required this.text,
    required this.index,
    required this.press,
  }) : super(key: key);

  GlobalController gc = Get.find<GlobalController>();
  final Question question;
  final String text;
  final int index;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<QuestionController>(
        init: QuestionController(),
        builder: (controller) {
          Color getTheRightColour() {
            if (controller.answeredQuestions.contains(question)) {
              var attemp = controller.answeredAttempts.firstWhereOrNull(
                  (element) => element['question'] == question);
              if (attemp['isAnswered']) {
                if (gc.test_mode == TEST_TYPE.STUDY) {
                  if (text == attemp['correctAns'].description) {
                    return Colors.blueAccent;
                  } else if (text == attemp['selectedAns'].description &&
                      attemp['selectedAns'] != attemp['correctAns']) {
                    return Colors.red;
                  }
                } else {
                  if (text == attemp['selectedAns'].description) {
                    return Colors.blueAccent;
                  }
                }
              }
            }
            return Colors.black54;
          }

          IconData getTheRightIcon() {
            return getTheRightColour() == Colors.red
                ? Icons.close
                : getTheRightColour() == Colors.blueAccent
                    ? Icons.done
                    : Icons.circle_outlined;
          }

          return InkWell(
              onTap: press,
              child: Container(
                margin: EdgeInsets.only(top: kDefaultPaddingValue),
                padding: EdgeInsets.all(kDefaultPaddingValue),
                decoration: BoxDecoration(
                    border: Border.all(color: getTheRightColour(), width: 3),
                    borderRadius: BorderRadius.circular(kDefaultPaddingValue)),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Padding(
                    padding: const EdgeInsets.only(right: kDefaultPaddingValue),
                    child: Container(
                      width: 26,
                      decoration: BoxDecoration(
                          color: getTheRightColour() == Colors.black54
                              ? Colors.transparent
                              : gc.test_mode == TEST_TYPE.STUDY
                                  ? getTheRightColour()
                                  : Colors.blue,
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                              color: getTheRightColour() != Colors.black54
                                  ? getTheRightColour()
                                  : Colors.transparent)),
                      child: getTheRightColour() == Colors.black54
                          ? Icon(
                              Icons.circle_outlined,
                              size: 26,
                              color: getTheRightColour() == Colors.black54
                                  ? Colors.black54
                                  : Colors.white,
                            )
                          : gc.test_mode == TEST_TYPE.STUDY
                              ? Icon(
                                  getTheRightIcon(),
                                  size: 24,
                                  color: getTheRightColour() == Colors.black54
                                      ? Colors.black54
                                      : Colors.white,
                                )
                              : Icon(
                                  null,
                                  size: 24,
                                  color: getTheRightColour() == Colors.black54
                                      ? Colors.transparent
                                      : Colors.white,
                                ),
                    ),
                  ),
                  Flexible(
                    child: Text(
                      text,
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        color: getTheRightColour(),
                        fontSize: FONTSIZES.textPrimary,
                      ),
                    ),
                  ),
                ]),
              ));
        });
  }
}
