import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/controllers/question_controller.dart';
import 'package:vnrdn_tai/models/Question.dart';
import 'package:vnrdn_tai/screens/mock-test/components/progress_bar.dart';
import 'package:vnrdn_tai/shared/constants.dart';

import 'question_card.dart';

class Body extends StatefulWidget {
  final List<Question> questions;
  const Body({Key? key, required this.questions}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int questionNo = 1;
  GlobalController gc = Get.find<GlobalController>();

  @override
  void initState() {
    super.initState();
    questionNo = 1;
  }

  void updatePageNo(value) {
    setState(() {
      questionNo = value + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    QuestionController qnController = Get.put(QuestionController());

    return WillPopScope(
      onWillPop: () async {
        if (gc.test_mode.value == TEST_TYPE.STUDY) {
          return await true;
        } else {
          return await false;
        }
      },
      child: Stack(
        children: [
          SafeArea(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: kDefaultPaddingValue),
                child: gc.test_mode == TEST_TYPE.TEST ? ProgressBar() : null,
              ),
              SizedBox(height: kDefaultPaddingValue / 2),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: kDefaultPaddingValue),
                child: Text.rich(
                  TextSpan(
                    text:
                        "Câu $questionNo trên tổng số ${widget.questions.length} câu",
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        ?.copyWith(color: Colors.red),
                  ),
                ),
              ),
              Divider(thickness: 1.5),
              SizedBox(height: 10),
              Expanded(
                  child: PageView.builder(
                      itemCount: widget.questions.length,
                      onPageChanged: (value) => updatePageNo(value),
                      itemBuilder: ((context, index) => QuestionCard(
                            question: widget.questions[index],
                          ))))
            ],
          ))
        ],
      ),
    );
  }
}
