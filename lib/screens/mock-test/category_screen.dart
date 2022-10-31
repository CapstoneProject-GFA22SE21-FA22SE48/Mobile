import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/controllers/question_controller.dart';
import 'package:vnrdn_tai/models/TestCategory.dart';
import 'package:vnrdn_tai/models/dtos/TestCategoryDTO.dart';
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
  late Future<List<TestCategoryDTO>> categories;

  getScreen(
      GlobalController gc, String categoryName, String categoryId, int count) {
    QuestionController qc = Get.put(QuestionController());
    qc.updateTestCategoryId(categoryId);
    qc.updateTestCategoryName(categoryName);
    qc.updateTestCategoryCount(count);
    gc.updateTab(TABS.MOCK_TEST);
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

  List<List<Color>> gradient = [
    [
      Color(0xFF8855CC),
      Color(0xFFBAA7FF),
    ],
    [
      Color(0xFF3366FF),
      Color(0xFF00CCFF),
    ],
    [
      Color(0xFF00B953),
      Color(0xFF91F096),
    ]
  ];

  // getQuestioNo(String categoryName) {
  //   int res = 0;
  //   switch (categoryName) {
  //     case 'A1':
  //       res = 200;
  //       break;
  //     case 'A2':
  //       res = 452;
  //       break;
  //     case 'B1, B2':
  //       res = 600;
  //       break;
  //   }
  //   return res;
  // }

  @override
  void initState() {
    super.initState();
    categories = TestCategoryService().GetTestCategories();
  }

  @override
  Widget build(BuildContext context) {
    GlobalController gc = Get.find<GlobalController>();
    return Scaffold(
      body: FutureBuilder<List<TestCategoryDTO>>(
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
                            'Chọn hạng GPLX',
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                ?.copyWith(
                                    color: Colors.pinkAccent.shade200,
                                    fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 0,
                            ),
                            child: ListView.separated(
                              itemCount: snapshot.data!.length,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 0),
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    getScreen(
                                        gc,
                                        snapshot.data![index].name,
                                        snapshot.data![index].id,
                                        snapshot.data![index].count);
                                  },
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: kDefaultPaddingValue * 4),
                                        child: Container(
                                          height: 16.h,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: kDefaultPaddingValue,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(
                                              kDefaultPaddingValue,
                                            )),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Color.fromARGB(
                                                      80, 82, 82, 82),
                                                  spreadRadius: 2,
                                                  blurRadius: 8,
                                                  offset: Offset(0, 8))
                                            ],
                                            gradient: LinearGradient(
                                                colors: gradient[index],
                                                begin:
                                                    FractionalOffset(0.0, 0.0),
                                                end: FractionalOffset(1.0, 0.0),
                                                stops: [0.0, 1.0],
                                                tileMode: TileMode.decal),
                                          ),
                                          child: Row(
                                            children: [
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Icon(
                                                    Icons
                                                        .play_circle_outline_rounded,
                                                    color: Colors.white,
                                                    size: FONTSIZES.textHuge,
                                                  ),
                                                  // const SizedBox(
                                                  //   height: kDefaultPaddingValue / 2,
                                                  // ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical:
                                                            kDefaultPaddingValue /
                                                                2),
                                                    child: Text(
                                                      "${snapshot.data![index].count} câu hỏi",
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: FONTSIZES
                                                            .textPrimary,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                      "HẠNG ${snapshot.data![index].name}",
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            FONTSIZES.textHuge,
                                                      )),
                                                ],
                                              ),
                                              const Spacer(),
                                              Container(),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          const Spacer(),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right:
                                                    kDefaultPaddingValue * 2),
                                            child: Image.asset(
                                              "assets/images/quiz/${getThumbnail(snapshot.data![index].name)}.png",
                                              scale: 0.5.h,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
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
