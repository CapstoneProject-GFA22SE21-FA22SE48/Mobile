import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:number_to_words_english/number_to_words_english.dart';
import 'package:sizer/sizer.dart';
import 'package:translator/translator.dart';
import 'package:vnrdn_tai/controllers/auth_controller.dart';
import 'package:vnrdn_tai/controllers/cart_controller.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'package:vnrdn_tai/shared/snippets.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  approximateFine(CartController cc) {
    var res = 0.0;
    var laws = cc.laws.value;
    laws.forEach((searchLawDTO) {
      var min = double.parse(searchLawDTO.minPenalty);
      var max = double.parse(searchLawDTO.maxPenalty);
      var avg = (min + max) / 2;
      res += avg;
    });
    cc.updateFine(res);
    return res;
  }

  numberToWord(int number, CartController cc) async {
    var res = NumberToWordsEnglish.convert(number);
    res = numberEngToVietWord(res);
    cc.updateFineToWord(res);
  }

  @override
  Widget build(BuildContext context) {
    CartController cc = Get.find<CartController>();
    GlobalController gc = Get.find<GlobalController>();
    AuthController ac = Get.put(AuthController());
    NumberFormat numberFormat =
        NumberFormat.currency(locale: 'vi_VN', symbol: "");
    return Scaffold(
        appBar: AppBar(
          title: const Text("Chi tiết biên bản"),
          elevation: 0,
        ),
        body: Obx(() {
          var af = approximateFine(cc);
          numberToWord(af.toInt(), cc);
          var min = "";
          var max = "";
          var data = cc.laws;
          return SafeArea(
            child: Container(
              margin: const EdgeInsets.all(kDefaultPaddingValue),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 2,
                  )
                ],
                borderRadius: BorderRadius.circular(
                  kDefaultPaddingValue,
                ),
              ),
              padding: const EdgeInsets.only(top: kDefaultPaddingValue),
              child: Column(
                children: [
                  Text('Biên bản xử phạt\nvi phạm giao thông',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline4?.copyWith(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: FONTSIZES.textHuge)),
                  SizedBox(height: 3.h),
                  Padding(
                    padding: const EdgeInsets.all(kDefaultPaddingValue),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Tài khoản vi phạm: ',
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                ?.copyWith(
                                    color: const Color(0xFF444444),
                                    fontWeight: FontWeight.normal,
                                    fontSize: FONTSIZES.textLarge)),
                        Text(
                            gc.userId.value.isNotEmpty
                                ? gc.username.value.isNotEmpty
                                    ? gc.username.value
                                    : ac.email.value
                                : "Người dùng tự do",
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                ?.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    fontSize: FONTSIZES.textLarge)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: kDefaultPaddingValue,
                        right: kDefaultPaddingValue,
                        left: kDefaultPaddingValue),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tổng tiền phạt dự kiến: ',
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                ?.copyWith(
                                    color: const Color(0xFF444444),
                                    fontWeight: FontWeight.normal,
                                    fontSize: FONTSIZES.textLarge)),
                        SizedBox(height: 1.h),
                        Text(
                            "(chưa bao gồm các tình tiết tăng nặng hoặc giảm nhẹ)"
                                .replaceAll("số", ""),
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                ?.copyWith(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FontStyle.italic,
                                    fontSize: FONTSIZES.textMedium)),
                      ],
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: kDefaultPaddingValue,
                        right: kDefaultPaddingValue,
                        top: kDefaultPaddingValue),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("${numberFormat.format(cc.fine.value)}VND",
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                ?.copyWith(
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.w500,
                                    fontSize: FONTSIZES.textHuge)),
                        SizedBox(height: 1.h),
                        Text(
                            "(${cc.fineToWord.value} đồng)"
                                .replaceAll("số", ""),
                            textAlign: TextAlign.end,
                            maxLines: 3,
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                ?.copyWith(
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FontStyle.italic,
                                    fontSize: FONTSIZES.textMedium)),
                      ],
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: kDefaultPaddingValue,
                        vertical: kDefaultPaddingValue / 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Các lỗi đã mắc phải: ',
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                ?.copyWith(
                                    color: const Color(0xFF444444),
                                    fontWeight: FontWeight.normal,
                                    fontSize: FONTSIZES.textLarge)),
                        const Text(''),
                      ],
                    ),
                  ),
                  data.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(
                              top: kDefaultPaddingValue * 2),
                          child: Text('Chưa có dữ liệu',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4
                                  ?.copyWith(
                                      color: Colors.black54,
                                      fontStyle: FontStyle.italic,
                                      fontSize: FONTSIZES.textLarge)),
                        )
                      : Expanded(
                          child: ListView.separated(
                            itemCount: data.length,
                            scrollDirection: Axis.vertical,
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 0),
                            itemBuilder: (context, index) {
                              min = numberFormat
                                  .format(double.parse(data[index].minPenalty));
                              max = numberFormat
                                  .format(double.parse(data[index].maxPenalty));
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: kDefaultPaddingValue),
                                child: Wrap(
                                    alignment: WrapAlignment.center,
                                    children: [
                                      ExpandableNotifier(
                                          child: ScrollOnExpand(
                                              scrollOnExpand: true,
                                              scrollOnCollapse: false,
                                              child: ExpandablePanel(
                                                theme:
                                                    const ExpandableThemeData(
                                                  headerAlignment:
                                                      ExpandablePanelHeaderAlignment
                                                          .center,
                                                  tapBodyToCollapse: true,
                                                ),
                                                header: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    child: Row(
                                                      children: [
                                                        IconButton(
                                                          icon: const Icon(
                                                              Icons.close),
                                                          color:
                                                              kPrimaryButtonColor,
                                                          iconSize: FONTSIZES
                                                              .textHuge,
                                                          onPressed: () {
                                                            data.removeAt(
                                                                index);
                                                          },
                                                        ),
                                                        Text(data[index].name!,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headline6
                                                                ?.copyWith(
                                                                    color: Colors
                                                                        .blue)),
                                                      ],
                                                    )),
                                                collapsed: Center(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                          min == '0' &&
                                                                  max == '0'
                                                              ? "Phạt cảnh cáo"
                                                              : "Từ $min đến $max đồng",
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .red,
                                                                  fontSize: 16))
                                                    ],
                                                  ),
                                                ),
                                                expanded: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 10),
                                                        child: Text(
                                                          data[index].paragraphDesc !=
                                                                  ""
                                                              ? data[index]
                                                                  .paragraphDesc!
                                                                  .replaceAll(
                                                                      "\\\n",
                                                                      "")
                                                              : data[index]
                                                                  .sectionDesc,
                                                          softWrap: true,
                                                          overflow:
                                                              TextOverflow.fade,
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 16),
                                                        )),
                                                  ],
                                                ),
                                                builder:
                                                    (_, collapsed, expanded) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10,
                                                            right: 10,
                                                            bottom: 10),
                                                    child: Expandable(
                                                      collapsed: collapsed,
                                                      expanded: expanded,
                                                      theme:
                                                          const ExpandableThemeData(
                                                              crossFadePoint:
                                                                  0),
                                                    ),
                                                  );
                                                },
                                              ))),
                                      defaultDivider(),
                                    ]),
                              );
                            },
                          ),
                        ),
                ],
              ),
            ),
          );
        }));
  }
}
