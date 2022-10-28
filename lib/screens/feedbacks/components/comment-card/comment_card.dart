import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:vnrdn_tai/models/Comment.dart';
import 'package:vnrdn_tai/shared/constants.dart';

class CommentCard extends StatefulWidget {
  const CommentCard({Key? key, required this.comment});

  final Comment comment;
  @override
  State<StatefulWidget> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Simple Material App"),
        ),
        body: Column(
          children: <Widget>[
            Card(
              color: Colors.white,
              shadowColor: Colors.grey.shade400,
              child: Padding(
                  padding: const EdgeInsets.all(kDefaultPaddingValue),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 90.w.sp, //illegal
                        child: Text(
                          widget.comment.content,
                          style:
                              Theme.of(context).textTheme.headline5?.copyWith(
                                    color: Colors.black54,
                                  ),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            widget.comment.createdDate.toIso8601String(),
                          ),
                        ],
                      )
                    ],
                  )),
            )
          ],
        ));
  }
}
