import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/models/Keyword.dart';
import 'package:vnrdn_tai/screens/search/components/search_bar.dart';
import 'package:vnrdn_tai/services/KeywordService.dart';
import 'package:vnrdn_tai/shared/snippets.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late Future<List<Keyword>> keywords = KeywordSerivce().GetKeywordList();
  final List<IconData> iconData = <IconData>[
    Icons.call,
    Icons.school,
    Icons.abc,
    Icons.alarm,
    Icons.back_hand,
    Icons.cabin,
    Icons.dangerous,
    Icons.e_mobiledata,
    Icons.face,
    Icons.gamepad,
    Icons.hail,
    Icons.ice_skating
  ];
  @override
  Widget build(BuildContext context) {
    GlobalController gc = Get.find<GlobalController>();
    gc.updateQuery(null);
    return Scaffold(
        extendBodyBehindAppBar: true,
        body: SafeArea(
          child: FutureBuilder<List<Keyword>>(
              key: UniqueKey(),
              future: keywords,
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
                    return Center(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SearchBar(),
                            Divider(),
                            Container(
                              width: double.infinity,
                              height: 60.h,
                              child: GridView.count(
                                crossAxisCount: 3,
                                children: List.generate(snapshot.data!.length,
                                    (index) {
                                  return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                            iconSize: 64,
                                            onPressed: () {},
                                            color: Colors.primaries[Random()
                                                .nextInt(
                                                    Colors.primaries.length)],
                                            icon: Icon(iconData[index])),
                                        Text('${snapshot.data![index].name}',
                                            maxLines: 2),
                                      ]);
                                }),
                              ),
                            ),
                          ]),
                    );
                  }
                }
              }),
        ));
  }
}
