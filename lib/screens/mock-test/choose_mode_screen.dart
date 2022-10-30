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
                      child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.arrow_back),
                                  color: kPrimaryButtonColor,
                                  onPressed: () {
                                    QuestionController qc =
                                        Get.put(QuestionController());
                                    qc.testCategoryId.value = '';
                                    qc.testCategoryName.value = '';
                                    gc.updateTab(1);
                                    Get.to(ContainerScreen());
                                  },
                                ),
                                Text("Hạng ${qc.testCategoryName.value}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5
                                        ?.copyWith(
                                            color: Colors.blueAccent.shade200,
                                            fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const SizedBox(height: kDefaultPaddingValue),
                            // Vào học
                            ElevatedButton(
                              onPressed: () {
                                gc.updateTestMode(TEST_TYPE.STUDY);
                                if (qc.testCategoryId.value.isNotEmpty) {
                                  Get.to(() => TestSetScreen(
                                        categoryName: qc.testCategoryId.value,
                                        categoryId: qc.testCategoryId.value,
                                      ));
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                alignment: Alignment.center,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: kDefaultPaddingValue / 2),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  // crossAxisAlignment: CrossAxisAlignment.center,
                                  children: const [
                                    Text(
                                      "Câu hỏi lý thuyết",
                                      style: TextStyle(
                                          fontSize: FONTSIZES.textLarge,
                                          fontWeight: FontWeight.bold,
                                          color: kPrimaryButtonColor),
                                    ),
                                    SizedBox(width: kDefaultPaddingValue),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: kDefaultPaddingValue),
                            // Thi thử
                            ElevatedButton(
                              onPressed: () {
                                if (gc.userId.value.isNotEmpty) {
                                  gc.updateTestMode(TEST_TYPE.TEST);
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
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                alignment: Alignment.center,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: kDefaultPaddingValue / 2),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  // crossAxisAlignment: CrossAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.check_circle,
                                      size: 36,
                                      color: kSuccessButtonColor,
                                    ),
                                    SizedBox(width: kDefaultPaddingValue),
                                    Text(
                                      "Thi sát hạch GPLX",
                                      style: TextStyle(
                                          fontSize: FONTSIZES.textLarge,
                                          fontWeight: FontWeight.bold,
                                          color: kSuccessButtonColor),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: kDefaultPaddingValue),
                            // Lịch sử
                            ElevatedButton(
                              onPressed: () {
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
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                alignment: Alignment.center,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: kDefaultPaddingValue / 2),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  // crossAxisAlignment: CrossAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.av_timer_rounded,
                                      size: 36,
                                      color: kWarningButtonColor,
                                    ),
                                    SizedBox(width: kDefaultPaddingValue),
                                    Text(
                                      "Xem lịch sử thi",
                                      style: TextStyle(
                                          fontSize: FONTSIZES.textLarge,
                                          fontWeight: FontWeight.bold,
                                          color: kWarningButtonColor),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: kDefaultPaddingValue),
                            // Lịch sử
                            ElevatedButton(
                              onPressed: () {
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
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                alignment: Alignment.center,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: kDefaultPaddingValue / 2),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  // crossAxisAlignment: CrossAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.av_timer_rounded,
                                      size: 36,
                                      color: kWarningButtonColor,
                                    ),
                                    SizedBox(width: kDefaultPaddingValue),
                                    Text(
                                      "Xem câu bị sai",
                                      style: TextStyle(
                                          fontSize: FONTSIZES.textLarge,
                                          fontWeight: FontWeight.bold,
                                          color: kWarningButtonColor),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ))
                ],
              );
            }
          }),
    );
  }
}
