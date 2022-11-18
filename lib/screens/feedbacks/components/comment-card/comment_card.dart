import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/colors/gf_color.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/components/rating/gf_rating.dart';
import 'package:getwidget/size/gf_size.dart';
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GFAvatar(
                      radius: 5.w,
                      backgroundImage: ac.avatar.value.isNotEmpty
                          ? NetworkImage(ac.avatar.value)
                          : const NetworkImage(defaultAvatarUrl),
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      getName(),
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: FONTSIZES.textMediumLarge,
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: kDefaultPaddingValue / 2),
                  child: GFRating(
                    onChanged: (value) {},
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    value: widget.comment.rating.toDouble(),
                    allowHalfRating: true,
                    filledIcon: const Icon(
                      Icons.star_rounded,
                      size: GFSize.SMALL,
                      color: GFColors.WARNING,
                    ),
                    defaultIcon: const Icon(
                      Icons.star_outline_rounded,
                      size: GFSize.SMALL,
                      color: GFColors.WARNING,
                    ),
                    halfFilledIcon: const Icon(
                      Icons.star_half_rounded,
                      size: GFSize.SMALL,
                      color: GFColors.WARNING,
                    ),
                    itemCount: 5,
                    borderColor: GFColors.WARNING,
                    color: GFColors.WARNING,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: kDefaultPaddingValue / 2),
                    child: Text(
                      widget.comment.content,
                      style: Theme.of(context).textTheme.headline6?.copyWith(
                            color: Colors.black87,
                          ),
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
