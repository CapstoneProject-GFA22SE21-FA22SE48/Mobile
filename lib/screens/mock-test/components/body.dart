import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/controllers/question_controller.dart';
import 'package:vnrdn_tai/models/Question.dart';
import 'package:vnrdn_tai/screens/container_screen.dart';
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
      child: Stack(
        children: [
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: kDefaultPaddingValue),
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
                          IconButton(
                            onPressed: () {
                              qnController.stopTimer();
                              Get.offAll(() => ContainerScreen());
                            },
                            icon: const FaIcon(
                              FontAwesomeIcons.close,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 18.w,
                          ),
                          Text(
                            "Câu số $questionNo/${widget.questions.length}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: FONTSIZES.textHuge,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: PageView.builder(
                    itemCount: widget.questions.length,
                    controller: pageController,
                    onPageChanged: (value) => updatePageNo(value),
                    itemBuilder: ((context, index) => QuestionCard(
                          question: widget.questions[index],
                        )),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 8.h,
                      width: 40.w,
                      margin:
                          const EdgeInsets.only(bottom: kDefaultPaddingValue),
                      alignment: Alignment.topCenter,
                      padding: const EdgeInsets.all(0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
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
                          // IconButton(
                          //   onPressed: () {},
                          //   icon: const FaIcon(
                          //     FontAwesomeIcons.anglesLeft,
                          //     color: Colors.white,
                          //     size: FONTSIZES.textHuge,
                          //   ),
                          // ),
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
                          Center(
                            child: Stack(children: [
                              Image.asset("assets/images/logo.png",
                                  height: 40.0),
                            ]),
                          ),
                          const SizedBox(width: kDefaultPaddingValue),
                          IconButton(
                            onPressed: () {
                              print("n");
                              pageController.jumpTo(100.w * questionNo);
                            },
                            icon: const FaIcon(
                              FontAwesomeIcons.angleRight,
                              color: Colors.blueAccent,
                              size: FONTSIZES.textHuge,
                            ),
                          ),
                          // IconButton(
                          //   onPressed: () {},
                          //   icon: const FaIcon(
                          //     FontAwesomeIcons.anglesRight,
                          //     color: Colors.white,
                          //     size: FONTSIZES.textHuge,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
