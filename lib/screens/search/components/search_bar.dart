import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/screens/search/search_detail.dart';

class SearchBar extends GetView<GlobalController> {
  SearchBar({
    Key? key,
  }) : super(key: key);
  final TextEditingController _textController = TextEditingController();
  GlobalController gc = Get.find<GlobalController>();

  @override
  Widget build(BuildContext context) {
    _textController.text = gc.query.value;
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black)],
            borderRadius: BorderRadius.circular(5)),
        height: 10.h,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: TextField(
            onChanged: (value) {
              gc.updateQuery(value);
            },
            onSubmitted: (value) {
              Get.to(() => SearchDetailScreen(query: _textController.text));
            },
            controller: _textController,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  gc.updateQuery("");
                },
              ),
              enabledBorder: gc.query.value != null
                  ? InputBorder.none
                  : OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(color: Colors.orange, width: 5)),
              border: gc.query.value != null
                  ? InputBorder.none
                  : OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(color: Colors.orange, width: 5)),
              hintText: 'Tra cứu luật...',
            ),
          ),
        ));
  }
}
