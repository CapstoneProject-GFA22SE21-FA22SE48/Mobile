import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:vnrdn_tai/controllers/search_controller.dart';
import 'package:vnrdn_tai/models/Keyword.dart';
import 'package:vnrdn_tai/models/Section.dart';
import 'package:vnrdn_tai/models/dtos/searchLawDTO.dart';
import 'package:vnrdn_tai/models/dtos/searchSignDTO.dart';
import 'package:vnrdn_tai/screens/search/components/search_bar.dart';
import 'package:vnrdn_tai/screens/search/components/search_list_item.dart';
import 'package:vnrdn_tai/services/KeywordService.dart';
import 'package:vnrdn_tai/services/LawService.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'package:vnrdn_tai/shared/snippets.dart';

class SearchSignListScreen extends StatefulWidget {
  SearchSignListScreen(
      {super.key, this.searchSignDTOList, this.futureSearchSignDTO});
  late List<SearchSignDTO>? searchSignDTOList;
  late Future<List<SearchSignDTO>>? futureSearchSignDTO;

  @override
  State<SearchSignListScreen> createState() => _SearchSignListScreenState();
}

class _SearchSignListScreenState extends State<SearchSignListScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SearchController sc = Get.put(SearchController());
    return Scaffold(
        body: SafeArea(
      child: FutureBuilder<List<SearchSignDTO>>(
          key: UniqueKey(),
          initialData: widget.searchSignDTOList,
          future: widget.futureSearchSignDTO,
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
                if (widget.futureSearchSignDTO != null) {
                  widget.searchSignDTOList = snapshot.data;
                }
                return KeyboardVisibilityBuilder(
                    builder: (context, isKeyboardVisible) {
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: kDefaultPaddingValue),
                          child: Obx(
                            () => SizedBox(
                              height: 4.h,
                              child: Text(
                                  'Có ${widget.searchSignDTOList!.length} kết quả tìm được liên quan đến ${sc.signCategory.value}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4
                                      ?.copyWith(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold,
                                          fontSize: FONTSIZES.textMedium)),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 100.w,
                          height: isKeyboardVisible ? 37.h : 62.h,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: kDefaultPaddingValue),
                            child: ListView.separated(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: widget.searchSignDTOList!.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: kDefaultPaddingValue),
                              itemBuilder: ((context, index) {
                                return ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: kDefaultPaddingValue / 2),
                                      backgroundColor: Colors.white,
                                      elevation: 5,
                                      shadowColor: Colors.grey.shade200,
                                      alignment: Alignment.center,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16.0))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(
                                        kDefaultPaddingValue / 4),
                                    child: SearchListItem(
                                        searchSignDTO:
                                            widget.searchSignDTOList![index]),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ),
                      ]);
                });
              }
            }
          }),
    ));
  }
}
