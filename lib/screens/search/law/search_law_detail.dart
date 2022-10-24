import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:vnrdn_tai/controllers/search_controller.dart';
import 'package:vnrdn_tai/models/dtos/searchLawDTO.dart';
import 'package:vnrdn_tai/screens/search/components/search_bar.dart';
import 'package:vnrdn_tai/screens/search/components/search_list_item.dart';
import 'package:vnrdn_tai/services/LawService.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'package:vnrdn_tai/shared/snippets.dart';

class SearchLawDetailScreen extends StatefulWidget {
  SearchLawDetailScreen({super.key, required this.query});
  late String query;

  @override
  State<SearchLawDetailScreen> createState() => _SearchLawDetailScreen();
}

class _SearchLawDetailScreen extends State<SearchLawDetailScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SearchController sc = Get.put(SearchController());
    late Future<List<SearchLawDTO>> searchRes = LawSerivce()
        .GetSearchListByQuery(widget.query, sc.vehicleCategory.value);
    return Scaffold(
        body: SafeArea(
            child: Center(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            AppBar(
              title: SearchBar(),
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(color: Colors.black),
            ),
            const Divider(),
            Text('',
                style: Theme.of(context).textTheme.headline4?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: FONTSIZES.textMedium)),
            SizedBox(
              width: 100.w,
              height: 80.h,
              child: ListView.separated(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  separatorBuilder: (context, index) =>
                      SizedBox(height: kDefaultPaddingValue),
                  itemBuilder: ((context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(),
                    );
                  }),
                  itemCount: 3),
            ),
          ]),
    )));
  }
}
