import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:vnrdn_tai/models/QuestionCategory.dart';
import 'package:vnrdn_tai/screens/mock-test/quiz_screen.dart';
import 'package:vnrdn_tai/services/QuestionCategoryService.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'package:vnrdn_tai/shared/snippets.dart';

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _questionCategory = QuestionCategoryService()
        .GetQuestionCategoriesByTestCategory(widget.categoryId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          elevation: 0,
          // Chọn đề (mỗi đề 25 câu)
          title: const Text('Chế độ Học'),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 18.0),
          child: FutureBuilder<List<QuestionCategory>>(
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
                        shrinkWrap: true,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: kDefaultPaddingValue * 1.5),
                        itemBuilder: (context, index) {
                          return ElevatedButton(
                            onPressed: () {
                              Get.to(() => QuizScreen(
                                    categoryId: widget.categoryId,
                                    questionCategoryId:
                                        snapshot.data![index].id,
                                  ));
                            },
                            style: kDefaultButtonStyle,
                            child: Column(
                              children: [
                                Text(
                                  snapshot.data![index].name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4
                                      ?.copyWith(
                                          color: Colors.blueAccent,
                                          fontWeight: FontWeight.bold),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Text(
                                    "Đã ôn 0 trên ${snapshot.data![index].noOfQuestion} câu",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        ?.copyWith(
                                            color: Colors.black54,
                                            fontSize: 16),
                                  ),
                                )
                              ],
                            ),
                          );
                        });
                  }
                }
              }),
        ));
  }
}
