import 'dart:ui';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:sizer/sizer.dart';
import 'package:vnrdn_tai/controllers/auth_controller.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/models/Comment.dart';
import 'package:vnrdn_tai/screens/feedbacks/components/comment-card/comment_card.dart';
import 'package:vnrdn_tai/screens/feedbacks/components/rating_tab.dart';
import 'package:vnrdn_tai/services/CommentService.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'package:vnrdn_tai/shared/snippets.dart';
import 'package:vnrdn_tai/utils/dialog_util.dart';
import 'package:vnrdn_tai/widgets/templated_buttons.dart';
import 'package:loader_overlay/loader_overlay.dart';

class CommentsScreen extends StatefulWidget {
  const CommentsScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CommentsState();
}

class _CommentsState extends State<CommentsScreen> {
  GlobalController gc = Get.put(GlobalController());
  AuthController ac = Get.put(AuthController());
  late Future<List<Comment>> comments = CommentService().getComments();
  final commentController = TextEditingController();
  final ratingController = TextEditingController();
  List<double> _listRateOfRating = [0.0, 0.0, 0.0, 0.0, 0.0];
  double average = 0.0;
  int rating = 5;
  bool isSentComment = false;
  bool isLoading = true;

  getAverageRating(List<Comment> list) {
    average = 0.0;
    if (list.isNotEmpty) {
      list.forEach((element) {
        average += element.rating;
      });
      average /= list.length;
    }
    return (average * 10).round() / 10;
  }

  getRateOfRating(List<Comment> list) {
    _listRateOfRating = [0.0, 0.0, 0.0, 0.0, 0.0];
    if (list.isNotEmpty) {
      list.forEach((e) {
        _listRateOfRating[e.rating - 1]++;
      });
      _listRateOfRating.asMap().forEach((index, rate) {
        _listRateOfRating[index] = rate / list.length;
        print(_listRateOfRating);
      });
    }
  }

  void handleSendComment(BuildContext context) async {
    await CommentService()
        .createComment(commentController.text, rating)
        .then((value) {
      commentController.text = '';
      setState(() {
        comments = CommentService().getComments();
      });
    });
  }

  _onCloseRating(BuildContext context, void value) {
    if (isSentComment) {
      DialogUtil.showAwesomeDialog(context, DialogType.success, "Thành công",
          "Cảm ơn bạn đã đánh giá!", () => {}, null);
      setState(() {
        isSentComment = false;
        comments = CommentService().getComments();
      });
    }
  }

