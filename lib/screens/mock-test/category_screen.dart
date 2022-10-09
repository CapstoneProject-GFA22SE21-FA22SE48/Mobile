import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/controllers/question_controller.dart';
import 'package:vnrdn_tai/models/Category.dart';
import 'package:vnrdn_tai/screens/container_screen.dart';
import 'package:vnrdn_tai/screens/mock-test/quiz_screen.dart';
import 'package:vnrdn_tai/screens/mock-test/test_set_screen.dart';
import 'package:vnrdn_tai/services/TestCategoryService.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'package:vnrdn_tai/shared/snippets.dart';

class CategoryScreen extends StatefulWidget {
  CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late Future<List<TestCategory>> categories;

  getScreen(GlobalController gc, String categoryName, String categoryId) {
    if (gc.test_mode.value == TEST_TYPE.STUDY) {
      Get.to(TestSetScreen(
        categoryName: categoryName,
        categoryId: categoryId,
      ));
    } else {
      Get.to(QuizScreen(
        categoryId: categoryId,
      ));
    }
  }

  getQuestioNo(String categoryName) {
    String res = "";
    switch (categoryName) {
      case 'A1':
        res = "200 câu / 8 đề";
        break;
      case 'A2':
        res = "200 câu / 8 đề";
        break;
      case 'B1, B2':
        res = "600 câu / 24 đề";
        break;
    }
    return res;
  }

  

  @override
  void initState() {
    super.initState();
    categories = TestCategoryService().GetTestCategories();
  }

  @override
  Widget build(BuildContext context) {
    GlobalController gc = Get.find<GlobalController>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        title: Text(
            '${gc.test_mode == TEST_TYPE.STUDY ? "Chế độ Học " : "Chế độ Thi"}'),
      ),
      body: FutureBuilder<List<TestCategory>>(
          key: UniqueKey(),
          future: categories,
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
                return Stack(
                  children: [
                    SafeArea(
                        child: Padding(
                      padding: const EdgeInsets.all(50.0),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Chọn loại bằng',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline3
                                  ?.copyWith(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: ListView.separated(
                                  itemCount: snapshot.data!.length,
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  separatorBuilder: (context, index) =>
                                      SizedBox(height: kDefaultPaddingValue),
                                  itemBuilder: (context, index) {
                                    return ElevatedButton(
                                      onPressed: () {
                                        getScreen(
                                            gc,
                                            snapshot.data![index].name,
                                            snapshot.data![index].id);
                                      },
                                      child: Column(
                                        children: [
                                          Text(
                                            "${snapshot.data![index].name}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline4
                                                ?.copyWith(
                                                    color: Colors.green,
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ),
                                          gc.test_mode.value == TEST_TYPE.STUDY
                                              ? Text(
                                                  "${getQuestioNo(snapshot.data![index].name)}",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline6
                                                      ?.copyWith(
                                                          color: Colors.black,
                                                          fontSize: 12),
                                                )
                                              : Container()
                                        ],
                                      ),
                                      style: buttonStyle,
                                    );
                                  }),
                            )
                          ],
                        ),
                      ),
                    ))
                  ],
                );
              }
            }
          }),
    );
  }
}
