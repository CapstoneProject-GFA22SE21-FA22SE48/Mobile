import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vnrdn_tai/controllers/auth_controller.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/controllers/question_controller.dart';
import 'package:vnrdn_tai/screens/analysis/analysis_screen.dart';
import 'package:vnrdn_tai/screens/auth/login_screen.dart';
import 'package:vnrdn_tai/screens/feedbacks/feedbacks_screen.dart';
import 'package:vnrdn_tai/screens/minimap/minimap_screen.dart';
import 'package:vnrdn_tai/screens/mock-test/category_screen.dart';
import 'package:vnrdn_tai/screens/mock-test/choose_mode_screen.dart';
import 'package:vnrdn_tai/screens/search/law/search_law_screen.dart';
import 'package:vnrdn_tai/screens/search/sign/search_sign_screen.dart';
import 'package:vnrdn_tai/screens/settings/setting_screen.dart';
import 'package:vnrdn_tai/screens/signs/signs_screen.dart';
import 'package:vnrdn_tai/screens/welcome/welcome_screen.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'package:vnrdn_tai/utils/io_utils.dart';

class ContainerScreen extends GetView<GlobalController> {
  const ContainerScreen({super.key});

  getScreen(v) {
    if (v == TABS.WELCOME) {
      return const WelcomeScreen();
    }
    if (v == TABS.LOGIN) {
      return const LoginScreen();
    }
    if (v == TABS.SEARCH) {
      return const SearchLawScreen();
    }
    if (v == TABS.MOCK_TEST) {
      QuestionController qc = Get.put(QuestionController());
      if (qc.testCategoryId.value.isNotEmpty) {
        return ChooseModeScreen();
      }
      return CategoryScreen();
    }
    if (v == TABS.ANALYSIS) {
      // return AnalysisScreen();
      // return SignsScreen();
      return const SearchSignScreen();
    }
    if (v == TABS.MINIMAP) {
      return const MinimapScreen();
    }
  }

  getActionButton(v) {
    if (v == TABS.ANALYSIS) {
      return GestureDetector(
        onTap: () {
          Get.to(AnalysisScreen());
        },
        child: const Icon(
          Icons.camera_alt_rounded,
        ),
      );
    } else {
      return Container();
    }
  }

  Future<bool> handleLogout() async {
    return await clearOnControllers();
  }

  clearOnControllers() {
    controller.updateUserId('');
    controller.updateUsername('');
    controller.updateTab(0);
    controller.updateSideBar(0);
    AuthController ac = Get.put(AuthController());
    ac.updateEmail('');
    ac.updateStatus(0);
    return true;
  }

  clearSharedPreferences() {
    //need change
    IOUtils.removeUserData(['Id']);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    AuthController ac = Get.put(AuthController());
    String title = 'VNRDnTAI';
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.only(right: kDefaultPaddingValue),
              child: Obx(() => getActionButton(controller.tab.value)),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(children: [
                Center(
                  child: Stack(children: [
                    Image.asset("assets/images/logo.png", height: 60.0),
                  ]),
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  padding: kDefaultPadding,
                  child: const Text(
                    'VNRDnTAI',
                    style: TextStyle(
                        color: Colors.white, fontSize: FONTSIZES.textHuge),
                  ),
                ),
              ]),
            ),
            controller.userId.value.isNotEmpty
                ? ListTile(
                    leading: const Icon(Icons.account_circle, size: 36),
                    title: Obx(() => Text(
                          'Xin chào, ${controller.username.value.isNotEmpty ? controller.username.value : ac.email.value}.',
                          style: const TextStyle(
                              fontSize: FONTSIZES.textMediumLarge),
                        )),
                    // enabled: false,
                    iconColor: kPrimaryTextColor,
                    textColor: kPrimaryTextColor,
                    onTap: () {
                      // Update the state of the app
                      // ...
                      Navigator.pop(context); // close the drawer
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        // clearUserInfo();
                        return const SettingsScreen();
                      }));
                    },
                  )
                : Container(),
            const Divider(color: Colors.white),
            controller.username.isNotEmpty
                ? ListTile(
                    iconColor: kDangerButtonColor,
                    textColor: kDangerButtonColor,
                    leading: const Icon(Icons.logout_rounded),
                    title: const Text(
                      'Đăng xuất',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      handleLogout().then((value) {
                        if (value) {
                          Get.to(LoginScreen());
                        }
                      }); // close the drawer
                    },
                  )
                : ListTile(
                    iconColor: kSuccessButtonColor,
                    textColor: kSuccessButtonColor,
                    leading: const Icon(Icons.login_rounded),
                    title: const Text(
                      'Đăng nhập',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      // Update the state of the app
                      // ...
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        // clearUserInfo();
                        return const LoginScreen();
                      })); // close the drawer
                    },
                  ),
            const Divider(
              thickness: 1,
              color: Color.fromRGBO(189, 189, 189, 1),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Cài đặt'), // Settings
              // selected: controller.sideBar.value == 1,
              selectedColor: Colors.white,
              selectedTileColor: Colors.blueAccent,
              onTap: () {
                // Update the state of the app
                // ...
                Navigator.pop(context); // close the drawer
                controller.updateSideBar(1);
                Get.to(const SettingsScreen());
              },
            ),
            // const Divider(
            //   thickness: 1,
            //   color: Colors.blueAccent,
            // ),
            ListTile(
              iconColor: kWarningButtonColor,
              textColor: kWarningButtonColor,
              leading: const Icon(Icons.flag_rounded),
              title: const Text('Phản hồi'), // Feedbacks
              // selected: controller.sideBar.value == 2,
              selectedColor: Colors.white,
              selectedTileColor: Colors.blueAccent,
              onTap: () {
                Navigator.pop(context); // close the drawer
                controller.updateSideBar(2);
                Get.to(const FeedbacksScreen());
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(child: getScreen(controller.tab.value)),
      ),
      bottomNavigationBar: SizedBox(
        height: 80,
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(30), topLeft: Radius.circular(30)),
            boxShadow: [
              BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 10),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu_book_outlined),
                  label: 'Tra cứu luật',
                  tooltip: 'Tra cứu Luật giao thông đường bộ',
                  activeIcon: Icon(
                    Icons.menu_book_rounded,
                    size: FONTSIZES.textVeryHuge,
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.motorcycle_outlined),
                  label: 'GPLX',
                  tooltip: 'Ôn và Thi thử Sát hạch giấy phép lái xe',
                  activeIcon: Padding(
                    padding: EdgeInsets.only(bottom: kDefaultPaddingValue / 8),
                    child: Icon(
                      Icons.motorcycle_rounded,
                      size: FONTSIZES.textVeryHuge,
                    ),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.warning_amber_outlined),
                  label: 'Biển báo',
                  tooltip: 'Tra cứu biển báo hiệu đường bộ',
                  activeIcon: Icon(
                    Icons.warning_rounded,
                    size: FONTSIZES.textVeryHuge,
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.map_outlined),
                  label: 'Bản đồ',
                  tooltip: 'Xem Bản đồ thời gian thực',
                  activeIcon: Icon(
                    Icons.map_rounded,
                    size: FONTSIZES.textVeryHuge,
                  ),
                ),
              ],
              currentIndex: controller.tab.value.index,
              selectedItemColor: Colors.blueAccent[800],
              onTap: (value) {
                controller.updateTab(value);
              },
            ),
          ),
        ),
      ),
    );
  }
}
