import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vnrdn_tai/models/dtos/searchLawDTO.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'package:sizer/sizer.dart';

class SearchListItem extends StatelessWidget {
  const SearchListItem({super.key, required this.searchLawDto});
  final SearchLawDTO? searchLawDto;
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
            print("tapped on container");
          },
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            SizedBox(
                width: 15.w,
                child: Icon(
                  Icons.search,
                  size: 32,
                )),
            Padding(
              padding: const EdgeInsets.only(left: kDefaultPaddingValue),
              child: Container(
                  width: 70.w,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            searchLawDto!.paragraphDesc != ""
                                ? '${searchLawDto!.paragraphDesc}'
                                : '${searchLawDto!.sectionDesc}',
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                ?.copyWith(
                                    color: Colors.black,
                                    fontSize: FONTSIZES.textMedium)),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: kDefaultPaddingValue / 2),
                          child: (searchLawDto!.minPenalty != "0" &&
                                  searchLawDto!.maxPenalty != "0")
                              ? Text('Phạt tiền từ ${min}đến ${max}nghìn đồng',
                                  style: TextStyle(color: Colors.red))
                              : const Text('Phạt cảnh cáo',
                                  style: TextStyle(color: Colors.red)),
                        ),
                        const Padding(
                          padding:
                              EdgeInsets.only(top: kDefaultPaddingValue / 2),
                          child: Text(
                            'Tìm hiểu thêm',
                            style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline),
                          ),
                        )
                      ])),
            ),
          ]),
        ),
      );
    } else {
      return Container();
    }
  }
}
