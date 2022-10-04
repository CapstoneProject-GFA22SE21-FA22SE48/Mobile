import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vnrdn_tai/controllers/question_controller.dart';

class ScoreScreen extends StatelessWidget {
  const ScoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    QuestionController _qnController = Get.put(QuestionController());
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Spacer(),
              Text(
                'Score',
                style: Theme.of(context)
                    .textTheme
                    .headline3
                    ?.copyWith(color: Colors.blue),
              ),
              Spacer(),
              Text("${_qnController.numberOfCorrectAns}/ 60",
                  style: Theme.of(context)
                      .textTheme
                      .headline4
                      ?.copyWith(color: Colors.blue)),
              Spacer(flex: 3)
            ],
          )
        ],
      ),
    );
  }
}
