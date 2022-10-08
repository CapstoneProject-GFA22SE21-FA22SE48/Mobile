import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/controllers/question_controller.dart';
import 'package:vnrdn_tai/models/Question.dart';
import 'package:vnrdn_tai/screens/container_screen.dart';
import 'package:vnrdn_tai/screens/mock-test/components/body.dart';
import 'package:vnrdn_tai/screens/mock-test/score_screen.dart';
import 'package:vnrdn_tai/services/QuestionService.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'package:vnrdn_tai/shared/snippets.dart';

class QuizScreen extends StatefulWidget {
  QuizScreen({super.key, required this.categoryId, this.separator = 0});
  String categoryId;

  int separator;
  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late Future<List<Question>> _questions;
  late bool isLoading = true;
  GlobalController gc = Get.find<GlobalController>();
  @override
  void initState() {
    super.initState();
    if (gc.test_mode == TEST_TYPE.STUDY) {
      _questions = QuestionSerivce().GetStudySetByCategoryAndSeparator(
          widget.categoryId, widget.separator);
    } else {
      _questions =
          QuestionSerivce().GetRandomTestSetBytestCategoryId(widget.categoryId);
    }
  }

  handleError(value) {
    print(value);
    Get.snackbar('Lỗi', '$value', colorText: Colors.red, isDismissible: true);
    Get.to(() => ContainerScreen());
  }

  void confirmSubmission() {
    Get.dialog(
      AlertDialog(
        title: const Text('Nộp bài'),
        content: const Text('Bạn có chắc là bạn muốn nộp bài không?'),
        actions: [
          TextButton(
            child: const Text("Xác nhận"),
            onPressed: () => Get.to(ScoreScreen()),
          ),
          TextButton(
            child: const Text("Không"),
            onPressed: () => Get.back(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading:
              gc.test_mode == TEST_TYPE.STUDY ? true : false,
          actions: [
            gc.test_mode == TEST_TYPE.STUDY && isLoading
                ? Container()
                : ButtonTheme(
                    child: ElevatedButton(
                        onPressed: () {
                          confirmSubmission();
                        },
                        style: ElevatedButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 12),
                            backgroundColor: Colors.green,
                            shadowColor: Colors.grey,
                            alignment: Alignment.center,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        child: Text("Nộp bài")))
          ],
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: Text(
              '${gc.test_mode == TEST_TYPE.STUDY ? "Chế độ Học " : "Chế độ Thi"}'),
        ),
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
                  return Body(questions: snapshot.data!);
                }
              }
            }));
  }
}
