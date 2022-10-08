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
                    return Colors.green;
                  } else if (text == attemp['selectedAns'].description &&
                      attemp['selectedAns'] != attemp['correctAns']) {
                    return Colors.red;
                  }
                } else {
                  if (text == attemp['selectedAns'].description) {
                    return Colors.blue;
                  }
                }
              }
            }
            return Colors.grey;
          }

          IconData getTheRightIcon() {
            return getTheRightColour() == Colors.red ? Icons.close : Icons.done;
          }

          return InkWell(
              onTap: press,
              child: Container(
                margin: EdgeInsets.only(top: kDefaultPaddingValue / 2),
                padding: EdgeInsets.all(kDefaultPaddingValue),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(25)),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          "${index + 1} $text",
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ),
                      Container(
                        width: 20,
                        decoration: BoxDecoration(
                            color: getTheRightColour() == Colors.grey
                                ? Colors.transparent
                                : gc.test_mode == TEST_TYPE.STUDY
                                    ? getTheRightColour()
                                    : Colors.blue,
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(color: getTheRightColour())),
                        child: getTheRightColour() == Colors.grey
                            ? null
                            : gc.test_mode == TEST_TYPE.STUDY
                                ? Icon(getTheRightIcon(), size: 16)
                                : Icon(Icons.done, size: 16),
                      )
                    ]),
              ));
        });
  }
}
