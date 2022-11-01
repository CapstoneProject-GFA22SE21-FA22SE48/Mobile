import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/models/dtos/searchLawDTO.dart';
import 'package:vnrdn_tai/services/LawService.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'package:vnrdn_tai/shared/snippets.dart';

class SearchLawDetailScreen extends StatefulWidget {
  SearchLawDetailScreen(
      {super.key, this.searchLawDto, this.futureSearchLawDto});
  late SearchLawDTO? searchLawDto;
  late Future<SearchLawDTO>? futureSearchLawDto;

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
    GlobalController gc = Get.find<GlobalController>();
    NumberFormat numberFormat =
        NumberFormat.currency(locale: 'vi_VN', symbol: "");
    var min = "";
    var max = "";
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: const Text("Chi tiết"),
        ),
        body: SafeArea(
            child: FutureBuilder<SearchLawDTO>(
                key: UniqueKey(),
                initialData: widget.searchLawDto,
                future: widget.futureSearchLawDto,
                builder: (context, snapshot) {
                  if (widget.futureSearchLawDto != null &&
                      snapshot.connectionState == ConnectionState.waiting) {
                    return loadingScreen();
                  } else {
                    if (widget.futureSearchLawDto != null) {
                      widget.searchLawDto = snapshot.data;
                    }
                    min = numberFormat
                        .format(double.parse(widget.searchLawDto!.minPenalty));
                    max = numberFormat
                        .format(double.parse(widget.searchLawDto!.maxPenalty));
                    return Center(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            const Divider(),
                            SizedBox(
                              width: 100.w,
                              height: 80.h,
                              child: Padding(
                                padding: const EdgeInsets.all(0),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 100.w,
                                        height: widget
                                                    .searchLawDto!
                                                    .referenceParagraph!
                                                    .isNotEmpty &&
                                                gc.tab.value == TABS.SEARCH
                                            ? 50.h
                                            : 70.h,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: kDefaultPaddingValue),
                                          child: SingleChildScrollView(
                                            child: Container(
                                              height: 100.h,
                                              color: Colors.grey.shade300,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text.rich(
                                                    TextSpan(children: [
                                                  TextSpan(
                                                      text:
                                                          "${widget.searchLawDto!.statueDesc}.",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline4
                                                          ?.copyWith(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              fontSize: FONTSIZES
                                                                  .textMedium)),
                                                  WidgetSpan(
                                                      child: Container(
                                                    color: Colors.grey.shade300,
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                  )),
                                                  WidgetSpan(
                                                      child: ExpandableText(
                                                    "${widget.searchLawDto!.paragraphDesc?.replaceAll('\\', '')}",
                                                    expandText: 'Xem thêm',
                                                    collapseText: 'Thu nhỏ',
                                                    maxLines: 5,
                                                    linkColor: Colors.blue,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline4
                                                        ?.copyWith(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: FONTSIZES
                                                                .textMediumLarge),
                                                  )),
                                                  WidgetSpan(
                                                      child: Container(
                                                    color: Colors.grey.shade300,
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
                                                  )),
                                                  TextSpan(
                                                      text:
                                                          "Phạt tiền từ ${min}đến ${max}nghìn đồng",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline3
                                                          ?.copyWith(
                                                              color: Colors.red,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: FONTSIZES
                                                                  .textMediumLarge)),
                                                  WidgetSpan(
                                                      child: Container(
                                                    color: Colors.grey.shade300,
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    child: const Divider(
                                                      color: Colors.black,
                                                    ),
                                                  )),
                                                  TextSpan(
                                                      text: widget.searchLawDto!
                                                                  .additionalPenalty !=
                                                              ""
                                                          ? "Hình phạt bổ sung: "
                                                          : "",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline3
                                                          ?.copyWith(
                                                              color: Colors
                                                                  .lightBlue,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: FONTSIZES
                                                                  .textMediumLarge)),
                                                  WidgetSpan(
                                                      child: Container(
                                                    color: Colors.grey.shade300,
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                  )),
                                                  TextSpan(
                                                      text:
                                                          "${widget.searchLawDto!.additionalPenalty?.replaceAll('\\', '')}",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline3
                                                          ?.copyWith(
                                                              color:
                                                                  Colors.black,
                                                              fontStyle:
                                                                  FontStyle
                                                                      .italic,
                                                              fontSize: FONTSIZES
                                                                  .textMedium))
                                                ])),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Divider(),
                                      widget.searchLawDto!.referenceParagraph!
                                                  .isNotEmpty &&
                                              gc.tab.value == TABS.SEARCH
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal:
                                                          kDefaultPaddingValue /
                                                              2),
                                              child: SizedBox(
                                                width: 100.w,
                                                height: 25.h,
                                                child: Container(
                                                    color: Colors.white70,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text.rich(TextSpan(
                                                              children: [
                                                                TextSpan(
                                                                    text:
                                                                        "Hành vi liên quan: ",
                                                                    style: Theme.of(context).textTheme.headline3?.copyWith(
                                                                        color: Colors
                                                                            .orange,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontStyle:
                                                                            FontStyle
                                                                                .italic,
                                                                        decoration:
                                                                            TextDecoration
                                                                                .underline,
                                                                        fontSize:
                                                                            FONTSIZES.textLarge))
                                                              ])),
                                                          Expanded(
                                                            child: ListView
                                                                .separated(
                                                              scrollDirection:
                                                                  Axis.vertical,
                                                              shrinkWrap: true,
                                                              separatorBuilder: (context,
                                                                      index) =>
                                                                  const SizedBox(
                                                                      height:
                                                                          kDefaultPaddingValue),
                                                              itemBuilder:
                                                                  ((context,
                                                                      index) {
                                                                var min2 = "";
                                                                var max2 = "";
                                                                if (widget
                                                                        .searchLawDto!
                                                                        .referenceParagraph !=
                                                                    []) {
                                                                  min2 = numberFormat.format(double.parse(widget
                                                                      .searchLawDto!
                                                                      .referenceParagraph![
                                                                          index]
                                                                      .minPenalty!));
                                                                  max2 = numberFormat.format(double.parse(widget
                                                                      .searchLawDto!
                                                                      .referenceParagraph![
                                                                          index]
                                                                      .maxPenalty!));
                                                                }
                                                                return Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      top: 8.0),
                                                                  child:
                                                                      GestureDetector(
                                                                    onTap:
                                                                        () async {
                                                                      Future<SearchLawDTO>
                                                                          sldto =
                                                                          LawSerivce().GetSearchParagraphDTOAsync(widget
                                                                              .searchLawDto!
                                                                              .referenceParagraph![index]
                                                                              .id);
                                                                      Get.to(
                                                                          () => SearchLawDetailScreen(
                                                                              futureSearchLawDto:
                                                                                  sldto),
                                                                          preventDuplicates:
                                                                              false);
                                                                    },
                                                                    child: Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceAround,
                                                                        children: [
                                                                          SizedBox(
                                                                              width: 5.w,
                                                                              child: const Icon(
                                                                                Icons.search,
                                                                                size: 16,
                                                                              )),
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(left: kDefaultPaddingValue),
                                                                            child: SizedBox(
                                                                                width: 70.w,
                                                                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                                                  Text(maxLines: 2, overflow: TextOverflow.ellipsis, widget.searchLawDto!.referenceParagraph![index].description, style: Theme.of(context).textTheme.headline4?.copyWith(color: Colors.black, fontSize: FONTSIZES.textMedium)),
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.only(top: kDefaultPaddingValue / 2),
                                                                                    child: (widget.searchLawDto!.referenceParagraph![index].minPenalty != "0" && widget.searchLawDto!.referenceParagraph![index].maxPenalty != "0") ? Text('Phạt tiền từ ${min2}đến ${max2}nghìn đồng', style: const TextStyle(color: Colors.red, fontSize: FONTSIZES.textSmall)) : const Text('Phạt cảnh cáo', style: TextStyle(color: Colors.red)),
                                                                                  ),
                                                                                  const Padding(
                                                                                    padding: EdgeInsets.only(top: kDefaultPaddingValue / 2),
                                                                                    child: Text(
                                                                                      'Tìm hiểu thêm',
                                                                                      style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                                                                                    ),
                                                                                  )
                                                                                ])),
                                                                          ),
                                                                        ]),
                                                                  ),
                                                                );
                                                              }),
                                                              itemCount: widget
                                                                  .searchLawDto!
                                                                  .referenceParagraph!
                                                                  .length,
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
                    );
                  }
                })));
  }
}
