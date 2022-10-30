import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/controllers/search_controller.dart';
import 'package:vnrdn_tai/screens/search/law/search_law_list.dart';
import 'package:vnrdn_tai/shared/constants.dart';

class SearchBar extends GetView<GlobalController> {
  SearchBar({
    Key? key,
  }) : super(key: key);
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    GlobalController gc = Get.find<GlobalController>();
    SearchController sc = Get.put(SearchController());
    _textController.text = sc.query.value;

    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        return Container(
            decoration: BoxDecoration(
                // border: Border.all(
                //   color: isKeyboardVisible ? Colors.blueAccent : Colors.grey,
                //   width: 2,
                // ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    spreadRadius: 3,
                    blurRadius: 5,
                  )
                ],
                color: Colors.white,
                borderRadius: BorderRadius.circular(20)),
            child: Obx(
              () => Padding(
                padding: const EdgeInsets.all(0),
                child: TextField(
                  onChanged: (value) {
                    // sc.updateQuery(value);
                  },
                  onSubmitted: (value) {
                    sc.updateQuery(_textController.text);
                    if (gc.tab.value == TABS.SEARCH) {
                      if (_textController.text.trim().length > 0) {
                        Get.to(
                            () => SearchLawListScreen(
                                query: _textController.text),
                            preventDuplicates: false);
                      }
                    }
                  },
                  controller: _textController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.search,
                      color:
                          isKeyboardVisible ? Colors.blueAccent : Colors.grey,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.clear,
                        color:
                            isKeyboardVisible ? Colors.blueAccent : Colors.grey,
                      ),
                      onPressed: () {
                        if (_textController.text.isNotEmpty) {
                          sc.updateQuery("");
                          _textController.text = sc.query.value;
                        }
                      },
                    ),
                    hintText: gc.tab.value == TABS.SEARCH
                        ? 'Tra cứu luật của ${(sc.vehicleCategory.value)}...'
                        : 'Tra cứu các ${(sc.signCategory.value)}...',
                    hintStyle: TextStyle(
                        color: isKeyboardVisible
                            ? Colors.blueAccent.shade200
                            : Colors.black54),
                    fillColor: Colors.blueAccent,
                  ),
                ),
              ),
            ));
      },
    );
  }
}
