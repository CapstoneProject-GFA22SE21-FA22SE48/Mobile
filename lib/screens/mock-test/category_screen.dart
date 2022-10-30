import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/controllers/question_controller.dart';
import 'package:vnrdn_tai/models/Category.dart';
import 'package:vnrdn_tai/screens/container_screen.dart';
import 'package:vnrdn_tai/screens/mock-test/choose_mode_screen.dart';
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
    QuestionController qc = Get.put(QuestionController());
    qc.updateTestCategoryId(categoryId);
    qc.updateTestCategoryName(categoryName);
    gc.updateTab(TABS.MOCK_TEST);
    // if (gc.test_mode.value == TEST_TYPE.STUDY) {
    //   Get.to(() => TestSetScreen(
    //         categoryName: categoryName,
    //         categoryId: categoryId,
    //       ));
    // } else {
    //   Get.to(() => QuizScreen(
    //         categoryId: categoryId,
    //       ));
    // }
  }

  getThumbnail(String categoryName) {
    String res = "";
    switch (categoryName) {
      case 'A1':
        res = "motorbike";
        break;
      case 'A2':
        res = "motorcycle";
        break;
      case 'B1, B2':
        res = "car";
        break;
    }
    return res;
  }

  getQuestioNo(String categoryName) {
    String res = "";
    switch (categoryName) {
      case 'A1':
        res = "200 câu";
        break;
      case 'A2':
        res = "200 câu";
        break;
      case 'B1, B2':
        res = "600 câu";
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: kDefaultPaddingValue,
                    ),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: kDefaultPaddingValue),
                          Text(
                            'Chọn GPLX',
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                ?.copyWith(
                                    color: Colors.blueAccent.shade200,
                                    fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: kDefaultPaddingValue,
                            ),
                            child: ListView.separated(
                              itemCount: snapshot.data!.length,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                      height: kDefaultPaddingValue * 1.5),
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    getScreen(gc, snapshot.data![index].name,
                                        snapshot.data![index].id);
                                  },
                                  child: Container(
                                    height: 16.h,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: kDefaultPaddingValue,
                                    ),
                                    decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(
                                        kDefaultPaddingValue,
                                      )),
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Color.fromARGB(80, 82, 82, 82),
                                            spreadRadius: 2,
                                            blurRadius: 8,
                                            offset: Offset(0, 8))
                                      ],
                                      gradient: LinearGradient(
                                          colors: [
                                            Color(0xFF3366FF),
                                            Color(0xFF00CCFF),
                                          ],
                                          begin: FractionalOffset(0.0, 0.0),
                                          end: FractionalOffset(1.0, 0.0),
                                          stops: [0.0, 1.0],
                                          tileMode: TileMode.decal),
                                    ),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: kDefaultPaddingValue),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                snapshot.data![index].name,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline4
                                                    ?.copyWith(
                                                        color:
                                                            Colors.blueAccent,
                                                        fontWeight:
                                                            FontWeight.bold),
                                              ),
                                              gc.test_mode.value ==
                                                      TEST_TYPE.STUDY
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 5),
                                                      child: Text(
                                                        "${getQuestioNo(snapshot.data![index].name)}",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline6
                                                            ?.copyWith(
                                                                color: Colors
                                                                    .black45,
                                                                fontSize: 16),
                                                      ),
                                                    )
                                                  : Container()
                                            ],
                                          ),
                                        ),
                                        const Spacer(),
                                        Image.asset(
                                          "assets/images/quiz/${getThumbnail(snapshot.data![index].name)}.png",
                                          scale: 0.5.h,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ))
                ],
              );
            }
          }
        },
      ),
    );
  }
}
