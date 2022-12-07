import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:loader_overlay/loader_overlay.dart';
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
import 'package:vnrdn_tai/screens/scribe/create-gpssign/create_gpssign_screen.dart';
import 'package:vnrdn_tai/screens/scribe/list_rom/list_rom_screen.dart';
import 'package:vnrdn_tai/screens/search/cart/cart_page.dart';
import 'package:vnrdn_tai/screens/search/law/search_law_screen.dart';
import 'package:vnrdn_tai/screens/search/sign/search_sign_screen.dart';
import 'package:vnrdn_tai/screens/settings/setting_screen.dart';
import 'package:vnrdn_tai/screens/welcome/welcome_screen.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'package:vnrdn_tai/utils/dialog_util.dart';
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
        return const ChooseModeScreen();
      }
      return const CategoryScreen();
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
      case TABS.SEARCH:
        return IconButton(
          onPressed: () {
            Get.to(AnalysisScreen());
          },
          icon: IconButton(
              icon: const Icon(Icons.receipt),
              onPressed: () {
                Get.to(() => const CartPage(), preventDuplicates: false);
              }),
        );
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
        if (controller.userId.isNotEmpty) {
          AuthController ac = Get.put(AuthController());
          return ac.role.value == 2
              ? IconButton(
                  onPressed: () {
                    Get.to(
                      () => LoaderOverlay(
                          child: FeedbacksScreen(
                        type: '',
                      )),
                    );
                  },
                  icon: const Icon(
                    Icons.flag_rounded,
                  ),
                )
              : IconButton(
                  onPressed: () {
                    Get.to(
                      () => LoaderOverlay(child: CreateGpssignScreen()),
                    );
                  },
                  icon: const Icon(
                    FontAwesomeIcons.circlePlus,
                  ),
                );
        } else {
          return Container();
        }
      default:
        return Container();
    }
  }

  Future<bool> handleLogout() async {
    IOUtils.clearUserInfoController();
    return await IOUtils.removeAllData();
  }

  getWelcomeName(AuthController ac) {
    if (ac.displayName.value.isEmpty) {
      if (controller.username.value.isEmpty) {
        return ac.email.value;
      }
      return controller.username.value;
    }
    return ac.displayName.value;
  }

  @override
  Widget build(BuildContext context) {
    AuthController ac = Get.put(AuthController());
    CartController cc = Get.put(CartController());
    String title = 'VNRDnTAI';
    final MyTabController _tabx = Get.put(MyTabController());

    return WillPopScope(
      onWillPop: () async {
        return await false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        extendBodyBehindAppBar: true,
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
        drawer: Obx(
          () => GFDrawer(
            elevation: 4,
            child: SizedBox(
              height: 100.h,
              child: Column(
                children: [
                  SizedBox(
                    height: 60.h,
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.zero,
                      children: [
                        DrawerHeader(
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 157, 196, 255),
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GFAvatar(
                                  radius: 10.w,
                                  backgroundImage: NetworkImage(
                                      ac.avatar.value.isNotEmpty
                                          ? ac.avatar.value
                                          : defaultAvatarUrl),
                                ),
                                controller.userId.value.isNotEmpty
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: kDefaultPaddingValue / 2),
                                        child: Text(
                                          getWelcomeName(ac),
                                          style: TextStyle(
                                            fontSize: FONTSIZES.textLarge,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.blueAccent.shade700,
                                          ),
                                        ),
                                      )
                                    : Container(),
                              ]),
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
                          ),
                          // Settings
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
                        ac.role.value == 2
                            ? ListTile(
                                iconColor: kWarningButtonColor,
                                textColor: kWarningButtonColor,
                                leading: const Icon(Icons.star_rounded),
                                title: const Text(
                                  'Đánh giá',
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
                                    DialogUtil.showAwesomeDialog(
                                        context,
                                        DialogType.warning,
                                        "Cảnh báo",
                                        "Bạn cần đăng nhập để tiếp tục.\nĐến trang đăng nhập?",
                                        () => Get.to(
                                              () => const LoaderOverlay(
                                                  child: LoginScreen()),
                                            ),
                                        () {});
                                  }
                                },
                              )
                            : Container(),
                        ac.role.value == 1 ||
                                controller.username.value.contains('scribe')
                            ? ListTile(
                                iconColor: kNeutralButtonColor,
                                textColor: kNeutralButtonColor,
                                leading:
                                    const Icon(Icons.content_paste_rounded),
                                title: const Text(
                                  'Danh sách yêu cầu',
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
                                    Navigator.pop(context);
                                    controller.updateSideBar(4);
                                    Get.to(ListRomScreen());
                                  }
                                },
                              )
                            : const SizedBox(),
                        const Divider(color: Colors.white),
                        controller.userId.isNotEmpty
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
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        // clearUserInfo();
                                        return const LoginScreen();
                                      },
                                    ),
                                  ); // close the drawer
                                },
                              ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: kDefaultPaddingValue / 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Stack(children: [
                            Image.asset(
                              "assets/images/logo.png",
                              scale: 8,
                            ),
                          ]),
                        ),
                        Container(
                          alignment: Alignment.bottomCenter,
                          padding: kDefaultPadding,
                          child: const Text(
                            'VNRDnTAI',
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: FONTSIZES.textHuge,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Center(child: Obx(() => getScreen(controller.tab.value))),
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            unselectedItemColor: Colors.black54,
            showUnselectedLabels: true,
            elevation: 0,
            currentIndex: controller.tab.value.index,
            selectedItemColor: Colors.blueAccent,
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
