import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';
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
        backgroundColor: Colors.blueAccent,
        // elevation: 4,
        title: Text('Câu hỏi lý thuyết (Hạng ${widget.categoryName})'),
      ),
      body: FutureBuilder<List<QuestionCategory>>(
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
                separatorBuilder: (context, index) => const SizedBox(height: 0),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: kDefaultPaddingValue,
                      vertical: kDefaultPaddingValue,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Get.to(() => QuizScreen(
                              questionCategoryName: snapshot.data![index].name,
                              categoryId: widget.categoryId,
                              questionCategoryId: snapshot.data![index].id,
                            ));
                      },
                      child: Container(
                        height: 20.h,
                        padding: const EdgeInsets.symmetric(
                          horizontal: kDefaultPaddingValue,
                        ),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(
                            kDefaultPaddingValue,
                          )),
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromARGB(80, 82, 82, 82),
                                spreadRadius: 2,
                                blurRadius: 8,
                                offset: Offset(0, 8))
                          ],
                          gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(255, 16, 52, 212),
                                Color.fromARGB(255, 145, 210, 240),
                              ],
                              begin: FractionalOffset(0.0, 0.0),
                              end: FractionalOffset(1.0, 0.0),
                              stops: [0.0, 1.0],
                              tileMode: TileMode.clamp),
                        ),
                        child: Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  snapshot.data![index].name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: FONTSIZES.textHuge,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: kDefaultPaddingValue / 4),
                                  child: Text(
                                    "Tổng ${snapshot.data![index].noOfQuestion} câu",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        ?.copyWith(
                                            color: Colors.white,
                                            fontSize: FONTSIZES.textPrimary),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: kDefaultPaddingValue / 4),
                                  child: Text(
                                    "Hoàn tất ${0} câu",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400,
                                            fontSize: FONTSIZES.textPrimary),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: kDefaultPaddingValue),
                                  child: Container(
                                    width: 60.w,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: kDefaultPaddingValue / 4,
                                      horizontal: kDefaultPaddingValue / 4,
                                    ),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(
                                          kDefaultPaddingValue,
                                        ),
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    child: GFProgressBar(
                                      percentage: 0,
                                      lineHeight: 16,
                                      alignment: MainAxisAlignment.spaceBetween,
                                      backgroundColor: Colors.grey.shade400,
                                      progressBarColor: Color(0xFF7DFF71),
                                      child: const Text(
                                        "${0}%",
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                            fontSize: FONTSIZES.textMedium,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: kDefaultPaddingValue / 2),
                                  child: Image.asset(
                                    "assets/images/quiz/motorbike.png",
                                    scale: 7,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: kDefaultPaddingValue),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: kDefaultPaddingValue / 2,
                                      horizontal: kDefaultPaddingValue,
                                    ),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(
                                          kDefaultPaddingValue,
                                        ),
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    child: const Text(
                                      "Bắt đầu",
                                      style: TextStyle(
                                        color: Colors.redAccent,
                                        fontWeight: FontWeight.bold,
                                        fontSize: FONTSIZES.textPrimary,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
}
