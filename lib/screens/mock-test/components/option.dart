import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vnrdn_tai/controllers/question_controller.dart';
import 'package:vnrdn_tai/models/Question.dart';
import 'package:vnrdn_tai/shared/constants.dart';

class Option extends StatelessWidget {
  const Option({
    Key? key,
    required this.question,
    required this.text,
    required this.index,
    required this.press,
  }) : super(key: key);
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
                if (text == attemp['correctAns'].description) {
                  return Colors.green;
                } else if (text == attemp['selectedAns'].description &&
                    attemp['selectedAns'] != attemp['correctAns']) {
                  return Colors.red;
                }
              }
            } else {
              if (controller.isAnswered) {
                if (text == controller.correctAns.description) {
                  return Colors.green;
                } else if (text == controller.selectedAns.description &&
                    controller.selectedAns != controller.correctAns) {
                  return Colors.red;
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
                margin: EdgeInsets.only(top: kDefaultPaddingValue),
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
                                : getTheRightColour(),
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(color: getTheRightColour())),
                        child: getTheRightColour() == Colors.grey
                            ? null
                            : Icon(getTheRightIcon(), size: 16),
                      )
                    ]),
              ));
        });
  }
}
