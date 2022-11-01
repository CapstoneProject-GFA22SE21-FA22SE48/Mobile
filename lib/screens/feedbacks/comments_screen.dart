import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image/image.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:vnrdn_tai/controllers/auth_controller.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/models/Comment.dart';
import 'package:vnrdn_tai/screens/feedbacks/components/comment-card/comment_card.dart';
import 'package:vnrdn_tai/services/CommentService.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'package:vnrdn_tai/shared/snippets.dart';

class CommentsScreen extends StatefulWidget {
  const CommentsScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FeedbackClassState();
}

class _FeedbackClassState extends State<CommentsScreen> {
  GlobalController gc = Get.put(GlobalController());
  AuthController ac = Get.put(AuthController());
  late Future<List<Comment>> comments = CommentService().getComments();
  final commentController = TextEditingController();

  void handleSendComment(BuildContext context) async {
    await CommentService().createComment(commentController.text).then((value) {
      print(value);
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightBlueBackground,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        // elevation: 4,
        title: const Text('Bình luận phản hồi'),
      ),
      body: FutureBuilder<List<Comment>>(
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
              return KeyboardVisibilityBuilder(
                builder: (context, isKeyboardVisible) {
                  return Column(
                    children: [
                      SizedBox(
                        height: isKeyboardVisible ? 52.h : 82.h,
                        width: 100.w,
                        child: snapshot.data!.isNotEmpty
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: ((context, index) {
                                    return SizedBox(
                                      width: 80.w,
                                      height: 15.h,
                                      child: Card(
                                        color: Colors.white,
                                        shadowColor: Colors.grey.shade400,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                kDefaultPaddingValue)),
                                        child: Padding(
                                            padding: const EdgeInsets.all(
                                                kDefaultPaddingValue),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  //illegal
                                                  child: Text(
                                                    snapshot
                                                        .data![index].content,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline6
                                                        ?.copyWith(
                                                          color: Colors.black87,
                                                        ),
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    // Text(
                                                    //     "${gc.username.value.isNotEmpty ? gc.username.value : ac.email.value}"),
                                                    const Spacer(),
                                                    Text(
                                                      'Đã bình luận lúc ${DateFormat('hh:mm dd/MM/yyyy').format(DateTime.parse(snapshot.data![index].createdDate))}',
                                                      style: TextStyle(
                                                        fontStyle:
                                                            FontStyle.italic,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            )),
                                      ),
                                    );
                                  }),
                                ),
                              )
                            : const Center(
                                child: Text(
                                  "Hiện tại bạn chưa có phản hồi nào",
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: FONTSIZES.textPrimary,
                                  ),
                                ),
                              ),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 80.w,
                              // color: Colors.white12,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: kDefaultPaddingValue / 2),
                              decoration: BoxDecoration(
                                color: Colors.white70,
                                borderRadius: BorderRadius.circular(
                                    kDefaultPaddingValue / 2),
                              ),
                              child: TextField(
                                controller: commentController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.done,
                                cursorColor: kPrimaryButtonColor,
                                decoration: const InputDecoration(
                                  hintText: "Viết bình luận",
                                  border: InputBorder.none,
                                  // prefixIcon: Padding(
                                  //   padding: EdgeInsets.all(
                                  //       kDefaultPaddingValue / 2),
                                  //   child: Icon(Icons.comment_rounded),
                                  // ),
                                ),
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  if (commentController.text.isNotEmpty) {
                                    handleSendComment(context);
                                  }
                                },
                                icon: const FaIcon(
                                  FontAwesomeIcons.solidPaperPlane,
                                  color: Colors.blueAccent,
                                ))
                          ]),
                    ],
                  );
                },
              );
            }
          }
        },
      ),
      // bottomNavigationBar: BottomAppBar(
      //   color: Colors.white,
      //   child: Container(
      //     height: 8.h,
      //     width: 100.w,
      //     child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      //       Container(
      //         width: 80.w,
      //         child: TextField(
      //           controller: commentController,
      //           keyboardType: TextInputType.text,
      //           textInputAction: TextInputAction.done,
      //           cursorColor: kPrimaryButtonColor,
      //           decoration: const InputDecoration(
      //             hintText: "Viết bình luận",
      //             prefixIcon: Padding(
      //               padding: EdgeInsets.all(kDefaultPaddingValue / 2),
      //               child: Icon(Icons.person),
      //             ),
      //           ),
      //         ),
      //       ),
      //       IconButton(
      //           onPressed: () {
      //             if (commentController.text.isNotEmpty) {
      //               handleSendComment(context);
      //             }
      //           },
      //           icon: FaIcon(FontAwesomeIcons.solidPaperPlane))
      //     ]),
      //   ),
      // ),
    );
  }
}
