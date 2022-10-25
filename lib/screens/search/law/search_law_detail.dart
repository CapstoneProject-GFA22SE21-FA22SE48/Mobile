import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:vnrdn_tai/controllers/search_controller.dart';
import 'package:vnrdn_tai/models/dtos/searchLawDTO.dart';
import 'package:vnrdn_tai/screens/search/components/search_bar.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'package:sizer/sizer.dart';

class SearchLawDetailScreen extends StatefulWidget {
  SearchLawDetailScreen({super.key, required this.searchLawDto});
  late SearchLawDTO? searchLawDto;

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
    NumberFormat numberFormat =
        NumberFormat.currency(locale: 'vi_VN', symbol: "");
    var min = "";
    var max = "";
    if (widget.searchLawDto != null) {
      min = numberFormat.format(double.parse(widget.searchLawDto!.minPenalty));
      max = numberFormat.format(double.parse(widget.searchLawDto!.maxPenalty));
    }
    SearchController sc = Get.put(SearchController());
    return Scaffold(
        body: SafeArea(
            child: Center(
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: <
          Widget>[
        AppBar(
          title: SearchBar(),
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
                  child: Container(
                    color: Colors.grey.shade300,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text.rich(TextSpan(children: [
                        TextSpan(
                            text: "${widget.searchLawDto!.statueDesc}.",
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                ?.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    fontSize: FONTSIZES.textMedium)),
                        WidgetSpan(
                            child: Container(
                          color: Colors.grey.shade300,
                          padding: EdgeInsets.all(8.0),
                        )),
                        TextSpan(
                            text: "${widget.searchLawDto!.paragraphDesc}",
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
                          padding: EdgeInsets.all(4.0),
                        )),
                        TextSpan(
                            text: "Phạt tiền từ ${min}đến ${max}nghìn đồng",
                            style: Theme.of(context)
                                .textTheme
                                .headline3
                                ?.copyWith(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: FONTSIZES.textMediumLarge)),
                        WidgetSpan(
                            child: Container(
                          color: Colors.grey.shade300,
                          padding: EdgeInsets.all(4.0),
                          child: Divider(
                            color: Colors.black,
                          ),
                        )),
                        TextSpan(
                            text: "Hình phạt bổ sung: ",
                            style: Theme.of(context)
                                .textTheme
                                .headline3
                                ?.copyWith(
                                    color: Colors.lightBlue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: FONTSIZES.textMediumLarge)),
                        WidgetSpan(
                            child: Container(
                          color: Colors.grey.shade300,
                          padding: EdgeInsets.all(1.0),
                        )),
                        TextSpan(
                            text:
                                "${widget.searchLawDto!.additionalPenalty?.replaceAll('\\', '')}",
                            style: Theme.of(context)
                                .textTheme
                                .headline3
                                ?.copyWith(
                                    color: Colors.black,
                                    fontStyle: FontStyle.italic,
                                    fontSize: FONTSIZES.textMedium))
                      ])),
                    ),
                  ),
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: kDefaultPaddingValue),
                child: SizedBox(
                  width: 100.w,
                  height: 24.h,
                  child: Container(
                      color: Colors.white70,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text.rich(TextSpan(children: [
                          TextSpan(
                              text: "Hành vi liên quan: ",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline3
                                  ?.copyWith(
                                      color: Colors.orange,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      decoration: TextDecoration.underline,
                                      fontSize: FONTSIZES.textLarge))
                        ])),
                      )),
                ),
              )
            ]),
          ),
        ),
      ]),
    )));
  }
}
