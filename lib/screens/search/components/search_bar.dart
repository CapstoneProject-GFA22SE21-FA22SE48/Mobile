import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/controllers/search_controller.dart';
import 'package:vnrdn_tai/screens/search/law/search_list.dart';

class SearchBar extends GetView<GlobalController> {
  SearchBar({
    Key? key,
  }) : super(key: key);
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    GlobalController gc = Get.find<GlobalController>();
    SearchController sc = Get.put(SearchController());

    _textController.text = gc.query.value;
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: const [BoxShadow(color: Colors.black)],
            borderRadius: BorderRadius.circular(5)),
        child: Obx(
          () => Padding(
            padding: const EdgeInsets.all(0),
            child: TextField(
              onChanged: (value) {
                gc.updateQuery(value);
              },
              onSubmitted: (value) {
                Get.to(() => SearchListScreen(query: _textController.text));
              },
              controller: _textController,
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.blueAccent,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.clear,
                    color: Colors.blueAccent,
                  ),
                  onPressed: () {
                    gc.updateQuery("");
                  },
                ),
                enabledBorder: gc.query.value.isNotEmpty
                    ? InputBorder.none
                    : OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                            color: Colors.blueAccent, width: 1)),
                border: gc.query.value.isNotEmpty
                    ? InputBorder.none
                    : OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                            color: Colors.blueAccent, width: 1)),
                hintText: 'Tra cứu luật của ${(sc.vehicleCategory.value)}...',
                hintStyle: TextStyle(color: Colors.blueAccent.shade200),
                fillColor: Colors.blueAccent,
              ),
            ),
          ),
        ));
  }
}
