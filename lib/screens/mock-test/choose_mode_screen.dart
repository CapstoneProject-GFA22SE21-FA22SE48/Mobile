import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/controllers/question_controller.dart';
import 'package:vnrdn_tai/models/TestResult.dart';
import 'package:vnrdn_tai/screens/auth/login_screen.dart';
import 'package:vnrdn_tai/screens/container_screen.dart';
import 'package:vnrdn_tai/screens/mock-test/category_screen.dart';
import 'package:vnrdn_tai/screens/mock-test/quiz_screen.dart';
import 'package:vnrdn_tai/screens/mock-test/test_results.dart';
import 'package:vnrdn_tai/screens/mock-test/test_set_screen.dart';
import 'package:vnrdn_tai/services/TestResultService.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'package:vnrdn_tai/shared/snippets.dart';
import 'package:vnrdn_tai/utils/dialogUtil.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    GlobalController gc = Get.find<GlobalController>();
    gc.updateTestMode(TEST_TYPE.STUDY);
    testResults = TestResultSerivce().GetTestResultList(
        gc.userId.value.isNotEmpty ? gc.userId.value : emptyUserId);
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
              }
              return Stack(
                children: [
                  SafeArea(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(
                        vertical: kDefaultPaddingValue + 4,
                        horizontal: kDefaultPaddingValue,
                      ),
                      children: [
                        const SizedBox(height: kDefaultPaddingValue * 3),

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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                      style: TextStyle(
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
                              DialogUtil.showTextDialog(
                                  context,
                                  "Cảnh báo",
                                  "Bạn cần đăng nhập để tiếp tục.\nĐến trang đăng nhập?",
                                  [
                                    TemplatedButtons.yes(
                                        context, const LoginScreen()),
                                    TemplatedButtons.no(context),
                                  ]);
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Thi sát hạch GPLX",
                                      style: TextStyle(
                                          fontSize: FONTSIZES.textHuge,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    const SizedBox(
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
                              Get.to(() => TestRestulScreen(
                                  testResults: snapshot.data!));
                            } else {
                              DialogUtil.showTextDialog(
                                  context,
                                  "Authenticator",
                                  "You need to logged in to continue.\nGo to login page?",
                                  [
                                    TemplatedButtons.yes(
                                        context, const LoginScreen()),
                                    TemplatedButtons.no(context),
                                  ]);
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Xem lịch sử thi",
                                      style: TextStyle(
                                          fontSize: FONTSIZES.textHuge,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    SizedBox(height: kDefaultPaddingValue / 2),
                                    Text(
                                      "Kết quả của ${12} lần thi",
                                      style: TextStyle(
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
                              Get.to(() => TestRestulScreen(
                                  testResults: snapshot.data!));
                            } else {
                              DialogUtil.showTextDialog(
                                  context,
                                  "Authenticator",
                                  "You need to logged in to continue.\nGo to login page?",
                                  [
                                    TemplatedButtons.yes(
                                        context, const LoginScreen()),
                                    TemplatedButtons.no(context),
                                  ]);
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Xem câu bị sai",
                                      style: TextStyle(
                                          fontSize: FONTSIZES.textHuge,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    SizedBox(height: kDefaultPaddingValue / 2),
                                    Text(
                                      "Có ${57} câu bị sai",
                                      style: TextStyle(
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
                  Container(
                    decoration: BoxDecoration(color: Colors.white70),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: kDefaultPaddingValue / 2,
                            horizontal: kDefaultPaddingValue / 2,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back),
                            color: kPrimaryButtonColor,
                            iconSize: FONTSIZES.textHuge,
                            onPressed: () {
                              QuestionController qc =
                                  Get.put(QuestionController());
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
                                    color: Colors.blueAccent.shade400,
                                    fontSize: FONTSIZES.textHuge,
                                    fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              );
            }
          }),
    );
  }
}