  callbackSubmitRating(newIsSent) {
    context.loaderOverlay.hide();
    setState(() {
      isSentComment = newIsSent;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        elevation: 0,
        title: const Text('Đánh giá người dùng'),
        centerTitle: true,
      ),
      body: KeyboardVisibilityBuilder(
        builder: (context, isKeyboardVisible) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FutureBuilder<List<Comment>>(
                key: UniqueKey(),
                future: comments,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting ||
                      snapshot.data == null) {
                    return Padding(
                      padding: EdgeInsets.only(top: 40.h),
                      child: loadingScreen(),
                    );
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
                      getAverageRating(snapshot.data!);
                      getRateOfRating(snapshot.data!);
                      return snapshot.data!.isEmpty
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: kDefaultPaddingValue * 2),
                                child: Text(
                                  "Hiện tại chưa có phản hồi nào",
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: FONTSIZES.textLarge,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            )
                          : Column(
                              children: [
                                Container(
                                  height: 45.h,
                                  width: 100.w,
                                  margin: const EdgeInsets.only(
                                    top: kDefaultPaddingValue,
                                    left: kDefaultPaddingValue,
                                    right: kDefaultPaddingValue,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(
                                        kDefaultPaddingValue),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.shade200,
                                        offset: Offset.fromDirection(2.h, 0),
                                      ),
                                    ],
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: kDefaultPaddingValue,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: kDefaultPaddingValue),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              'assets/images/logo.png',
                                              scale: 8,
                                            ),
                                            SizedBox(width: 5.w),
                                            const Text(
                                              "VNRDnTAI",
                                              style: TextStyle(
                                                color: Colors.black54,
                                                fontSize: FONTSIZES.textLarger,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: 80.w,
                                        height: 8.h,
                                        margin: const EdgeInsets.only(
                                            top: kDefaultPaddingValue),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          borderRadius: BorderRadius.circular(
                                              kDefaultPaddingValue * 4),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.shade200,
                                              offset:
                                                  Offset.fromDirection(2.h, 0),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            GFRating(
                                              onChanged: (value) {},
                                              value: average,
                                              allowHalfRating: true,
                                              filledIcon: const Icon(
                                                Icons.star_rounded,
                                                size: GFSize.MEDIUM,
                                                color: GFColors.WARNING,
                                              ),
                                              defaultIcon: const Icon(
                                                Icons.star_outline_rounded,
                                                size: GFSize.MEDIUM,
                                                color: GFColors.WARNING,
                                              ),
                                              halfFilledIcon: const Icon(
                                                Icons.star_half_rounded,
                                                size: GFSize.MEDIUM,
                                                color: GFColors.WARNING,
                                              ),
                                              itemCount:
                                                  (average * 10) % 10 >= 5
                                                      ? average.round() - 1
                                                      : average.round(),
                                              borderColor: GFColors.WARNING,
                                              color: GFColors.WARNING,
                                            ),
                                            average % 10 < 1
                                                ? Icon(
                                                    average % 10 < 1 &&
                                                            average % 10 > 0
                                                        ? ((average * 10) %
                                                                    10 >=
                                                                5
                                                            ? Icons
                                                                .star_half_rounded
                                                            : Icons
                                                                .star_border_rounded)
                                                        : Icons
                                                            .star_border_rounded,
                                                    size: GFSize.MEDIUM,
                                                    color: GFColors.WARNING,
                                                  )
                                                : Container(),
                                            average % 10 < 2
                                                ? Icon(
                                                    average % 10 < 2 &&
                                                            average % 10 > 1
                                                        ? ((average * 10) %
                                                                    10 >=
                                                                5
                                                            ? Icons
                                                                .star_half_rounded
                                                            : Icons
                                                                .star_border_rounded)
                                                        : Icons
                                                            .star_border_rounded,
                                                    size: GFSize.MEDIUM,
                                                    color: GFColors.WARNING,
                                                  )
                                                : Container(),
                                            average % 10 < 3
                                                ? Icon(
                                                    average % 10 < 3 &&
                                                            average % 10 > 2
                                                        ? ((average * 10) %
                                                                    10 >=
                                                                5
                                                            ? Icons
                                                                .star_half_rounded
                                                            : Icons
                                                                .star_border_rounded)
                                                        : Icons
                                                            .star_border_rounded,
                                                    size: GFSize.MEDIUM,
                                                    color: GFColors.WARNING,
                                                  )
                                                : Container(),
                                            average % 10 < 4
                                                ? Icon(
                                                    average % 10 < 4 &&
                                                            average % 10 > 3
                                                        ? ((average * 10) %
                                                                    10 >=
                                                                5
                                                            ? Icons
                                                                .star_half_rounded
                                                            : Icons
                                                                .star_border_rounded)
                                                        : Icons
                                                            .star_border_rounded,
                                                    size: GFSize.MEDIUM,
                                                    color: GFColors.WARNING,
                                                  )
                                                : Container(),
                                            average % 10 < 5
                                                ? Icon(
                                                    average % 10 < 5 &&
                                                            average % 10 > 4
                                                        ? ((average * 10) %
                                                                    10 >=
                                                                5
                                                            ? Icons
                                                                .star_half_rounded
                                                            : Icons
                                                                .star_border_rounded)
                                                        : Icons
                                                            .star_border_rounded,
                                                    size: GFSize.MEDIUM,
                                                    color: GFColors.WARNING,
                                                  )
                                                : Container(),
                                            SizedBox(width: 5.w),
                                            Text(
                                              '${average.toStringAsFixed(1)} trên 5',
                                              style: const TextStyle(
                                                color: Colors.black54,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: kDefaultPaddingValue / 2),
                                        child: Text(
                                          'Đã có ${snapshot.data!.length} đánh giá',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: Colors.blueAccent,
                                            fontSize: FONTSIZES.textMediumLarge,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            top: kDefaultPaddingValue),
                                        width: 80.w,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const Text('5 sao'),
                                            Container(
                                              width: 54.w,
                                              child: GFProgressBar(
                                                animation: true,
                                                percentage:
                                                    _listRateOfRating[4] > 1
                                                        ? 1
                                                        : _listRateOfRating[4],
                                                lineHeight: 16,
                                                alignment: MainAxisAlignment
                                                    .spaceBetween,
                                                backgroundColor:
                                                    Colors.grey.shade400,
                                                progressBarColor:
                                                    GFColors.WARNING,
                                              ),
                                            ),
                                            Text(
                                              '${(_listRateOfRating[4] * 100).toStringAsFixed(2)}%',
                                              textAlign: TextAlign.left,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            top: kDefaultPaddingValue),
                                        width: 80.w,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const Text('4 sao'),
                                            Container(
                                              width: 54.w,
                                              child: GFProgressBar(
                                                animation: true,
                                                percentage:
                                                    _listRateOfRating[3] > 1
                                                        ? 1
                                                        : _listRateOfRating[3],
                                                lineHeight: 16,
                                                alignment: MainAxisAlignment
                                                    .spaceBetween,
                                                backgroundColor:
                                                    Colors.grey.shade400,
                                                progressBarColor:
                                                    GFColors.WARNING,
                                              ),
                                            ),
                                            Text(
                                              '${(_listRateOfRating[3] * 100).toStringAsFixed(2)}%',
                                              textAlign: TextAlign.left,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            top: kDefaultPaddingValue),
                                        width: 80.w,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const Text('3 sao'),
                                            Container(
                                              width: 54.w,
                                              child: GFProgressBar(
                                                animation: true,
                                                percentage:
                                                    _listRateOfRating[2] > 1
                                                        ? 1
                                                        : _listRateOfRating[2],
                                                lineHeight: 16,
                                                alignment: MainAxisAlignment
                                                    .spaceBetween,
                                                backgroundColor:
                                                    Colors.grey.shade400,
                                                progressBarColor:
                                                    GFColors.WARNING,
                                              ),
                                            ),
                                            Text(
                                              '${(_listRateOfRating[2] * 100).toStringAsFixed(2)}%',
                                              textAlign: TextAlign.left,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            top: kDefaultPaddingValue),
                                        width: 80.w,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const Text('2 sao'),
                                            Container(
                                              width: 54.w,
                                              child: GFProgressBar(
                                                animation: true,
                                                percentage:
                                                    _listRateOfRating[1] > 1
                                                        ? 1
                                                        : _listRateOfRating[1],
                                                lineHeight: 16,
                                                alignment: MainAxisAlignment
                                                    .spaceBetween,
                                                backgroundColor:
                                                    Colors.grey.shade400,
                                                progressBarColor:
                                                    GFColors.WARNING,
                                              ),
                                            ),
                                            Text(
                                              '${(_listRateOfRating[1] * 100).toStringAsFixed(2)}%',
                                              textAlign: TextAlign.left,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            top: kDefaultPaddingValue),
                                        width: 80.w,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const Text('1 sao'),
                                            Container(
                                              width: 54.w,
                                              child: GFProgressBar(
                                                animation: true,
                                                percentage:
                                                    _listRateOfRating[0] > 1
                                                        ? 1
                                                        : _listRateOfRating[0],
                                                lineHeight: 16,
                                                alignment: MainAxisAlignment
                                                    .spaceBetween,
                                                backgroundColor:
                                                    Colors.grey.shade400,
                                                progressBarColor:
                                                    GFColors.WARNING,
                                              ),
                                            ),
                                            Text(
                                              '${(_listRateOfRating[0] * 100).toStringAsFixed(2)}%',
                                              textAlign: TextAlign.left,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 30.h,
                                  width: 100.w,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      top: kDefaultPaddingValue / 2,
                                      left: kDefaultPaddingValue / 2,
                                    ),
                                    child: ListView.separated(
                                      physics: const BouncingScrollPhysics(),
                                      separatorBuilder: (context, index) =>
                                          const SizedBox(
                                              height: kDefaultPaddingValue),
                                      scrollDirection: Axis.horizontal,
                                      itemCount: snapshot.data!.length,
                                      itemBuilder: ((context, index) {
                                        return CommentCard(
                                          comment: snapshot.data![index],
                                        );
                                      }),
                                    ),
                                  ),
                                ),
                              ],
                            );
                    }
                  }
                },
              ),
              const Spacer(),
              Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: kDefaultPaddingValue,
                    vertical: kDefaultPaddingValue),
                child: ElevatedButton(
                  onPressed: () {
                    Future<void> future = showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                            top: Radius.circular(kDefaultPaddingValue)),
                      ),
                      backgroundColor: Colors.white,
                      builder: ((context) {
                        return Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: LoaderOverlay(
                              child: RatingTab(
                                  parentContext: context,
                                  callback: callbackSubmitRating)),
                        );
                      }),
                    );
                    future.then((void value) => _onCloseRating(context, value));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    textStyle: const TextStyle(
                      color: Colors.blueAccent,
                      fontSize: FONTSIZES.textLarge,
                      fontWeight: FontWeight.bold,
                    ),
                    foregroundColor: Colors.blueAccent,
                    elevation: 2,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: const EdgeInsets.symmetric(
                        vertical: kDefaultPaddingValue + 2),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: Colors.blueAccent.shade200, width: 3),
                      borderRadius: BorderRadius.circular(kDefaultPaddingValue),
                    ),
                  ),
                  child: const Text("Đánh giá ngay"),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
