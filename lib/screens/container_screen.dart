import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/screens/mock-test/choose_mode_screen.dart';
import 'package:vnrdn_tai/screens/mock-test/question_screen.dart';
import 'package:vnrdn_tai/screens/search/search_screen.dart';
import 'package:vnrdn_tai/shared/constants.dart';

class ContainerScreen extends GetView<GlobalController> {
  const ContainerScreen({super.key});

  getScreen(v) {
    if (v == TABS.SEARCH) {
      return SearchScreen();
    }
    if (v == TABS.MOCK_TEST) {
      return ChooseModeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Obx(() => Padding(
          padding: const EdgeInsets.all(50.0),
          child: Center(child: getScreen(controller.tab.value)),
        )),
        bottomNavigationBar: Obx(() => BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: 'Tra cứu luật',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.pending_actions),
                  label: 'Thi thử bằng lái',
                ),
              ],
              currentIndex: controller.tab.value.index,
              selectedItemColor: Colors.amber[800],
              onTap: (value) {
                controller.updateTab(value);
              },
            )));
  }
}
