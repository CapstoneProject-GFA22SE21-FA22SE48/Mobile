import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/screens/analysis/analysis_screen.dart';
import 'package:vnrdn_tai/screens/minimap/minimap_screen.dart';
import 'package:vnrdn_tai/screens/mock-test/choose_mode_screen.dart';
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
    if (v == TABS.ANALYSIS) {
      return AnalysisScreen();
    }
    if (v == TABS.MINIMAP) {
      return MinimapScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Obx(() => Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(child: getScreen(controller.tab.value)),
            )),
        bottomNavigationBar: Obx(() => SizedBox(
          height: 70,
          child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.search),
                    label: 'Tra cứu luật',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.pending_actions),
                    label: 'Thi thử \nbằng lái',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.warning),
                    label: 'Tra cứu \nbiển báo',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.map),
                    label: 'Bản đồ',
                  ),
                ],
                currentIndex: controller.tab.value.index,
                selectedItemColor: Colors.amber[800],
                onTap: (value) {
                  controller.updateTab(value);
                },
              ),
        )));
  }
}
