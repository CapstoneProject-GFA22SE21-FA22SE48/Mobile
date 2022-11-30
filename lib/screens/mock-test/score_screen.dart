import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/controllers/question_controller.dart';
import 'package:vnrdn_tai/models/Question.dart';
import 'package:vnrdn_tai/models/TestResult.dart';
import 'package:vnrdn_tai/models/TestResultDetail.dart';
import 'package:vnrdn_tai/screens/container_screen.dart';
import 'package:vnrdn_tai/screens/mock-test/choose_mode_screen.dart';
import 'package:vnrdn_tai/services/QuestionService.dart';
import 'package:vnrdn_tai/services/TestResultService.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'package:vnrdn_tai/utils/io_utils.dart';

import 'package:styled_text/styled_text.dart';

class ScoreScreen extends StatelessWidget {
  ScoreScreen({super.key});

  submitScore(QuestionController qc) {
    if (qc.answeredQuestions.length > 0) {
      List<TestResultDetail> trds = [];
      List<Question> questions = qc.questions;
      var trId = Uuid().v4();
      qc.answeredAttempts.forEach((element) {
        TestResultDetail trd = TestResultDetail(
          Uuid().v4(),
          trId,
          element['question']['id'],
          element['selectedAns']['id'],
          element['isCorrect'],
        );
        trds.add(trd);
      });

      questions.forEach((question) {
        if (trds.firstWhereOrNull(
                (element2) => element2.questionId == question.id) ==
            null) {
          TestResultDetail trd = TestResultDetail(
            Uuid().v4(),
            trId,
            question.id,
            null,
            false,
          );
          trds.add(trd);
        }
      });

      GlobalController gc = Get.put(GlobalController());
      TestResult tr = TestResult(
          trId,
          gc.userId.value,
          qc.answeredQuestions[0].testCategoryId,
          DateTime.now().toString(),
          trds);
      TestResultSerivce().saveTestResult(tr);
    }
  }

  @override
  Widget build(BuildContext context) {
    QuestionController _qnController = Get.put(QuestionController());
    submitScore(_qnController);
    return WillPopScope(
      onWillPop: () async {
        _qnController.stopTimer();
        Get.offAll(() => ContainerScreen());
        return await true;
      },
      child: Scaffold(
        appBar: AppBar(
          shadowColor: Colors.grey,
          title: const Text("Kết thúc bài thi"),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Spacer(),
                Text(
                  'Kết thúc',
                  style: Theme.of(context).textTheme.headline3?.copyWith(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Spacer(),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(kDefaultPaddingValue),
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/images/quiz/${_qnController.numberOfCorrectAns >= 20 ? 'exam_pass' : 'exam_fail'}.png",
                          scale: 2,
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(top: kDefaultPaddingValue * 2),
                          child: StyledText(
                            tags: {
                              'bold': StyledTextTag(
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                            },
                            text:
                                'Bạn đã trả lời đúng <bold>${_qnController.numberOfCorrectAns}</bold> trên <bold>${25}</bold> câu',
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: FONTSIZES.textLarge,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const Divider(),
                        _qnController.numberOfCorrectAns >= 22
                            ? Text(
                                "Chúc mừng! Bạn đã hoàn thành xuất sắc bài thi!",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    ?.copyWith(
                                        color: Colors.greenAccent.shade700),
                                textAlign: TextAlign.center,
                              )
                            : const Text(
                                "Chưa đạt! Hãy cố gắng hơn ở lần sau nhé!",
                                style: TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: FONTSIZES.textPrimary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                        SizedBox(height: 50),
                        ElevatedButton(
                            onPressed: () {
                              _qnController.stopTimer();
                              Get.offAll(() => ContainerScreen());
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
                                  vertical: kDefaultPaddingValue,
                                  horizontal: kDefaultPaddingValue),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      kDefaultPaddingValue)),
                            ),
                            child: const Text("Quay về màn hình chính",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: FONTSIZES.textPrimary,
                                )))
                      ],
                    ),
                  ),
                ),
                Spacer(flex: 3)
              ],
            )
          ],
        ),
      ),
    );
  }
}
