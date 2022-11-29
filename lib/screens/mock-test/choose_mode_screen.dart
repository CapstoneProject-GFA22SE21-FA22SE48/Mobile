import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:uuid/uuid.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/controllers/question_controller.dart';
import 'package:vnrdn_tai/models/TestResult.dart';
import 'package:vnrdn_tai/models/TestResultDetail.dart';
import 'package:vnrdn_tai/screens/auth/login_screen.dart';
import 'package:vnrdn_tai/screens/container_screen.dart';
import 'package:vnrdn_tai/screens/mock-test/category_screen.dart';
import 'package:vnrdn_tai/screens/mock-test/quiz_screen.dart';
import 'package:vnrdn_tai/screens/mock-test/test_result_detail.dart';
import 'package:vnrdn_tai/screens/mock-test/test_results.dart';
import 'package:vnrdn_tai/screens/mock-test/test_set_screen.dart';
import 'package:vnrdn_tai/services/TestResultService.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'package:vnrdn_tai/shared/snippets.dart';
import 'package:vnrdn_tai/utils/dialog_util.dart';
import 'package:vnrdn_tai/utils/io_utils.dart';
import 'package:vnrdn_tai/widgets/templated_buttons.dart';

class ChooseModeScreen extends StatefulWidget {
  const ChooseModeScreen({super.key});

  @override
  State<ChooseModeScreen> createState() => _ChooseModeScreenState();
}

class _ChooseModeScreenState extends State<ChooseModeScreen> {
  QuestionController qc = Get.put(QuestionController());
  late Future<List<TestResult>> testResults;

  @override
  void initState() {
    super.initState();
    IOUtils.getFromStorage('token');
    qc.clearAnsweredAttempts();
  }

