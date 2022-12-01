import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/controllers/question_controller.dart';
import 'package:vnrdn_tai/models/dtos/TestCategoryDTO.dart';
import 'package:vnrdn_tai/services/TestCategoryService.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'package:vnrdn_tai/shared/snippets.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

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
      const Color(0xFF8855CC),
      const Color(0xFFBAA7FF),
    ],
    [
      const Color(0xFF3366FF),
      const Color(0xFF00CCFF),
    ],
    [
      const Color(0xFF00B953),
      const Color(0xFF91F096),
    ]
  ];

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
                      vertical: kDefaultPaddingValue / 2,
                    ),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: kDefaultPaddingValue),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 0,
                            ),
                            child: ListView.separated(
                              itemCount: snapshot.data!.length,
                              scrollDirection: Axis.vertical,
                              physics: const BouncingScrollPhysics(),
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
                                        padding: const EdgeInsets.only(
                                            top: kDefaultPaddingValue * 4),
                                        child: Container(
                                          height: 16.h,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: kDefaultPaddingValue,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(
                                              kDefaultPaddingValue,
                                            )),
                                            boxShadow: const [
                                              BoxShadow(
                                                  color: Color.fromARGB(
                                                      80, 82, 82, 82),
                                                  spreadRadius: 2,
                                                  blurRadius: 8,
                                                  offset: Offset(0, 8))
                                            ],
                                            gradient: LinearGradient(
                                                colors: gradient[index],
                                                begin: const FractionalOffset(
                                                    0.0, 0.0),
                                                end: const FractionalOffset(
                                                    1.0, 0.0),
                                                stops: const [0.0, 1.0],
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
                                                  // const Icon(
                                                  //   Icons
                                                  //       .play_circle_outline_rounded,
                                                  //   color: Colors.white,
                                                  //   size: FONTSIZES.textHuge,
                                                  // ),
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
                                                            .textMediumLarge,
                                                      ),
                                                    ),
                                                  ),
                                                  const Divider(),
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
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .play_circle_outline_rounded,
                                                    color: Colors.white,
                                                    size: 18.0.w,
                                                  ),
                                                  SizedBox(
                                                    height:
                                                        kDefaultPaddingValue,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                width: 10.w,
                                              ),
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
                  )),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: kDefaultPaddingValue * 2,
                        vertical: kDefaultPaddingValue,
                      ),
                      child: Text(
                        'Chọn hạng GPLX',
                        style: Theme.of(context).textTheme.headline5?.copyWith(
                            color: Colors.pinkAccent.shade200,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              );
            }
          }
        },
      ),
    );
  }
}
