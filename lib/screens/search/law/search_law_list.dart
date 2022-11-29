import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:tiengviet/tiengviet.dart';
import 'package:vnrdn_tai/controllers/search_controller.dart';
import 'package:vnrdn_tai/models/dtos/searchLawDTO.dart';
import 'package:vnrdn_tai/screens/container_screen.dart';
import 'package:vnrdn_tai/screens/search/cart/cart_page.dart';
import 'package:vnrdn_tai/screens/search/components/search_bar.dart';
import 'package:vnrdn_tai/screens/search/components/search_list_item.dart';
import 'package:vnrdn_tai/screens/search/law/search_law_detail.dart';
import 'package:vnrdn_tai/services/LawService.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'package:vnrdn_tai/shared/snippets.dart';

class SearchLawListScreen extends StatefulWidget {
  SearchLawListScreen({super.key, this.query, this.keywordId});
  late String? query;
  late String? keywordId;

  @override
  State<SearchLawListScreen> createState() => _SearchLawListScreenState();
}

class _SearchLawListScreenState extends State<SearchLawListScreen> {
  @override
  void initState() {
    super.initState();
  }

  findMatch(SearchController sc) async {
    final String response = await rootBundle.loadString('assets/dict.json');
    final data = await json.decode(response);
    var query = TiengViet.parse(sc.query.value);

    for (final name in data.keys) {
      final value = data[name];
      if (sc.query.value == value) {
        return "";
      }
      if (query == name) {
        return value;
      }
    }
    for (final name in data.keys) {
      final value = data[name];
      if (query.contains(name)) {
        return value;
      }
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    SearchController sc = Get.put(SearchController());
    late Future<List<SearchLawDTO>> searchRes = widget.query != null
        ? LawSerivce()
            .GetSearchListByQuery(widget.query!, sc.vehicleCategory.value)
        : LawSerivce().GetSearchListByKeywordId(
            widget.keywordId!, sc.vehicleCategory.value);
    return WillPopScope(
      onWillPop: () async {
        sc.updateQuery("");
        Get.to(() => ContainerScreen());
        return await true;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text("${sc.vehicleCategory.value.capitalizeFirst}"),
          actions: [
            IconButton(
                icon: const Icon(Icons.receipt),
                onPressed: () {
                  Get.to(() => const CartPage(), preventDuplicates: false);
                }),
          ],
        ),
        body: SafeArea(
          child: FutureBuilder<List<SearchLawDTO>>(
            key: UniqueKey(),
            future: searchRes,
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
                  return KeyboardVisibilityBuilder(
                    builder: (context, isKeyboardVisible) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: kDefaultPaddingValue / 2,
                              horizontal: kDefaultPaddingValue,
                            ),
                            child: SearchBar(),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: kDefaultPaddingValue),
                            child: Text(
                                'Có ${snapshot.data!.length} kết quả được tìm thấy',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4
                                    ?.copyWith(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold,
                                        fontSize: FONTSIZES.textPrimary)),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: kDefaultPaddingValue,
                                vertical: kDefaultPaddingValue / 2),
                            child: FutureBuilder<dynamic>(
                                future: findMatch(sc),
                                builder: (context, snapshot) {
                                  if (snapshot.data != "") {
                                    return RichText(
                                        text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Có phải bạn muốn tìm: ',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4
                                              ?.copyWith(
                                                  color: Colors.black54,
                                                  fontStyle: FontStyle.italic,
                                                  fontSize:
                                                      FONTSIZES.textMedium),
                                        ),
                                        TextSpan(
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4
                                              ?.copyWith(
                                                  color: Colors.blue,
                                                  fontStyle: FontStyle.italic,
                                                  fontSize:
                                                      FONTSIZES.textMedium),
                                          text: snapshot.data,
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () async {
                                              sc.updateQuery(snapshot.data);
                                              if (snapshot.data.trim().length >
                                                  0) {
                                                Get.to(
                                                    () => SearchLawListScreen(
                                                        query: snapshot.data),
                                                    preventDuplicates: false);
                                              }
                                            },
                                        ),
                                      ],
                                    ));
                                  } else {
                                    return Container();
                                  }
                                }),
                          ),
                          SizedBox(
                            width: 100.w,
                            height: isKeyboardVisible ? 38.5.h : 77.h,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: kDefaultPaddingValue,
                              ),
                              child: ListView.separated(
                                itemCount: snapshot.data!.length,
                                scrollDirection: Axis.vertical,
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(
                                        height: kDefaultPaddingValue),
                                itemBuilder: ((context, index) {
                                  return ElevatedButton(
                                    onPressed: () {
                                      Get.to(() => SearchLawDetailScreen(
                                          searchLawDto: snapshot.data![index]));
                                    },
                                    style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: kDefaultPaddingValue / 2),
                                        backgroundColor: Colors.white,
                                        // elevation: 5,
                                        shadowColor: Colors.grey.shade200,
                                        alignment: Alignment.center,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16.0))),
                                    child: Padding(
                                      padding: const EdgeInsets.all(
                                          kDefaultPaddingValue / 4),
                                      child: SearchListItem(
                                          searchLawDto: snapshot.data![index]),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }
              }
            },
          ),
        ),
      ),
    );
  }
}
