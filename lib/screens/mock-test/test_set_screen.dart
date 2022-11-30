import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:localstore/localstore.dart';
import 'package:sizer/sizer.dart';
import 'package:vnrdn_tai/controllers/question_controller.dart';
import 'package:vnrdn_tai/models/Question.dart';
import 'package:vnrdn_tai/models/QuestionCategory.dart';
import 'package:vnrdn_tai/screens/container_screen.dart';
import 'package:vnrdn_tai/screens/mock-test/quiz_screen.dart';
import 'package:vnrdn_tai/services/QuestionCategoryService.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'package:vnrdn_tai/shared/snippets.dart';
import 'package:vnrdn_tai/utils/dialog_util.dart';

class TestSetScreen extends StatefulWidget {
  TestSetScreen(
      {super.key, required this.categoryName, required this.categoryId});
  String categoryName;
  String categoryId;

  @override
  State<TestSetScreen> createState() => _TestSetScreenState();
}

class _TestSetScreenState extends State<TestSetScreen> {
  late Future<List<QuestionCategory>> _questionCategory;

  List<List<Color>> gradientList = <List<Color>>[
    [
      // 0
      const Color(0xFF8855CC),
      const Color(0xFFBAA7FF),
    ],
    [
      // 1
      const Color(0xFF1034D4),
      const Color(0xFF91D2F0),
    ],
    [
      // 2
      const Color(0xFF00B953),
      const Color(0xFF91F096),
    ],
    [
      // 3
      const Color(0xFFFF3B3B),
      const Color(0xFFFF9F9F),
    ],
    [
      // 4
      const Color.fromARGB(255, 211, 164, 35),
      const Color(0xFFF091DB),
    ],
    [
      // 5
      const Color(0xFF1086D4),
      const Color(0xFFBFF091),
    ],
    [
      // 6
      const Color.fromARGB(255, 16, 52, 212),
      const Color.fromARGB(255, 145, 210, 240),
    ],
    [
      // 7
      const Color.fromARGB(255, 16, 52, 212),
      const Color.fromARGB(255, 145, 210, 240),
    ],
    [
      // 8
      const Color.fromARGB(255, 16, 52, 212),
      const Color.fromARGB(255, 145, 210, 240),
    ],
    [
      // 9
      const Color.fromARGB(255, 16, 52, 212),
      const Color.fromARGB(255, 145, 210, 240),
    ],
  ];

  @override
  void initState() {
    super.initState();
    _questionCategory = QuestionCategoryService()
        .GetQuestionCategoriesByTestCategory(widget.categoryId);
  }

  Future<int> getCompletedQuestionsStudyMode(String questionCategoryId) async {
    QuestionController qc = Get.put(QuestionController());
    var res = 0;
    final db = Localstore.instance;
    final id = db.collection('_answeredAttempt').doc('_answeredAttempt').id;
    final data = await db.collection('_answeredAttempt').doc(id).get();
    if (data != null) {
      List<dynamic> _answeredAttempt =
          jsonDecode(data?.entries.toList()[data.entries.length - 1].value);
      _answeredAttempt.forEach((element) {
        if (element['question']['questionCategoryId'] == questionCategoryId) {
          res++;
        }
      });
    }
    await getPastStudyResult(qc);
    return res;
  }

  Future getPastStudyResult(QuestionController qc) async {
    final db = Localstore.instance;
    final id = db.collection('_answeredAttempt').doc('_answeredAttempt').id;
    final id2 =
        db.collection('_answeredQuestions').doc('_answeredQuestions').id;
    final data = await db.collection('_answeredAttempt').doc(id).get();
    final data2 = await db.collection('_answeredQuestions').doc(id2).get();
    if (data != null) {
      List<dynamic> _answeredAttempt =
          jsonDecode(data?.entries.toList()[data.entries.length - 1].value);
      qc.updateAnsweredAttempts(_answeredAttempt);
    }
    if (data2 != null) {
      List<Question> _answeredQuestions =
          (jsonDecode(data2?.entries.toList()[data2.entries.length - 1].value)
                  as List)
              .map((e) => Question.fromJson(e))
              .toList();
      qc.updateAnsweredQuestion(_answeredQuestions);
    }
  }

