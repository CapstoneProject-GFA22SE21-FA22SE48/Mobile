import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/controllers/question_controller.dart';
import 'package:vnrdn_tai/models/Question.dart';
import 'package:vnrdn_tai/screens/container_screen.dart';
import 'package:vnrdn_tai/screens/mock-test/components/progress_bar.dart';
import 'package:vnrdn_tai/screens/mock-test/test_set_screen.dart';
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
  final pageController = PageController();

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
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: kDefaultPaddingValue),
              child: gc.test_mode == TEST_TYPE.TEST ? ProgressBar() : null,
            ),
            const SizedBox(height: kDefaultPaddingValue),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: kDefaultPaddingValue,
                  ),
                  child: Row(
                    children: [
                      gc.test_mode == TEST_TYPE.STUDY
                          ? IconButton(
                              onPressed: () {
                                // qnController.stopTimer();
                                // Get.offAll(() => ContainerScreen());
                                if (qnController
                                    .testCategoryId.value.isNotEmpty) {
                                  Get.to(() => TestSetScreen(
                                        categoryName:
                                            qnController.testCategoryName.value,
                                        categoryId:
                                            qnController.testCategoryId.value,
                                      ));
                                }
                              },
                              icon: const FaIcon(
                                FontAwesomeIcons.close,
                                color: Colors.white,
                              ),
                            )
                          : SizedBox(
                              width: 12.0.w,
                            ),
                      SizedBox(
                        width: 12.w,
                      ),
                      Text(
                        "Câu số $questionNo/${widget.questions.length}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: FONTSIZES.textHuge,
                        ),
                      ),
                      SizedBox(
                        width: 16.w,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: PageView.builder(
                pageSnapping: true,
                physics: const BouncingScrollPhysics(),
                itemCount: widget.questions.length,
                controller: pageController,
                onPageChanged: (value) => updatePageNo(value),
                itemBuilder: ((context, index) => QuestionCard(
                      question: widget.questions[index],
                    )),
              ),
            ),
            Container(
              alignment: Alignment.topCenter,
              margin: const EdgeInsets.only(
                bottom: kDefaultPaddingValue,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 6.4.h,
                    width: 42.w,
                    padding: const EdgeInsets.all(0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black12,
                              spreadRadius: 0,
                              blurRadius: 10)
                        ],
                        borderRadius:
                            BorderRadius.circular(kDefaultPaddingValue * 4)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            if (questionNo > 1) {
                              updatePageNo(questionNo - 2);
                            }
                            // pageController.page.toInt();
                            pageController.jumpTo(100.w * (questionNo - 1));
                          },
                          icon: const FaIcon(
                            FontAwesomeIcons.angleLeft,
                            color: Colors.blueAccent,
                            size: FONTSIZES.textHuge,
                          ),
                        ),
                        const SizedBox(width: kDefaultPaddingValue),
                        const Spacer(),
                        const SizedBox(width: kDefaultPaddingValue),
                        IconButton(
                          onPressed: () {
                            pageController.jumpTo(100.w * questionNo);
                          },
                          icon: const FaIcon(
                            FontAwesomeIcons.angleRight,
                            color: Colors.blueAccent,
                            size: FONTSIZES.textHuge,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 10.h,
                    height: 10.h,
                    padding: EdgeInsets.all(kDefaultPaddingValue),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.0),
                      color: Colors.white,
                    ),
                    child: Stack(children: [
                      Image.asset(
                        "assets/images/logo.png",
                        height: 8.h,
                      ),
                    ]),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
