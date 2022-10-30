import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:tiengviet/tiengviet.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/controllers/search_controller.dart';
import 'package:vnrdn_tai/models/Keyword.dart';
import 'package:vnrdn_tai/models/SignCategory.dart';
import 'package:vnrdn_tai/models/dtos/signCategoryDTO.dart';
import 'package:vnrdn_tai/screens/search/components/search_bar.dart';
import 'package:vnrdn_tai/screens/search/law/search_law_list.dart';
import 'package:vnrdn_tai/screens/search/sign/search_sign_list.dart';
import 'package:vnrdn_tai/services/SignService.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'package:vnrdn_tai/shared/snippets.dart';

class SearchSignScreen extends StatefulWidget {
  const SearchSignScreen({super.key});

  @override
  State<SearchSignScreen> createState() => _SearchSignScreenState();
}

class _SearchSignScreenState extends State<SearchSignScreen>
    with TickerProviderStateMixin {
  GlobalController gc = Get.find<GlobalController>();
  SearchController sc = Get.put(SearchController());
  late Future<List<SignCategoryDTO>> signCategories =
      SignService().GetSignCategoriesDTOList();

  final List<Color> listTabColors = <Color>[
    Colors.red,
    Colors.orangeAccent,
    Colors.blue.shade300,
    Colors.blueAccent.shade700,
    Colors.grey.shade800,
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TabController _tabController;
    return Scaffold(
        extendBodyBehindAppBar: true,
        body: SafeArea(
          child: FutureBuilder<List<SignCategoryDTO>>(
              key: UniqueKey(),
              future: signCategories,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return loadingScreen();
                } else {
                  if (snapshot.hasError) {
                    Future.delayed(
                        Duration.zero,
                        () => {
                              handleError(snapshot.error
                                  ?.toString()
                                  .replaceFirst('Exception:', ''))
                            });
                    throw Exception(snapshot.error);
                  } else {
                    _tabController = TabController(
                        length: snapshot.data!.length, vsync: this);
                    _tabController.index = sc.signCategoryNo.value;
                    return Obx(
                      () => Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              width: 100.w,
                              height: 6.h,
                              child: TabBar(
                                  controller: _tabController,
                                  isScrollable: true,
                                  onTap: (value) {
                                    sc.updateSignCategoryNo(value);
                                    sc.updateSignCategory(
                                        snapshot.data![value].name);
                                  },
                                  labelColor:
                                      listTabColors[_tabController.index],
                                  indicatorColor:
                                      listTabColors[_tabController.index],
                                  unselectedLabelColor: Colors.black54,
                                  labelStyle: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: FONTSIZES.textPrimary,
                                  ),
                                  unselectedLabelStyle: const TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: FONTSIZES.textMedium),
                                  tabs: snapshot.data!
                                      .map((signCategory) => Tab(
                                            text: signCategory.name,
                                          ))
                                      .toList()),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: kDefaultPaddingValue / 2,
                                horizontal: kDefaultPaddingValue,
                              ),
                              child: SearchBar(),
                            ),
                            SizedBox(
                              width: 100.w,
                              height: 66.h,
                              child: SearchSignListScreen(
                                searchSignDTOList: snapshot
                                    .data![sc.signCategoryNo.value]
                                    .searchSignDTOs
                                    .where((element) =>
                                        TiengViet.parse(element.description
                                                .trim()
                                                .toLowerCase())
                                            .contains(TiengViet.parse(sc.query.value
                                                .trim()
                                                .toLowerCase())) ||
                                        TiengViet.parse(element.name.trim().toLowerCase())
                                            .contains(TiengViet.parse(sc
                                                .query.value
                                                .trim()
                                                .toLowerCase())))
                                    .toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                }
              }),
        ));
  }
}