  Future deletePastStudyResult(String questionCategoryId) async {
    final db = Localstore.instance;
    final id = db.collection('_answeredAttempt').doc('_answeredAttempt').id;
    final id2 =
        db.collection('_answeredQuestions').doc('_answeredQuestions').id;
    final data = await db.collection('_answeredAttempt').doc(id).get();
    final data2 = await db.collection('_answeredQuestions').doc(id2).get();
    if (data != null) {
      List<dynamic> _answeredAttempt =
          jsonDecode(data?.entries.toList()[data.entries.length - 1].value);
      print(_answeredAttempt.length);
      _answeredAttempt = _answeredAttempt
          .where((element) =>
              element['question']['questionCategoryId'] != questionCategoryId)
          .toList();
      print(_answeredAttempt.length);
      await db
          .collection('_answeredAttempt')
          .doc(id)
          .set({'_answeredAttempt': jsonEncode(_answeredAttempt)});
    }
    if (data2 != null) {
      List<Question> _answeredQuestions =
          (jsonDecode(data2?.entries.toList()[data2.entries.length - 1].value)
                  as List)
              .map((e) => Question.fromJson(e))
              .toList();
      _answeredQuestions = _answeredQuestions
          .where((element) => element.questionCategoryId != questionCategoryId)
          .toList();
      await db
          .collection('_answeredQuestions')
          .doc(id2)
          .set({'_answeredQuestions': jsonEncode(_answeredQuestions)});
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Câu hỏi lý thuyết (Hạng ${widget.categoryName})'),
        leading: IconButton(
          onPressed: (() {
            Get.offAll(() => const ContainerScreen());
          }),
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.blueAccent,
          ),
        ),
      ),
      body: FutureBuilder<List<QuestionCategory>>(
        key: UniqueKey(),
        future: _questionCategory,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.data == null) {
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
              return ListView.separated(
                itemCount: snapshot.data!.length,
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                separatorBuilder: (context, index) => const SizedBox(height: 0),
                itemBuilder: (context, index) {
                  if (snapshot.data![index].noOfQuestion == 0) {
                    return Container();
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: kDefaultPaddingValue,
                      vertical: kDefaultPaddingValue,
                    ),
                    child: GestureDetector(
                      // onTap: () {
                      //   Get.to(() => QuizScreen(
                      //         questionCategoryName: snapshot.data![index].name,
                      //         categoryId: widget.categoryId,
                      //         questionCategoryId: snapshot.data![index].id,
                      //       ));
                      // },
                      child: Container(
                        height: 30.h,
                        padding: const EdgeInsets.symmetric(
                          horizontal: kDefaultPaddingValue,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(
                            kDefaultPaddingValue,
                          )),
                          boxShadow: const [
                            BoxShadow(
                                color: Color.fromARGB(80, 82, 82, 82),
                                spreadRadius: 2,
                                blurRadius: 8,
                                offset: Offset(0, 8))
                          ],
                          gradient: LinearGradient(
                              colors: gradientList[index],
                              begin: const FractionalOffset(0.0, 0.0),
                              end: const FractionalOffset(1.0, 0.0),
                              stops: [0.0, 1.0],
                              tileMode: TileMode.clamp),
                        ),
                        child: Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  snapshot.data![index].name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: FONTSIZES.textLarger,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: kDefaultPaddingValue),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.all_inbox_rounded,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(
                                        width: kDefaultPaddingValue / 4,
                                      ),
                                      Text(
                                        "Tổng ${snapshot.data![index].noOfQuestion} câu",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6
                                            ?.copyWith(
                                                color: Colors.white,
                                                fontSize:
                                                    FONTSIZES.textPrimary),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(
                                        top: kDefaultPaddingValue / 4),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.file_download_done_rounded,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(
                                          width: kDefaultPaddingValue / 4,
                                        ),
                                        FutureBuilder<int>(
                                            key: UniqueKey(),
                                            future:
                                                getCompletedQuestionsStudyMode(
                                                    snapshot.data![index].id),
                                            builder: (context, snapshot2) {
                                              return Text(
                                                "Hoàn tất ${snapshot2.data} câu",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6
                                                    ?.copyWith(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: FONTSIZES
                                                            .textPrimary),
                                              );
                                            })
                                      ],
                                    )),
                                // Padding(
                                //   padding: const EdgeInsets.only(
                                //       top: kDefaultPaddingValue),
                                //   child: Container(
                                //     width: 60.w,
                                //     padding: const EdgeInsets.symmetric(
                                //       vertical: kDefaultPaddingValue / 4,
                                //       horizontal: kDefaultPaddingValue / 4,
                                //     ),
                                //     decoration: const BoxDecoration(
                                //       color: Colors.white,
                                //       borderRadius: BorderRadius.all(
                                //         Radius.circular(
                                //           kDefaultPaddingValue,
                                //         ),
                                //       ),
                                //     ),
                                //     alignment: Alignment.center,
                                //     child: GFProgressBar(
                                //       percentage: 0,
                                //       lineHeight: 16,
                                //       alignment: MainAxisAlignment.spaceBetween,
                                //       backgroundColor: Colors.grey.shade400,
                                //       progressBarColor: Color(0xFF7DFF71),
                                //       child: const Text(
                                //         "${0}%",
                                //         textAlign: TextAlign.end,
                                //         style: TextStyle(
                                //             fontSize: FONTSIZES.textMedium,
                                //             color: Colors.white),
                                //       ),
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                            const Spacer(),
                            // const SizedBox(
                            //   width: kDefaultPaddingValue * 2,
                            // ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Container(
                                //   width: 3.w,
                                //   height: 3.w,
                                //   margin: EdgeInsets.only(
                                //       top: kDefaultPaddingValue * 2),
                                //   child: GFProgressBar(
                                //     percentage:
                                //         snapshot.data![index].noOfQuestion > 10
                                //             ? 10 /
                                //                 snapshot
                                //                     .data![index].noOfQuestion
                                //             : 1.0,
                                //     radius: 60,
                                //     circleWidth: 8,
                                //     type: GFProgressType.circular,
                                //     animation: true,
                                //     backgroundColor: const Color(0xFFDFDFDF),
                                //     progressBarColor: PROGRESS_COLOR.none,
                                //   ),
                                // ),
                                Image.asset(
                                  "assets/images/quiz/test.png",
                                  scale: 7,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: kDefaultPaddingValue),
                                  child: GestureDetector(
                                    onTap: () {
                                      Get.to(() => QuizScreen(
                                            questionCategoryName:
                                                snapshot.data![index].name,
                                            categoryId: widget.categoryId,
                                            questionCategoryId:
                                                snapshot.data![index].id,
                                          ));
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: kDefaultPaddingValue / 2,
                                        horizontal: kDefaultPaddingValue,
                                      ),
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(
                                            kDefaultPaddingValue,
                                          ),
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                      child: const Text(
                                        "Bắt đầu",
                                        style: TextStyle(
                                          color: Colors.redAccent,
                                          fontWeight: FontWeight.bold,
                                          fontSize: FONTSIZES.textPrimary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: kDefaultPaddingValue),
                                  child: GestureDetector(
                                    onTap: () async {
                                      DialogUtil.showAwesomeDialog(
                                          context,
                                          DialogType.warning,
                                          "Cảnh báo",
                                          "Bạn cần có chắc là muốn xóa dữ liệu không?",
                                          () async {
                                        await deletePastStudyResult(
                                            snapshot.data![index].id);
                                      }, () {});
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: kDefaultPaddingValue / 2,
                                        horizontal: kDefaultPaddingValue,
                                      ),
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(
                                            kDefaultPaddingValue,
                                          ),
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                      child: const Text(
                                        "Xóa dữ liệu",
                                        style: TextStyle(
                                          color: Colors.redAccent,
                                          fontWeight: FontWeight.bold,
                                          fontSize: FONTSIZES.textPrimary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
}