  @override
  Widget build(BuildContext context) {
    GlobalController gc = Get.find<GlobalController>();
    QuestionController qc = Get.put(QuestionController());
    gc.updateTestMode(TEST_TYPE.STUDY);
    testResults = TestResultSerivce().GetTestResultList(
        gc.userId.value.isNotEmpty ? gc.userId.value : emptyUserId,
        qc.testCategoryId.value);
    return Scaffold(
      body: FutureBuilder<List<TestResult>>(
          key: UniqueKey(),
          future: testResults,
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
                var res = snapshot.data!.take(10).toList();
                List<TestResultDetail> onlyWrongTestResultDetail = [];
                List<TestResultDetail> wrong = [];
                List<TestResultDetail> correct = [];
                res.forEach((tr) {
                  tr.testResultDetails.forEach((trd) {
                    if (trd.isCorrect) {
                      if (correct.firstWhereOrNull((element) =>
                              element.questionId == trd.questionId) ==
                          null) correct.add(trd);
                    } else {
                      if (wrong.firstWhereOrNull((element) =>
                              element.questionId == trd.questionId) ==
                          null) wrong.add(trd);
                    }
                  });
                });
                onlyWrongTestResultDetail =
                    wrong.where((trd) => !correct.contains(trd)).toList();

                onlyWrongTestResultDetail = onlyWrongTestResultDetail
                    .where((element) => element.answerId != null)
                    .toList();
                TestResult onlyWrongTestResult = TestResult(
                    emptyUserId,
                    gc.userId.value,
                    qc.testCategoryId.value,
                    DateTime.now().toString(),
                    onlyWrongTestResultDetail);
                return Stack(
                  children: [
                    SafeArea(
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                          vertical: kDefaultPaddingValue / 2,
                          horizontal: kDefaultPaddingValue,
                        ),
                        children: [
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.start,
                          //   children: [
                          //     IconButton(
                          //         onPressed: () {
                          //           QuestionController qc =
                          //               Get.put(QuestionController());
                          //           qc.updateTestCategoryId('');
                          //           qc.updateTestCategoryName('');
                          //           qc.updateTestCategoryCount(0);
                          //         },
                          //         padding: const EdgeInsets.only(left: 0.0),
                          //         icon: const Icon(
                          //           Icons.arrow_back,
                          //           color: Colors.blueAccent,
                          //           size: FONTSIZES.textHuge,
                          //         )),
                          //     Text(
                          //       'Bằng loại ${qc.testCategoryName.value}',
                          //       style: const TextStyle(
                          //           color: Colors.blueAccent,
                          //           fontSize: FONTSIZES.textLarger,
                          //           fontWeight: FontWeight.bold),
                          //     ),
                          //   ],
                          // ),
                          const SizedBox(height: kDefaultPaddingValue * 4),

                          // Vào học
                          GestureDetector(
                            onTap: () {
                              gc.updateTestMode(TEST_TYPE.STUDY);
                              if (qc.testCategoryId.value.isNotEmpty) {
                                Get.to(() => TestSetScreen(
                                      categoryName: qc.testCategoryName.value,
                                      categoryId: qc.testCategoryId.value,
                                    ));
                              }
                            },
                            child: Container(
                              height: 16.h,
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
                                      Color(0xFF00B953),
                                      Color(0xFF91F096),
                                    ],
                                    begin: FractionalOffset(0.0, 0.0),
                                    end: FractionalOffset(1.0, 0.0),
                                    stops: [0.0, 1.0],
                                    tileMode: TileMode.clamp),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Câu hỏi lý thuyết",
                                        style: TextStyle(
                                            fontSize: FONTSIZES.textHuge,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      const SizedBox(
                                          height: kDefaultPaddingValue / 2),
                                      Text(
                                        "${qc.testCategoryCount} câu hỏi theo chủ đề",
                                        style: const TextStyle(
                                            fontSize: FONTSIZES.textPrimary,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  Image.asset(
                                    "assets/images/quiz/education.png",
                                    scale: 0.8.h,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: kDefaultPaddingValue),
                          // Thi thử
                          GestureDetector(
                            onTap: () {
                              if (gc.userId.value.isNotEmpty) {
                                gc.updateTestMode(TEST_TYPE.TEST);
                                qc.restartTimer();
                                Get.to(() => QuizScreen(
                                      categoryId: qc.testCategoryId.value,
                                    ));
                              } else {
                                DialogUtil.showAwesomeDialog(
                                    context,
                                    DialogType.warning,
                                    "Cảnh báo",
                                    "Bạn cần đăng nhập để tiếp tục.\nĐến trang đăng nhập?",
                                    () => Get.to(() => const LoginScreen()),
                                    () {});
                              }
                            },
                            child: Container(
                              height: 16.h,
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
                                      Color.fromARGB(255, 78, 51, 228),
                                      Color.fromARGB(255, 113, 202, 230),
                                    ],
                                    begin: FractionalOffset(0.0, 0.0),
                                    end: FractionalOffset(1.0, 0.0),
                                    stops: [0.0, 1.0],
                                    tileMode: TileMode.clamp),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                // crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        "Thi sát hạch GPLX",
                                        style: TextStyle(
                                            fontSize: FONTSIZES.textHuge,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      SizedBox(
                                          height: kDefaultPaddingValue / 2),
                                      Text(
                                        "Bộ đề ngẫu nhiên thực tế nhất",
                                        style: TextStyle(
                                            fontSize: FONTSIZES.textPrimary,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  Image.asset(
                                    "assets/images/quiz/exam.png",
                                    scale: 0.8.h,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: kDefaultPaddingValue),
                          // Lịch sử
                          GestureDetector(
                            onTap: () {
                              if (gc.userId.value.isNotEmpty) {
                                gc.updateTestMode(TEST_TYPE.TEST);
                                Get.to(
                                    () => TestResultScreen(testResults: res));
                              } else {
                                DialogUtil.showAwesomeDialog(
                                    context,
                                    DialogType.warning,
                                    "Cảnh báo",
                                    "Bạn cần đăng nhập để tiếp tục.\nĐến trang đăng nhập?",
                                    () => Get.to(() => const LoginScreen()),
                                    () {});
                              }
                            },
                            child: Container(
                              height: 16.h,
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
                                      Color.fromARGB(255, 136, 85, 204),
                                      Color.fromARGB(255, 186, 167, 255),
                                    ],
                                    begin: FractionalOffset(0.0, 0.0),
                                    end: FractionalOffset(1.0, 0.0),
                                    stops: [0.0, 1.0],
                                    tileMode: TileMode.clamp),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Xem lịch sử thi",
                                        style: TextStyle(
                                            fontSize: FONTSIZES.textHuge,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      const SizedBox(
                                          height: kDefaultPaddingValue / 2),
                                      Text(
                                        gc.userId.value.isNotEmpty
                                            ? "Kết quả của 10 lần thi gần nhất"
                                            : "Chưa có dữ liệu",
                                        style: const TextStyle(
                                            fontSize: FONTSIZES.textPrimary,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  Image.asset(
                                    "assets/images/quiz/history.png",
                                    scale: 0.8.h,
                                  ),
                                  const SizedBox(width: kDefaultPaddingValue),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: kDefaultPaddingValue),
                          // Xem câu sai
                          GestureDetector(
                            onTap: () {
                              if (gc.userId.value.isNotEmpty) {
                                gc.updateTestMode(TEST_TYPE.TEST);
                                Get.to(() => TestResultDetailScreen(
                                      tr: onlyWrongTestResult,
                                      title: "Xem câu sai",
                                    ));
                              } else {
                                DialogUtil.showAwesomeDialog(
                                    context,
                                    DialogType.warning,
                                    "Cảnh báo",
                                    "Bạn cần đăng nhập để tiếp tục.\nĐến trang đăng nhập?",
                                    () => Get.to(() => const LoginScreen()),
                                    () {});
                              }
                            },
                            child: Container(
                              height: 16.h,
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
                                      Color(0xFFFF3B3B),
                                      Color(0xFFFF9F9F),
                                    ],
                                    begin: FractionalOffset(0.0, 0.0),
                                    end: FractionalOffset(1.0, 0.0),
                                    stops: [0.0, 0.8],
                                    tileMode: TileMode.clamp),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Xem câu bị sai",
                                        style: TextStyle(
                                            fontSize: FONTSIZES.textHuge,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      const SizedBox(
                                          height: kDefaultPaddingValue / 2),
                                      Text(
                                        gc.userId.value.isNotEmpty
                                            ? "Có ${onlyWrongTestResultDetail.length} câu bị sai"
                                            : "Chưa có dữ liệu",
                                        style: const TextStyle(
                                            fontSize: FONTSIZES.textPrimary,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  Image.asset(
                                    "assets/images/quiz/wrong.png",
                                    scale: 0.8.h,
                                  ),
                                  const SizedBox(width: kDefaultPaddingValue),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SafeArea(
                      child: Container(
                        padding: const EdgeInsets.only(
                            top: kDefaultPaddingValue / 4),
                        decoration: const BoxDecoration(color: Colors.white10),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: kDefaultPaddingValue / 4,
                                horizontal: kDefaultPaddingValue / 2,
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.arrow_back),
                                // color: kPrimaryButtonColor,
                                color: Colors.pinkAccent.shade200,
                                iconSize: FONTSIZES.textHuge,
                                onPressed: () {
                                  qc.testCategoryId.value = '';
                                  qc.testCategoryName.value = '';
                                  gc.updateTab(1);
                                  Get.to(const ContainerScreen());
                                },
                              ),
                            ),
                            Text("Hạng ${qc.testCategoryName.value}",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    ?.copyWith(
                                        color: Colors.pinkAccent.shade200,
                                        fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
            }
          }),
    );
  }
}
