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

    showQuestionImage(Question question) {
      if (question.imageUrl != null) {
        return SizedBox(
            height: 120,
            child: Image.network(question.imageUrl as String, fit: BoxFit.contain,));
      } else {
        return Container();
      }
    }

    return Container(
      padding: EdgeInsets.all(kDefaultPaddingValue),
      margin: EdgeInsets.symmetric(
          horizontal: kDefaultPaddingValue / 2, vertical: kDefaultPaddingValue / 2),
      decoration: BoxDecoration(
          color: Colors.black, borderRadius: BorderRadius.circular(25)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          showQuestionImage(question),
          Text(question.content,
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  ?.copyWith(color: Colors.white)),
          ...List.generate(
              question.answers.length,
              (index) => Option(
                  question: question,
                  text: question.answers[index].description,
                  index: index,
                  press: () {
                    _controller.checkAns(question, index);
                  }))
        ],
      ),
    );
  }
}
