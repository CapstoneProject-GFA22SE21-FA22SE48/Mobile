import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/controllers/question_controller.dart';
import 'package:vnrdn_tai/models/Question.dart';
import 'package:vnrdn_tai/screens/mock-test/components/body.dart';
import 'package:vnrdn_tai/services/QuestionService.dart';
import 'package:vnrdn_tai/shared/constants.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late Future<List<Question>> _questions;
  late QuestionController _questionController;
  GlobalController gc = Get.find<GlobalController>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _questions = QuestionSerivce().GetQuestionList();
    _questionController = Get.put(QuestionController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          elevation: 0,
          title: Text('${gc.test_mode == TEST_TYPE.STUDY ? "Chế độ Học " : "Chế độ thi"}'),
        ),
        body: FutureBuilder<List<Question>>(
            key: UniqueKey(),
            future: _questions,
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);
              return snapshot.hasData
                  ? Body(questions: snapshot.data!)
                  : Center(child: CircularProgressIndicator());
            }));
  }
}
