import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
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
        return Container(
          height: 180,
          padding: EdgeInsets.symmetric(vertical: kDefaultPaddingValue / 2),
          child: CachedNetworkImage(
            imageUrl: question.imageUrl as String,
            imageBuilder: (context, imageProvider) => Container(
              width: 80.w,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            placeholder: (context, url) => Container(
              alignment: Alignment.center,
              child:
                  const CircularProgressIndicator(), // you can add pre loader iamge as well to show loading.
            ), //show progress  while loading image
            errorWidget: (context, url, error) =>
                Image.asset("assets/images/alt_image.png"),
          ),
          // Image.network(
          //   question.imageUrl as String,
          //   fit: BoxFit.contain,
          // )
        );
      } else {
        return Container();
      }
    }

    return Container(
      padding: const EdgeInsets.all(kDefaultPaddingValue),
      margin: const EdgeInsets.symmetric(
          horizontal: kDefaultPaddingValue, vertical: kDefaultPaddingValue * 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(197, 189, 189, 189),
            offset: Offset(0, 2),
            blurRadius: 2,
          )
        ],
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(question.content,
                textAlign: TextAlign.justify,
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.copyWith(color: Colors.black54)),
            showQuestionImage(question),
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
      ),
    );
  }
}
