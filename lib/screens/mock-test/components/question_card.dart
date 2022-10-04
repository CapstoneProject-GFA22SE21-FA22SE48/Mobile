import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vnrdn_tai/controllers/question_controller.dart';
import 'package:vnrdn_tai/models/Question.dart';
import 'package:vnrdn_tai/shared/constants.dart';

import 'option.dart';

class QuestionCard extends StatelessWidget {
  const QuestionCard({
    Key? key,
    required this.question,
  }) : super(key: key);

  final Question question;


  @override
  Widget build(BuildContext context) {
  QuestionController _controller = Get.put(QuestionController());

    return Container(
      padding: EdgeInsets.all(kDefaultPaddingValue),
      margin: EdgeInsets.symmetric(
          horizontal: kDefaultPaddingValue, vertical: kDefaultPaddingValue / 2),
      decoration: BoxDecoration(
          color: Colors.black, borderRadius: BorderRadius.circular(25)),
      child: Column(
        children: [
          Text(question.content,
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  ?.copyWith(color: Colors.white)),
          ...List.generate(
              question.answers.length,
              (index) =>
                  Option(text: question.answers[index].description, index: index, 
                  press: () {
                    _controller.checkAns(question, index);
                  }))
        ],
      ),
    );
  }
}
