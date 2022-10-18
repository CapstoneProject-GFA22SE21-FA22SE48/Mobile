import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/models/TestResult.dart';
import 'package:vnrdn_tai/screens/mock-test/category_screen.dart';
import 'package:vnrdn_tai/screens/mock-test/quiz_screen.dart';
import 'package:vnrdn_tai/screens/mock-test/test_results.dart';
import 'package:vnrdn_tai/screens/mock-test/test_set_screen.dart';
import 'package:vnrdn_tai/services/TestResultService.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'package:vnrdn_tai/shared/snippets.dart';

class ChooseModeScreen extends StatefulWidget {
  ChooseModeScreen({super.key});

  @override
  State<ChooseModeScreen> createState() => _ChooseModeScreenState();
}

class _ChooseModeScreenState extends State<ChooseModeScreen> {
  late Future<List<TestResult>> testResults;

  @override
  void initState() {
    super.initState();
    testResults = TestResultSerivce().GetTestResultList(userId);
  }

  @override
  Widget build(BuildContext context) {
    GlobalController gc = Get.find<GlobalController>();
    gc.updateTestMode(TEST_TYPE.STUDY);
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
                      padding: const EdgeInsets.only(top: 0.0),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Bạn muốn làm gì?',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4
                                    ?.copyWith(
                                        color: Colors.blueAccent.shade200,
                                        fontWeight: FontWeight.bold,
                                        fontSize: FONTSIZES.textHuge)),
                            const SizedBox(height: kDefaultPaddingValue),
                            const SizedBox(height: kDefaultPaddingValue),
                            ElevatedButton(
                              onPressed: () {
                                gc.updateTestMode(TEST_TYPE.STUDY);
                                Get.to(() => CategoryScreen());
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
                                      Icons.list_alt_rounded,
                                      size: 36,
                                      color: kPrimaryButtonColor,
                                    ),
                                    SizedBox(width: kDefaultPaddingValue),
                                    Text(
                                      "Vào Học",
                                      style: TextStyle(
                                          fontSize: FONTSIZES.textLarge,
                                          fontWeight: FontWeight.bold,
                                          color: kPrimaryButtonColor),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: kDefaultPaddingValue),
                            ElevatedButton(
                              onPressed: () {
                                gc.updateTestMode(TEST_TYPE.TEST);
                                Get.to(() => CategoryScreen());
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
                                      "Thi thử",
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
                            ElevatedButton(
                              onPressed: () {
                                gc.updateTestMode(TEST_TYPE.TEST);
                                Get.to(() => TestRestulScreen(
                                    testResults: snapshot.data!));
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
                                      "Lịch sử",
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
