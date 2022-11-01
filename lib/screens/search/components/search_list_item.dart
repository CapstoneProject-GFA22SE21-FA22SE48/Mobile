import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tiengviet/tiengviet.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/controllers/search_controller.dart';
import 'package:vnrdn_tai/models/dtos/searchLawDTO.dart';
import 'package:vnrdn_tai/models/dtos/searchSignDTO.dart';
import 'package:vnrdn_tai/screens/container_screen.dart';
import 'package:vnrdn_tai/screens/search/law/search_law_detail.dart';
import 'package:vnrdn_tai/screens/search/law/search_law_screen.dart';
import 'package:vnrdn_tai/screens/search/sign/search_sign_detail.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'package:sizer/sizer.dart';
import 'package:styled_text/styled_text.dart';

class SearchListItem extends StatelessWidget {
  const SearchListItem({super.key, this.searchLawDto, this.searchSignDTO});
  final SearchLawDTO? searchLawDto;
  final SearchSignDTO? searchSignDTO;

  sliceFoundQuery(String s) {
    SearchController sc = Get.find<SearchController>();
    var query = TiengViet.parse(sc.query.value);
    var _s = TiengViet.parse(s);
    var start = _s.indexOf(query);
    var end = start + query.length;
    var res =
        "${s.substring(0, start)}<bold>${s.substring(start, end)}</bold>${s.substring(end, s.length)}";
    if (start > 65) {
      res =
          "...${res.substring(start - 45, s.length - end > 65 ? end + 55 : end)}...";
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    NumberFormat numberFormat =
        NumberFormat.currency(locale: 'vi_VN', symbol: "");
    var min = "";
    var max = "";
    if (searchLawDto != null) {
      min = numberFormat.format(double.parse(searchLawDto!.minPenalty));
      max = numberFormat.format(double.parse(searchLawDto!.maxPenalty));
    }

    if (searchLawDto != null) {
      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: GestureDetector(
          onTap: () {
            Get.to(() => SearchLawDetailScreen(searchLawDto: searchLawDto),
                preventDuplicates: false);
          },
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                    width: 16.w,
                    child: const Icon(
                      Icons.search,
                      size: 64,
                      color: Colors.blueAccent,
                    )),
                Padding(
                  padding: const EdgeInsets.only(left: kDefaultPaddingValue),
                  child: Container(
                      width: 66.w,
                      padding: const EdgeInsets.symmetric(
                        vertical: kDefaultPaddingValue / 4,
                        horizontal: kDefaultPaddingValue / 2,
                      ),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            StyledText(
                                tags: {
                                  'bold': StyledTextTag(
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                },
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                text: searchLawDto!.paragraphDesc != ""
                                    ? "${sliceFoundQuery("${searchLawDto!.paragraphDesc!.replaceAll('\\\n', '')}")}"
                                    : "${sliceFoundQuery("${searchLawDto!.sectionDesc}")}",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4
                                    ?.copyWith(
                                        color: Colors.black,
                                        fontSize: FONTSIZES.textPrimary)),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: kDefaultPaddingValue / 2),
                              child: (searchLawDto!.minPenalty != "0" &&
                                      searchLawDto!.maxPenalty != "0")
                                  ? Text('Phạt tiền từ ${min}đến ${max} đồng',
                                      style: TextStyle(color: Colors.red))
                                  : const Text('Phạt cảnh cáo',
                                      style: TextStyle(color: Colors.red)),
                            ),
                            searchLawDto!.referenceParagraph!.isNotEmpty
                                ? const Padding(
                                    padding: EdgeInsets.only(
                                        top: kDefaultPaddingValue / 2),
                                    child: Text(
                                      'Tìm hiểu các hành vi liên quan',
                                      style: TextStyle(
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline),
                                    ),
                                  )
                                : Container(),
                          ])),
                ),
              ]),
        ),
      );
    } else if (searchSignDTO != null) {
      return GestureDetector(
        onTap: () {
          Get.to(() => SearchSignDetailScreen(searchSignDto: searchSignDTO));
        },
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 25.w,
                child: CachedNetworkImage(
                  imageUrl: searchSignDTO!.imageUrl as String,
                  imageBuilder: (context, imageProvider) => Container(
                    width: 25.w,
                    height: 14.h,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        //image size fill
                        image: imageProvider,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => Container(
                    alignment: Alignment.center,
                    child:
                        CircularProgressIndicator(), // you can add pre loader iamge as well to show loading.
                  ), //show progress  while loading image
                  errorWidget: (context, url, error) =>
                      Image.asset("assets/images/alt_image.png"),
                  //show no iamge availalbe image on error laoding
                ),
                // searchSignDTO!.imageUrl != null ?

                // Image.network(
                //     searchSignDTO!.imageUrl as String,
                //     fit: BoxFit.contain,
                //   )
                // : const Icon(
                //     Icons.search,
                //     size: 64,
                //     color: Colors.black54,
                //   )
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: kDefaultPaddingValue / 2,
                    horizontal: kDefaultPaddingValue / 2),
                child: Container(
                    width: 60.w,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              searchSignDTO!.name,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: FONTSIZES.textMediumLarge)),
                          const Divider(
                            height: kDefaultPaddingValue / 2,
                            color: Colors.white,
                          ),
                          Text(
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              searchSignDTO!.description,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4
                                  ?.copyWith(
                                      color: Colors.black,
                                      fontSize: FONTSIZES.textPrimary)),
                          const Padding(
                            padding:
                                EdgeInsets.only(top: kDefaultPaddingValue / 2),
                            child: Text(
                              'Tìm hiểu thêm',
                              style: TextStyle(
                                  color: Colors.blueAccent,
                                  decoration: TextDecoration.underline),
                            ),
                          )
                        ])),
              ),
            ]),
      );
    } else {
      return WillPopScope(
          onWillPop: () async {
            Get.to(() => ContainerScreen());
            return await true;
          },
          child: Container());
    }
  }
}
