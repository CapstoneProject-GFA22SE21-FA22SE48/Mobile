import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:localstore/localstore.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/controllers/question_controller.dart';
import 'package:vnrdn_tai/models/Question.dart';
import 'package:vnrdn_tai/screens/container_screen.dart';
import 'package:vnrdn_tai/screens/mock-test/choose_mode_screen.dart';
import 'package:vnrdn_tai/screens/mock-test/components/body.dart';
import 'package:vnrdn_tai/screens/mock-test/score_screen.dart';
import 'package:vnrdn_tai/services/QuestionService.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'package:vnrdn_tai/shared/snippets.dart';
import 'package:vnrdn_tai/utils/dialog_util.dart';

class QuizScreen extends StatefulWidget {
  QuizScreen(
      {super.key,
      this.questionCategoryName = "",
      required this.categoryId,
      this.questionCategoryId = "",
      this.separator = 0});
  String questionCategoryName;
  String categoryId;
  String questionCategoryId;

  int separator;
  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late Future<List<Question>> _questions;
  late bool isLoading = true;
  GlobalController gc = Get.find<GlobalController>();
  QuestionController qc = Get.put(QuestionController());

  @override
  void initState() {
    super.initState();
    // ignore: unrelated_type_equality_checks
    if (gc.test_mode == TEST_TYPE.STUDY) {
      _questions = QuestionSerivce().GetStudySetByCategoryAndSeparator(
          widget.categoryId, widget.questionCategoryId, widget.separator);
    } else {
      _questions =
          QuestionSerivce().GetRandomTestSetBytestCategoryId(widget.categoryId);
    }
  }

  Future<bool> confirmSubmission() async {
    if (gc.test_mode.value == TEST_TYPE.STUDY) {
      return true;
    }
    DialogUtil.showAwesomeDialog(
        context,
        DialogType.info,
        "Kết quả sẽ không được lưu",
        "Bạn có chắc là bạn muốn thoát không?",
        () => Get.to(ScoreScreen()),
        () {});
    // Get.dialog(
    //   AlertDialog(
    //     title: const Text('Nếu thoát, kết quả sẽ không được lưu'),
    //     content: const Text('Bạn có chắc là bạn muốn thoát không?'),
    //     actions: [
    //       TextButton(
    //         child: const Text("Xác nhận"),
    //         onPressed: () {
    //           qc.stopTimer();
    //           Get.to(() => const ContainerScreen());
    //         },
    //       ),
    //       TextButton(
    //         child: const Text("Không"),
    //         onPressed: () => Get.back(),
    //       ),
    //     ],
    //   ),
    // );
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => confirmSubmission(),
      child: Scaffold(
          backgroundColor: Color.fromARGB(255, 162, 211, 252),
          // extendBodyBehindAppBar:
          //     gc.test_mode == TEST_TYPE.STUDY ? false : true,
          // appBar: AppBar(
          //   backgroundColor: Colors.blueAccent,
          //   title: Text(
          //     widget.questionCategoryName.isNotEmpty
          //         ? widget.questionCategoryName
          //         : "Sát hạch GPLX",
          //   ),
          //   actions: [
          //     IconButton(
          //       onPressed: () {},
          //       icon: const Icon(Icons.replay_outlined),
          //     ),
          //   ],
          // ),
          body: FutureBuilder<List<Question>>(
              key: UniqueKey(),
              future: _questions,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return loadingScreen();
                } else {
                  if (snapshot.hasError) {
                    Future.delayed(
                        Duration.zero,
                        () => {
                              handleError(snapshot.error
                                  ?.toString()
                                  .replaceFirst('Exception:', ''))
                            });
                    throw Exception(snapshot.error);
                  } else {
                    qc.updateQuestions(snapshot.data!);
                    return Body(questions: snapshot.data!);
                  }
                }
              })),
    );
  }
}
