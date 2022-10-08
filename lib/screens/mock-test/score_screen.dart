import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vnrdn_tai/controllers/question_controller.dart';
import 'package:vnrdn_tai/screens/container_screen.dart';
import 'package:vnrdn_tai/screens/mock-test/choose_mode_screen.dart';
import 'package:vnrdn_tai/shared/constants.dart';

class ScoreScreen extends StatelessWidget {
  const ScoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    QuestionController _qnController = Get.put(QuestionController());
    return WillPopScope(
      onWillPop: () async {
        return await false;
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
                              Get.to(() => ContainerScreen());
                            },
                            child: Text("Quay về màn hình chính",
                                style: TextStyle(color: Colors.black)),
                            style: style)
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
