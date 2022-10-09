import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:vnrdn_tai/controllers/question_controller.dart';
import 'package:vnrdn_tai/models/TestResult.dart';
import 'package:vnrdn_tai/models/TestResultDetail.dart';
import 'package:vnrdn_tai/screens/container_screen.dart';
import 'package:vnrdn_tai/screens/mock-test/choose_mode_screen.dart';
import 'package:vnrdn_tai/services/QuestionService.dart';
import 'package:vnrdn_tai/services/TestResultService.dart';
import 'package:vnrdn_tai/shared/constants.dart';

class ScoreScreen extends StatelessWidget {
  ScoreScreen({super.key});

  submitScore(QuestionController qc) {
    if (qc.answeredQuestions.length > 0) {
      dynamic testAttempDTO = null;
      List<TestResultDetail> trds = [];
      var trId = Uuid().v4();
      qc.answeredAttempts.forEach((element) {
        TestResultDetail trd = TestResultDetail(
            Uuid().v4(),
            trId,
            element['question'].id,
            element['selectedAns'].id,
            element['isCorrect'],
            );
        trds.add(trd);
      });
      TestResult tr = TestResult(
          trId,
          userId,
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
        return await true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          shadowColor: Colors.grey,
          title: Text("Điểm số"),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Spacer(),
                Text(
                  'Điểm bài thi vừa rồi',
                  style: Theme.of(context)
                      .textTheme
                      .headline3
                      ?.copyWith(color: Colors.blue),
                ),
                Spacer(),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(kDefaultPaddingValue),
                    child: Column(
                      children: [
                        Text(
                          "Bạn trả lời đúng ${_qnController.numberOfCorrectAns} trên 25 câu",
                          style: Theme.of(context)
                              .textTheme
                              .headline4
                              ?.copyWith(color: Colors.blue),
                          textAlign: TextAlign.center,
                        ),
                        Divider(),
                        _qnController.numberOfCorrectAns >= 22
                            ? Text(
                                "Chúc mừng! Bạn đã hoàn thành xuất sắc bài thi!",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    ?.copyWith(color: Colors.greenAccent),
                                textAlign: TextAlign.center,
                              )
                            : Text(
                                "Chưa đạt! Hãy cố gắng hơn ở lần sau nhé!",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    ?.copyWith(color: Colors.redAccent),
                                textAlign: TextAlign.center,
                              ),
                        SizedBox(height: 50),
                        ElevatedButton(
                            onPressed: () {
                              _qnController.stopTimer();
                              Get.offAll(() => ContainerScreen());
                            },
                            child: Text("Quay về màn hình chính",
                                style: TextStyle(color: Colors.black)),
                            style: buttonStyle)
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
