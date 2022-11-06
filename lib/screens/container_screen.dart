import 'dart:async';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:sizer/sizer.dart';
import 'package:vnrdn_tai/controllers/auth_controller.dart';
import 'package:vnrdn_tai/controllers/cart_controller.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/controllers/maps_controller.dart';
import 'package:vnrdn_tai/controllers/my_tab_controller.dart';
import 'package:vnrdn_tai/controllers/question_controller.dart';
import 'package:vnrdn_tai/screens/analysis/analysis_screen.dart';
import 'package:vnrdn_tai/screens/auth/login_screen.dart';
import 'package:vnrdn_tai/screens/feedbacks/comments_screen.dart';
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
import 'package:vnrdn_tai/utils/dialogUtil.dart';
import 'package:vnrdn_tai/utils/io_utils.dart';
import 'package:vnrdn_tai/widgets/templated_buttons.dart';

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
        return const ChooseModeScreen();
      }
      return CategoryScreen();
    }
    if (v == TABS.ANALYSIS) {
      // return AnalysisScreen();
      // return SignsScreen();
      return const SearchSignScreen();
    }
    if (v == TABS.MINIMAP) {
      MapsController mapsController = Get.put(MapsController());
      return const MinimapScreen();
    }
  }

  getActionButton(v) {
    switch (v) {
      case TABS.ANALYSIS:
        return IconButton(
          onPressed: () {
            Get.to(AnalysisScreen());
          },
          icon: const Icon(
            Icons.camera_alt_rounded,
          ),
        );
      case TABS.MINIMAP:
        return IconButton(
          onPressed: () {
            Get.to(
              () => FeedbacksScreen(
                type: '',
              ),
            );
          },
          icon: const Icon(
            Icons.flag_rounded,
          ),
        );
      default:
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
    CartController cc = Get.put(CartController());
    String title = 'VNRDnTAI';
    final MyTabController _tabx = Get.put(MyTabController());

    return Scaffold(
      // backgroundColor: ThemeData().backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.black54,
          size: FONTSIZES.textHuge,
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.blueAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: kDefaultPaddingValue / 2),
            child: Obx(() => getActionButton(controller.tab.value)),
          ),
        ],
        actionsIconTheme: const IconThemeData(
          color: Colors.black54,
          size: FONTSIZES.textHuge,
        ),
      ),
      drawer: Drawer(
        elevation: 0,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 128, 179, 255),
              ),
              child: Column(children: [
                Center(
                  child: Stack(children: [
                    Image.asset("assets/images/logo.png", height: 72.0),
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
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: FONTSIZES.textPrimary),
                    ),
                    onTap: () {
                      handleLogout().then((value) {
                        if (value) {
                          Get.to(() => const LoginScreen());
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
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: FONTSIZES.textPrimary),
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
              title: const Text(
                'Cài đặt',
                style: TextStyle(
                  fontSize: FONTSIZES.textPrimary,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ), // Settings
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
              leading: const Icon(Icons.comment_rounded),
              title: const Text(
                'Bình luận',
                style: TextStyle(
                  fontSize: FONTSIZES.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ), // Feedbacks
              // selected: controller.sideBar.value == 2,
              selectedColor: Colors.white,
              selectedTileColor: Colors.blueAccent,
              onTap: () {
                if (controller.userId.isNotEmpty) {
                  Navigator.pop(context); // close the drawer
                  controller.updateSideBar(2);
                  Get.to(const CommentsScreen());
                } else {
                  DialogUtil.showTextDialog(
                    context,
                    "Cảnh báo",
                    "Bạn cần đăng nhập để tiếp tục.\nĐến trang đăng nhập?",
                    [
                      TemplatedButtons.yes(context, const LoginScreen()),
                      TemplatedButtons.no(context),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
      body: Center(child: Obx(() => getScreen(controller.tab.value))),
      bottomNavigationBar: Obx(
        () =>
            // CurvedNavigationBar(
            //   backgroundColor: kLightBlueBackground,
            //   color: Theme.of(context).primaryColor,
            //   index: controller.tab.value.index,
            //   items: <Widget>[
            //     Icon(
            //       controller.tab.value.index == 0
            //           ? Icons.menu_book_rounded
            //           : Icons.menu_book_outlined,
            //       size: 30,
            //       color: controller.tab.value.index == 0
            //           ? Color(0xFF3485FF)
            //           : Colors.black54,
            //     ),
            //     Icon(
            //       controller.tab.value.index == 1
            //           ? Icons.motorcycle_rounded
            //           : Icons.motorcycle_outlined,
            //       size: 30,
            //       color: controller.tab.value.index == 1
            //           ? Color(0xFF3485FF)
            //           : Colors.black54,
            //     ),
            //     Icon(
            //       controller.tab.value.index == 2
            //           ? Icons.remove_circle_rounded
            //           : Icons.remove_circle_outline,
            //       size: 30,
            //       color: controller.tab.value.index == 2
            //           ? Color(0xFF3485FF)
            //           : Colors.black54,
            //     ),
            //     Icon(
            //       controller.tab.value.index == 3
            //           ? Icons.map_rounded
            //           : Icons.map_outlined,
            //       size: 30,
            //       color: controller.tab.value.index == 3
            //           ? Color(0xFF3485FF)
            //           : Colors.black54,
            //     ),
            //   ],
            //   onTap: (index) {
            //     controller.updateTab(index);
            //   },
            // ),
            Container(
          height: 10.h,
          width: 100.w,
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
                top: BorderSide(
              color: Color(0xFFC0C0C0),
              width: 0.25,
            )),
            // borderRadius: BorderRadius.only(
            //     topRight: Radius.circular(30), topLeft: Radius.circular(30)),
            // boxShadow: [
            //   BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 10),
            // ],
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            unselectedItemColor: Colors.black54,
            elevation: 0,
            currentIndex: controller.tab.value.index,
            selectedItemColor: kBlueAccentBackground[800],
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
            iconSize: FONTSIZES.textHuge,
            unselectedFontSize: FONTSIZES.textMedium,
            selectedFontSize: FONTSIZES.textPrimary,
            onTap: (value) {
              controller.updateTab(value);
            },
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.menu_book_outlined),
                label: 'Luật',
                tooltip: 'Tra cứu Luật giao thông đường bộ',
                activeIcon: Icon(
                  Icons.menu_book_rounded,
                  size: FONTSIZES.textVeryHuge + 2,
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
                    size: FONTSIZES.textVeryHuge + 2,
                  ),
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.remove_circle_outline),
                label: 'Biển báo',
                tooltip: 'Tra cứu biển báo hiệu đường bộ',
                activeIcon: Padding(
                  padding: EdgeInsets.only(bottom: kDefaultPaddingValue / 4),
                  child: Icon(
                    Icons.remove_circle_rounded,
                    size: FONTSIZES.textVeryHuge + 2,
                  ),
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.map_outlined),
                label: 'Bản đồ',
                tooltip: 'Xem Bản đồ thời gian thực',
                activeIcon: Padding(
                  padding: EdgeInsets.only(bottom: kDefaultPaddingValue / 8),
                  child: Icon(
                    Icons.map_rounded,
                    size: FONTSIZES.textVeryHuge + 2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
