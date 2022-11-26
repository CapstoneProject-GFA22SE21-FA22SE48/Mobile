import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:vnrdn_tai/controllers/search_controller.dart';
import 'package:vnrdn_tai/models/Paragraph.dart';
import 'package:vnrdn_tai/models/dtos/searchSignDTO.dart';
import 'package:vnrdn_tai/screens/search/components/search_bar.dart';
import 'package:vnrdn_tai/screens/search/components/search_list_item.dart';
import 'package:vnrdn_tai/services/LawService.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'package:sizer/sizer.dart';
import 'package:vnrdn_tai/shared/snippets.dart';

class SearchSignDetailScreen extends StatefulWidget {
  SearchSignDetailScreen({super.key, this.searchSignDto});
  late SearchSignDTO? searchSignDto;

  @override
  State<SearchSignDetailScreen> createState() => _SearchSignDetailScreen();
}

class _SearchSignDetailScreen extends State<SearchSignDetailScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    NumberFormat numberFormat =
        NumberFormat.currency(locale: 'vi_VN', symbol: "");
    var min = "";
    var max = "";
    SearchController sc = Get.put(SearchController());

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Chi tiết biển báo"),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 100.w,
              height: 90.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(kDefaultPaddingValue),
                    child: Container(
                      width: 100.w,
                      height: 54.h,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(
                              kDefaultPaddingValue,
                            ),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade200,
                              spreadRadius: 2,
                              blurRadius: 4,
                            )
                          ]),
                      padding: const EdgeInsets.symmetric(
                        vertical: kDefaultPaddingValue,
                        horizontal: kDefaultPaddingValue,
                      ),
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Container(
                          width: 90.w,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text.rich(
                              TextSpan(children: [
                                TextSpan(
                                  text: "${widget.searchSignDto!.name}.",
                                  style: const TextStyle(
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: FONTSIZES.textLarge,
                                  ),
                                ),
                                WidgetSpan(
                                  child: Divider(
                                    height: 3.h,
                                    color: Colors.grey.shade300,
                                    endIndent: 60.w,
                                    thickness: 3,
                                  ),
                                ),
                                WidgetSpan(
                                  child: Container(
                                    width: 80.w,
                                    padding: const EdgeInsets.only(
                                        bottom: kDefaultPaddingValue),
                                    child: const Text(
                                      "Mô tả chi tiết: ",
                                      maxLines: 5,
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold,
                                          fontSize: FONTSIZES.textMediumLarge),
                                    ),
                                  ),
                                ),
                                WidgetSpan(
                                    child: ExpandableText(
                                  widget.searchSignDto!.description,
                                  expandText: 'Xem thêm',
                                  collapseText: 'Thu nhỏ',
                                  maxLines: 5,
                                  linkColor: Colors.blueAccent,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: FONTSIZES.textPrimary,
                                  ),
                                )),
                                WidgetSpan(
                                    child: Container(
                                  color: Colors.transparent,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: kDefaultPaddingValue / 2,
                                  ),
                                )),
                                WidgetSpan(
                                  child: Container(
                                    width: 80.w,
                                    padding: const EdgeInsets.only(
                                        bottom: kDefaultPaddingValue),
                                    child: const Text(
                                      "Hình ảnh: ",
                                      maxLines: 5,
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold,
                                          fontSize: FONTSIZES.textMediumLarge),
                                    ),
                                  ),
                                ),
                                WidgetSpan(
                                    child: Container(
                                  alignment: Alignment.center,
                                  color: Colors.transparent,
                                  child: SizedBox(
                                    height: 30.h,
                                    width: 50.w,
                                    child: Image.network(
                                      widget.searchSignDto!.imageUrl as String,
                                      fit: BoxFit.scaleDown,
                                      alignment: Alignment.center,
                                    ),
                                  ),
                                )),
                              ]),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // const Divider(),
                  widget.searchSignDto!.searchLawDTOs!.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: kDefaultPaddingValue),
                          child: SizedBox(
                            width: 100.w,
                            height: 30.h,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(
                                      kDefaultPaddingValue,
                                    ),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade200,
                                      spreadRadius: 2,
                                      blurRadius: 4,
                                    )
                                  ]),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                              text: "Hành vi liên quan: ",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline3
                                                  ?.copyWith(
                                                      color: Colors.orange,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      // fontStyle:
                                                      //     FontStyle.italic,
                                                      // decoration: TextDecoration
                                                      //     .underline,
                                                      fontSize:
                                                          FONTSIZES.textLarge))
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: SizedBox(
                                        width: 100.w,
                                        height: 20.h,
                                        child: ListView.separated(
                                            scrollDirection: Axis.vertical,
                                            physics:
                                                const BouncingScrollPhysics(),
                                            shrinkWrap: true,
                                            separatorBuilder:
                                                (context, index) => const SizedBox(
                                                    height:
                                                        kDefaultPaddingValue),
                                            itemBuilder: ((context, index) {
                                              return SearchListItem(
                                                searchLawDto: widget
                                                    .searchSignDto!
                                                    .searchLawDTOs![index],
                                              );
                                            }),
                                            itemCount: widget.searchSignDto!
                                                .searchLawDTOs!.length),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      : Container()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
