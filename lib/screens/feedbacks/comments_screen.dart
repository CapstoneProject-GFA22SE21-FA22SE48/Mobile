import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:vnrdn_tai/models/Comment.dart';
import 'package:vnrdn_tai/screens/feedbacks/components/comment-card/comment_card.dart';
import 'package:vnrdn_tai/services/CommentService.dart';
import 'package:vnrdn_tai/shared/snippets.dart';

class CommentsScreen extends StatefulWidget {
  const CommentsScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FeedbackClassState();
}

class _FeedbackClassState extends State<CommentsScreen> {
  late Future<List<Comment>> comments;

  @override
  void initState() {
    super.initState();
    comments = CommentService().getComments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        title: const Text('Phản hồi'),
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
              return Column(
                children: [
                  Container(
                    height: 80.h,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: ((context, index) {
                          return CommentCard(comment: snapshot.data![index]);
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
    );
  }
}
