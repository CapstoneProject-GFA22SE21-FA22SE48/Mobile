import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:vnrdn_tai/controllers/auth_controller.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/models/Comment.dart';
import 'package:vnrdn_tai/shared/constants.dart';

class CommentCard extends StatefulWidget {
  const CommentCard({super.key, required this.comment});

  final Comment comment;
  @override
  State<StatefulWidget> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  AuthController ac = Get.put(AuthController());
  GlobalController gc = Get.put(GlobalController());

  getName() {
    if (ac.displayName.value.isEmpty) {
      if (gc.username.value.isEmpty) {
        return ac.email.value;
      }
      return gc.username.value;
    }
    return ac.displayName.value;
  }

  @override
  Widget build(BuildContext context) {
    String time = DateFormat('hh:mm dd/MM/yyyy')
        .format(DateTime.parse(widget.comment.createdDate));

    return Container(
        margin:
            const EdgeInsets.symmetric(horizontal: kDefaultPaddingValue / 4),
        width: 80.w,
        height: 15.h,
        child: Card(
          color: Colors.white,
          shadowColor: Colors.grey.shade100,
          // elevation: 4,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(kDefaultPaddingValue)),
          child: Padding(
            padding: const EdgeInsets.all(kDefaultPaddingValue),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                  GFAvatar(
                    radius: 10.w,
                    backgroundImage: ac.avatar.value.isNotEmpty
                        ? NetworkImage(ac.avatar.value)
                        : const NetworkImage(defaultAvatarUrl),
                  ),
                  SizedBox(width: 3.w),
                  Text(getName())
                ]),
                Expanded(
                  //illegal
                  child: Text(
                    widget.comment.content,
                    style: Theme.of(context).textTheme.headline6?.copyWith(
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
                      'Đã bình luận lúc $time',
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
