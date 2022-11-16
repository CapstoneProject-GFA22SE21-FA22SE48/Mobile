import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:getwidget/colors/gf_color.dart';
import 'package:getwidget/components/rating/gf_rating.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:vnrdn_tai/controllers/auth_controller.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/models/Comment.dart';
import 'package:vnrdn_tai/screens/feedbacks/components/comment-card/comment_card.dart';
import 'package:vnrdn_tai/services/CommentService.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'package:vnrdn_tai/shared/snippets.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RatingState();
}

class _RatingState extends State<RatingScreen> {
  GlobalController gc = Get.put(GlobalController());
  AuthController ac = Get.put(AuthController());
  late Future<List<Comment>> comments = CommentService().getComments();
  final commentController = TextEditingController();
  final ratingController = TextEditingController();
  final List<double> _listRateOfRating = [0.0, 0.0, 0.0, 0.0, 0.0];
  double average = 0.0;
  int rating = 5;

  getAverageRating(List<Comment> list) {
    average = 0.0;
    if (list.isNotEmpty) {
      list.forEach((element) {
        average += element.rating;
      });
      average /= list.length;
    }
    // return (average * 10).round() / 10;
    average = average.roundToDouble();
  }

  getRateOfRating(List<Comment> list) {
    if (list.isNotEmpty) {
      list.forEach((e) {
        _listRateOfRating[e.rating]++;
      });
      _listRateOfRating.forEach((rate) {
        rate /= list.length;
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
                      getAverageRating(snapshot.data!);
                      return snapshot.data!.isEmpty
                          ? const Center(
                              child: Text(
                                "Hiện tại chưa có phản hồi nào",
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: FONTSIZES.textPrimary,
                                ),
                              ),
                            )
                          : Column(
                              children: [
                                Container(
                                  height: 40.h,
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
                                              value: 4,
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
                                              itemCount: 5,
                                              borderColor: GFColors.WARNING,
                                              color: GFColors.WARNING,
                                            ),
                                            SizedBox(width: 5.w),
                                            Text(
                                              '$average out of 5',
                                              style: const TextStyle(
                                                color: Colors.black54,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 2.h, left: kDefaultPaddingValue),
                                  child: Row(
                                    children: const [
                                      Text(
                                        "Nhận xét hàng đầu",
                                        style: TextStyle(
                                          color: Colors.blueAccent,
                                          fontSize: FONTSIZES.textLarger,
                                          fontWeight: FontWeight.bold,
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
                  onPressed: () {},
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
      // bottomSheet: const RatingTab(),
    );
  }
}
