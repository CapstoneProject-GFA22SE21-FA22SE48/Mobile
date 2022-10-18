import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/screens/analysis/analysis_screen.dart';
import 'package:vnrdn_tai/screens/auth/login_screen.dart';
import 'package:vnrdn_tai/screens/minimap/minimap_screen.dart';
import 'package:vnrdn_tai/screens/mock-test/choose_mode_screen.dart';
import 'package:vnrdn_tai/screens/search/search_screen.dart';
import 'package:vnrdn_tai/screens/welcome/welcome_screen.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'package:vnrdn_tai/utils/future_builder_util.dart';
import 'package:vnrdn_tai/widgets/custom_paint.dart';

class ContainerScreen extends GetView<GlobalController> {
  const ContainerScreen({super.key});

  getScreen(v) {
    if (v == TABS.WELCOME) {
      return WelcomeScreen();
    }
    if (v == TABS.LOGIN) {
      return LoginScreen();
    }
    if (v == TABS.SEARCH) {
      return SearchScreen();
    }
    if (v == TABS.MOCK_TEST) {
      return ChooseModeScreen();
    }
    if (v == TABS.ANALYSIS) {
      return AnalysisScreen();
    }
    if (v == TABS.MINIMAP) {
      return MinimapScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    String title = 'VNRDnTAI';
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
          centerTitle: true,
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Center(
                    child: Text(
                  'VNRDnTAI',
                  style: TextStyle(
                      color: Colors.black12, fontSize: FONTSIZES.textHuge),
                )),
              ),
              ListTile(
                leading: const Icon(Icons.account_circle),
                title: const Text('Profile'),
                autofocus: true,
                selected: true,
                onTap: () {
                  // Update the state of the app
                  // ...
                  Navigator.pop(context); // close the drawer
                },
              ),
              // const Divider(
              //   thickness: 1,
              //   color: Colors.blueAccent,
              // ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  Navigator.pop(context); // close the drawer
                },
              ),
              const Divider(
                thickness: 1,
                color: Color.fromRGBO(189, 189, 189, 1),
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    // clearUserInfo();
                    return const LoginScreen();
                  })); // close the drawer
                },
              ),

              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  Navigator.pop(context); // close the drawer
                },
              ),
            ],
          ),
        ),
        body: Obx(() => Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(child: getScreen(controller.tab.value)),
            )),
        bottomNavigationBar: Obx(() => SizedBox(
            height: 80,
            child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12, spreadRadius: 0, blurRadius: 10),
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
                        icon: Icon(Icons.task_outlined),
                        label: 'Thi thử',
                        tooltip: 'Ôn và Thi thử Sát hạch bằng lái xe',
                        activeIcon: Icon(
                          Icons.task_rounded,
                          size: FONTSIZES.textVeryHuge,
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
                )))));
  }
}
