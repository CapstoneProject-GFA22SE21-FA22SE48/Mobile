import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
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
    print(widget.searchSignDto?.searchLawDTOs);
    return Scaffold(
        body: SafeArea(
            child: Center(
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: <
          Widget>[
        AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        const Divider(),
        SizedBox(
          width: 100.w,
          height: 80.h,
          child: Padding(
            padding: const EdgeInsets.all(0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                width: 100.w,
                height: 50.h,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: kDefaultPaddingValue),
                  child: SingleChildScrollView(
                    child: Container(
                      color: Colors.grey.shade300,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text.rich(TextSpan(children: [
                          TextSpan(
                              text: "${widget.searchSignDto!.name}.",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4
                                  ?.copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: FONTSIZES.textMediumLarge)),
                          WidgetSpan(
                              child: Container(
                            color: Colors.grey.shade300,
                            padding: EdgeInsets.all(8.0),
                          )),
                          WidgetSpan(
                              child: ExpandableText(
                            "${widget.searchSignDto!.description}",
                            expandText: 'xem thêm',
                            collapseText: 'thu nhỏ',
                            maxLines: 5,
                            linkColor: Colors.blue,
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                ?.copyWith(
                                    color: Colors.black,
                                    fontSize: FONTSIZES.textMedium),
                          )),
                          WidgetSpan(
                              child: Container(
                            color: Colors.grey.shade300,
                            padding: EdgeInsets.all(4.0),
                          )),
                          WidgetSpan(
                              child: Container(
                            color: Colors.grey.shade300,
                            padding: EdgeInsets.all(4.0),
                            child: Column(
                              children: [
                                Divider(
                                  color: Colors.black,
                                ),
                                SizedBox(
                                  height: 30.h,
                                  width: 50.w,
                                  child: Image.network(
                                    widget.searchSignDto!.imageUrl as String,
                                    fit: BoxFit.scaleDown,
                                  ),
                                )
                              ],
                            ),
                          )),
                        ])),
                      ),
                    ),
                  ),
                ),
              ),
              const Divider(),
              widget.searchSignDto!.searchLawDTOs!.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: kDefaultPaddingValue),
                      child: SizedBox(
                        width: 100.w,
                        height: 25.h,
                        child: Container(
                            color: Colors.white70,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text.rich(TextSpan(children: [
                                    TextSpan(
                                        text: "Hành vi liên quan: ",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline3
                                            ?.copyWith(
                                                color: Colors.orange,
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic,
                                                decoration:
                                                    TextDecoration.underline,
                                                fontSize: FONTSIZES.textLarge))
                                  ])),
                                  Expanded(
                                    child: SizedBox(
                                      width: 100.w,
                                      height: 20.h,
                                      child: ListView.separated(
                                          scrollDirection: Axis.vertical,
                                          shrinkWrap: true,
                                          separatorBuilder: (context, index) =>
                                              SizedBox(
                                                  height: kDefaultPaddingValue),
                                          itemBuilder: ((context, index) {
                                            return SearchListItem(
                                                searchLawDto: widget
                                                    .searchSignDto!
                                                    .searchLawDTOs![index]);
                                          }),
                                          itemCount: widget.searchSignDto!
                                              .searchLawDTOs!.length),
                                    ),
                                  )
                                ],
                              ),
                            )),
                      ),
                    )
                  : Container()
            ]),
          ),
        ),
      ]),
    )));
  }
}
