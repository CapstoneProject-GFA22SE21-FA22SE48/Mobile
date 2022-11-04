import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/controllers/question_controller.dart';
import 'package:vnrdn_tai/models/Question.dart';
import 'package:vnrdn_tai/models/TestResult.dart';
import 'package:vnrdn_tai/models/TestResultDetail.dart';
import 'package:vnrdn_tai/models/dtos/testAttemptDTO.dart';
import 'package:vnrdn_tai/services/TestResultService.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'package:vnrdn_tai/shared/snippets.dart';

class TestResultDetailScreen extends StatefulWidget {
  TestResultDetailScreen({super.key, required this.title, required this.tr});
  String title;
  TestResult tr;

  @override
  State<TestResultDetailScreen> createState() => _TestResultDetailScreenState();
}

class Item {
  TestAttempDTO tad;
  bool isExpanded;
  Item(this.tad, this.isExpanded);
}

class _TestResultDetailScreenState extends State<TestResultDetailScreen> {
  late Future<List<Question>> _questions;
  late bool isLoading = true;
  late List<Item> _items = [];
  GlobalController gc = Get.find<GlobalController>();
  QuestionController qc = Get.put(QuestionController());
  late Future<List<TestAttempDTO>> testAttemptDTOS;

  @override
  void initState() {
    super.initState();
    testAttemptDTOS = TestResultSerivce().GetTestAttemptDTOs(
        widget.tr.id, gc.userId.value, qc.testCategoryId.value);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await true;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text('${widget.title}'),
        ),
        body: FutureBuilder<List<TestAttempDTO>>(
            key: UniqueKey(),
            future: testAttemptDTOS,
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
                  snapshot.data!.forEach((tad) {
                    _items.add(Item(tad, false));
                  });
                  return Column(
                    children: [
                      SizedBox(
                        height: 90.h,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: snapshot.data!.length,
                              itemBuilder: ((context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(
                                        kDefaultPaddingValue,
                                      )),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Color.fromARGB(80, 82, 82, 82),
                                            spreadRadius: 2,
                                            blurRadius: 8,
                                            offset: Offset(0, 8))
                                      ],
                                    ),
                                    child: ExpandableNotifier(
                                        child: ScrollOnExpand(
                                            scrollOnExpand: true,
                                            scrollOnCollapse: false,
                                            child: ExpandablePanel(
                                              theme: const ExpandableThemeData(
                                                headerAlignment:
                                                    ExpandablePanelHeaderAlignment
                                                        .center,
                                                tapBodyToCollapse: true,
                                              ),
                                              header: Padding(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: Column(
                                                    children: [
                                                      snapshot.data![index]
                                                                  .imageUrl !=
                                                              null
                                                          ? SizedBox(
                                                              height: 120,
                                                              child: Image.network(
                                                                  snapshot
                                                                          .data![
                                                                              index]
                                                                          .imageUrl
                                                                      as String,
                                                                  fit: BoxFit
                                                                      .contain))
                                                          : Container(),
                                                      Text(
                                                          snapshot.data![index]
                                                              .questionContent,
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .headline6
                                                              ?.copyWith(
                                                                  color: Colors
                                                                      .blue)),
                                                    ],
                                                  )),
                                              collapsed: snapshot
                                                      .data![index].isCorrect
                                                  ? Center(
                                                      child: Row(
                                                        children: const [
                                                          Text("Đúng ",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .blueAccent,
                                                                  fontSize:
                                                                      16)),
                                                          Icon(Icons.done,
                                                              color: Colors
                                                                  .blueAccent,
                                                              size: 16),
                                                        ],
                                                      ),
                                                    )
                                                  : Center(
                                                      child: Row(
                                                        children: const [
                                                          Text("Sai ",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .red,
                                                                  fontSize:
                                                                      16)),
                                                          Icon(Icons.close,
                                                              color: Colors.red,
                                                              size: 16),
                                                        ],
                                                      ),
                                                    ),
                                              expanded: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 10),
                                                      child: Text(
                                                        snapshot
                                                                .data![index]
                                                                .chosenAnswerContent
                                                                .isNotEmpty
                                                            ? "Bạn đã chọn: \n${snapshot.data![index].chosenAnswerContent}"
                                                            : "Bạn đã không chọn đáp án",
                                                        softWrap: true,
                                                        overflow:
                                                            TextOverflow.fade,
                                                        style: const TextStyle(
                                                            fontSize: 16),
                                                      )),
                                                  Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 10),
                                                      child: Text(
                                                        'Câu trả lời đúng là: \n${snapshot.data![index].correctAnswerContent}',
                                                        softWrap: true,
                                                        overflow:
                                                            TextOverflow.fade,
                                                        style: const TextStyle(
                                                            fontSize: 16),
                                                      ))
                                                ],
                                              ),
                                              builder:
                                                  (_, collapsed, expanded) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10,
                                                          right: 10,
                                                          bottom: 10),
                                                  child: Expandable(
                                                    collapsed: collapsed,
                                                    expanded: expanded,
                                                    theme:
                                                        const ExpandableThemeData(
                                                            crossFadePoint: 0),
                                                  ),
                                                );
                                              },
                                            ))),
                                  ),
                                );
                              })),
                        ),
                      ),
                    ],
                  );
                }
              }
            }),
      ),
    );
  }
}
