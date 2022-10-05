import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/controllers/question_controller.dart';
import 'package:vnrdn_tai/models/Question.dart';
import 'package:vnrdn_tai/screens/mock-test/choose_mode_screen.dart';
import 'package:vnrdn_tai/screens/mock-test/components/body.dart';
import 'package:vnrdn_tai/services/QuestionService.dart';
import 'package:vnrdn_tai/shared/constants.dart';

class QuizScreen extends StatefulWidget {
  QuizScreen({super.key, this.categoryName = ""});
  String categoryName;
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
    if (gc.test_mode == TEST_TYPE.STUDY) {
      _questions = QuestionSerivce().GetQuestionList();
    } else {
      _questions =
          QuestionSerivce().GetRandomTestSetBytestCategoryId(widget.categoryName);
    }
    _questionController = Get.put(QuestionController());
  }

  handleError(value) {
    Get.snackbar('Lỗi', 'Có lỗi xảy ra', colorText: Colors.red);
    Get.to(() => ChooseModeScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          elevation: 0,
          title: Text(
              '${gc.test_mode == TEST_TYPE.STUDY ? "Chế độ Học " : "Chế độ Thi"}'),
        ),
        body: FutureBuilder<List<Question>>(
            key: UniqueKey(),
            future: _questions,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Padding(
                  padding: const EdgeInsets.only(top: 200.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 200.0,
                        child: Stack(
                          children: <Widget>[
                            Center(
                              child: Container(
                                width: 200,
                                height: 200,
                                child: new CircularProgressIndicator(
                                  strokeWidth: 15,
                                ),
                              ),
                            ),
                            Center(child: Text("Đang tải dữ liệu...")),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                if (snapshot.hasError) {
                  Future.delayed(
                      Duration.zero, () => {handleError(snapshot.error)});
                  throw Exception(snapshot.error);
                } else {
                  return Body(questions: snapshot.data!);
                }
              }
            }));
  }
}
