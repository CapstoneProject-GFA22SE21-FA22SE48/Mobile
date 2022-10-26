import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
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

class _SearchSignScreenState extends State<SearchSignScreen> {
  GlobalController gc = Get.find<GlobalController>();
  SearchController sc = Get.put(SearchController());
  late Future<List<SignCategoryDTO>> signCategories =
      SignService().GetSignCategoriesDTOList();

  final List<IconData> iconData = <IconData>[
    Icons.dangerous_outlined,
    Icons.turn_right,
    Icons.perm_device_info,
    Icons.speed,
    Icons.fire_truck,
    Icons.local_parking,
    Icons.swap_vert,
    Icons.train,
    Icons.shop,
    Icons.invert_colors,
    Icons.style,
    Icons.ice_skating
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                    sc.updateSignCategoryNo(0);
                    sc.updateSignCategory(snapshot.data![0].name);
                    return Obx(
                      () => Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            DefaultTabController(
                                initialIndex: sc.signCategoryNo.value,
                                length: snapshot.data!.length,
                                child: SizedBox(
                                  width: 100.w,
                                  height: 8.h,
                                  child: TabBar(
                                      isScrollable: true,
                                      onTap: (value) {
                                        sc.updateSignCategoryNo(value);
                                        sc.updateSignCategory(
                                            snapshot.data![value].name);
                                      },
                                      indicatorColor: Colors.grey,
                                      labelColor: Colors.blue,
                                      unselectedLabelColor: Colors.black,
                                      tabs: snapshot.data!
                                          .map((signCategory) => Tab(
                                                text: signCategory.name,
                                              ))
                                          .toList()),
                                )),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 6.0),
                              child: SearchBar(),
                            ),
                            SizedBox(
                              width: 100.w,
                              height: 52.h,
                              child: SearchSignListScreen(
                                searchSignDTOList: snapshot
                                    .data![sc.signCategoryNo.value]
                                    .searchSignDTOs
                                    .where((element) => element.description
                                        .contains(sc.query.value))
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
