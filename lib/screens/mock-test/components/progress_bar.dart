import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:vnrdn_tai/controllers/question_controller.dart';

class ProgressBar extends StatelessWidget {
  const ProgressBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<QuestionController>(
        init: QuestionController(),
        builder: (controller) {
          return Stack(
            children: [
              LayoutBuilder(
                  builder: (ctx, constraint) => Container(
                        width: constraint.maxWidth * controller.animation.value,
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [
                                Colors.blue,
                                Colors.green,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(50)),
                      )),
              Positioned.fill(
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${(controller.animation.value * 60).round()} sec'),
                          FaIcon(FontAwesomeIcons.clock)
                        ],
                      )))
            ],
          );
        });
  }
}
