import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:vnrdn_tai/controllers/cart_controller.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/models/dtos/searchLawDTO.dart';
import 'package:vnrdn_tai/screens/search/cart/cart_page.dart';
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
    CartController cc = Get.find<CartController>();
    NumberFormat numberFormat =
        NumberFormat.currency(locale: 'vi_VN', symbol: "");
    var min = "";
    var max = "";
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text("Chi tiết"),
          elevation: 0,
          actions: [
            IconButton(
                icon: const Icon(Icons.receipt),
                onPressed: () {
                  Get.to(() => const CartPage(), preventDuplicates: false);
                }),
          ],
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
                    if (widget.searchLawDto!.minPenalty == "0" &&
                        widget.searchLawDto!.maxPenalty == "0") {
                      min = max = "0";
                    } else {
                      min = numberFormat.format(
                          double.parse(widget.searchLawDto!.minPenalty));
                      max = numberFormat.format(
                          double.parse(widget.searchLawDto!.maxPenalty));
                    }
                    return Center(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            const Divider(),
                            SizedBox(
                              width: 100.w,
                              height: 86.h,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 100.w,
                                      height: widget
                                                  .searchLawDto!
                                                  .referenceParagraph!
                                                  .isNotEmpty &&
                                              gc.tab.value == TABS.SEARCH
                                          ? 58.h
                                          : 70.h,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: kDefaultPaddingValue),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.shade300,
                                            blurRadius: 2,
                                          )
                                        ],
                                        borderRadius: BorderRadius.circular(
                                          kDefaultPaddingValue,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: kDefaultPaddingValue),
                                        child: SingleChildScrollView(
                                          physics:
                                              const BouncingScrollPhysics(),
                                          child: SizedBox(
                                            height: widget.searchLawDto!
                                                        .additionalPenalty !=
                                                    ""
                                                ? 80.h
                                                : 60.h,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical:
                                                          kDefaultPaddingValue),
                                              child:
                                                  Text.rich(TextSpan(children: [
                                                TextSpan(
                                                    text:
                                                        "${widget.searchLawDto!.name}.",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline4
                                                        ?.copyWith(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: FONTSIZES
                                                                .textLarge)),
                                                WidgetSpan(
                                                    child: Container(
                                                  padding: const EdgeInsets.all(
                                                      kDefaultPaddingValue),
                                                )),
                                                TextSpan(
                                                    text:
                                                        "${widget.searchLawDto!.statueDesc}.",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline4
                                                        ?.copyWith(
                                                            color:
                                                                Colors.black87,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            fontSize: FONTSIZES
                                                                .textPrimary)),
                                                WidgetSpan(
                                                    child: Container(
                                                  padding: const EdgeInsets.all(
                                                      kDefaultPaddingValue),
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
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          // fontWeight:
                                                          //     FontWeight.,
                                                          fontSize: FONTSIZES
                                                              .textMediumLarge),
                                                )),
                                                WidgetSpan(
                                                    child: Container(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                )),
                                                TextSpan(
                                                    text: min != "0" &&
                                                            max != "0"
                                                        ? "Phạt tiền từ $minđến $max đồng"
                                                        : "Phạt cảnh cáo",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline3
                                                        ?.copyWith(
                                                            color: Colors.red,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: FONTSIZES
                                                                .textMediumLarge)),
                                                WidgetSpan(
                                                    child: Container(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
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
                                                                FontWeight.bold,
                                                            fontSize: FONTSIZES
                                                                .textMediumLarge)),
                                                WidgetSpan(
                                                    child: Container(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                )),
                                                TextSpan(
                                                    text:
                                                        "${widget.searchLawDto!.additionalPenalty?.replaceAll('\\', '')}",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline3
                                                        ?.copyWith(
                                                            color: Colors.black,
                                                            fontStyle: FontStyle
                                                                .italic,
                                                            fontSize: FONTSIZES
                                                                .textMedium)),
                                                WidgetSpan(
                                                    child: Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical:
                                                          kDefaultPaddingValue),
                                                )),
                                                WidgetSpan(
                                                    child: Center(
                                                  child: FloatingActionButton
                                                      .extended(
                                                    shape: const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    15.0))),
                                                    onPressed: () {
                                                      if (widget.searchLawDto !=
                                                              null &&
                                                          !cc.laws.contains(widget
                                                              .searchLawDto)) {
                                                        cc.laws.add(widget
                                                            .searchLawDto!);
                                                        if (!Get
                                                            .isSnackbarOpen) {
                                                          Get.snackbar(
                                                              'Thành công',
                                                              'Đã thêm vào biên bản',
                                                              colorText:
                                                                  Colors.green,
                                                              backgroundColor:
                                                                  Colors.white,
                                                              duration:
                                                                  const Duration(
                                                                      seconds:
                                                                          2),
                                                              isDismissible:
                                                                  true);
                                                        }
                                                      } else {
                                                        if (!Get
                                                            .isSnackbarOpen) {
                                                          Get.snackbar(
                                                              'Cảnh báo',
                                                              'Điều này đã có trong biên bản',
                                                              colorText: Colors
                                                                  .redAccent,
                                                              backgroundColor:
                                                                  Colors.white,
                                                              duration:
                                                                  const Duration(
                                                                      seconds:
                                                                          2),
                                                              isDismissible:
                                                                  true);
                                                        }
                                                      }
                                                    },
                                                    label: const Text(
                                                        'Thêm vào biên bản.'),
                                                    icon: const Icon(
                                                        Icons.add_box_outlined),
                                                  ),
                                                )),
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
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: kDefaultPaddingValue,
                                              // vertical: kDefaultPaddingValue
                                            ),
                                            child: Container(
                                                width: 100.w,
                                                height: 25.h,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    Radius.circular(
                                                      kDefaultPaddingValue,
                                                    ),
                                                  ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color:
                                                          Colors.grey.shade200,
                                                      // spreadRadius: 2,
                                                      blurRadius: 2,
                                                    )
                                                  ],
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      kDefaultPaddingValue),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text.rich(
                                                          TextSpan(children: [
                                                        TextSpan(
                                                            text:
                                                                "Hành vi liên quan: ",
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headline3
                                                                ?.copyWith(
                                                                    color: Colors
                                                                        .orange,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    // fontStyle: FontStyle.italic,
                                                                    // decoration:
                                                                    //     TextDecoration
                                                                    //         .underline,
                                                                    fontSize:
                                                                        FONTSIZES
                                                                            .textLarge))
                                                      ])),
                                                      SizedBox(height: 2.h),
                                                      Expanded(
                                                        child:
                                                            ListView.separated(
                                                          physics:
                                                              const BouncingScrollPhysics(),
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
                                                              min2 = numberFormat.format(
                                                                  double.parse(widget
                                                                      .searchLawDto!
                                                                      .referenceParagraph![
                                                                          index]
                                                                      .minPenalty!));
                                                              max2 = numberFormat.format(
                                                                  double.parse(widget
                                                                      .searchLawDto!
                                                                      .referenceParagraph![
                                                                          index]
                                                                      .maxPenalty!));
                                                            }
                                                            return Padding(
                                                              padding:
                                                                  const EdgeInsets
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
                                                                          .referenceParagraph![
                                                                              index]
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
                                                                        MainAxisAlignment
                                                                            .spaceAround,
                                                                    children: [
                                                                      SizedBox(
                                                                          width: 5
                                                                              .w,
                                                                          child:
                                                                              const Icon(
                                                                            Icons.search,
                                                                            size:
                                                                                16,
                                                                          )),
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.only(left: kDefaultPaddingValue),
                                                                        child: SizedBox(
                                                                            width: 70.w,
                                                                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                                              Text(
                                                                                maxLines: 2,
                                                                                overflow: TextOverflow.ellipsis,
                                                                                widget.searchLawDto!.referenceParagraph![index].description,
                                                                                style: Theme.of(context).textTheme.headline4?.copyWith(
                                                                                      color: Colors.black,
                                                                                      fontSize: FONTSIZES.textMedium,
                                                                                    ),
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(top: kDefaultPaddingValue / 2),
                                                                                child: widget.searchLawDto!.referenceParagraph![index].minPenalty != "0" && widget.searchLawDto!.referenceParagraph![index].maxPenalty != "0"
                                                                                    ? Text(
                                                                                        'Phạt tiền từ ${min2}đến ${max2}nghìn đồng',
                                                                                        style: const TextStyle(
                                                                                          color: Colors.red,
                                                                                          fontSize: FONTSIZES.textSmall,
                                                                                        ),
                                                                                      )
                                                                                    : const Text(
                                                                                        'Phạt cảnh cáo',
                                                                                        style: TextStyle(color: Colors.red),
                                                                                      ),
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
                                          )
                                        : Container()
                                  ]),
                            ),
                          ]),
                    );
                  }
                })));
  }
}
