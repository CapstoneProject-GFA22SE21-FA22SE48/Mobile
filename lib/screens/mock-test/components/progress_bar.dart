import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:vnrdn_tai/controllers/question_controller.dart';
import 'package:vnrdn_tai/shared/constants.dart';

class ProgressBar extends StatelessWidget {
  const ProgressBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    QuestionController qc = Get.put(QuestionController());
    return GetBuilder<QuestionController>(
        init: qc,
        builder: (controller) {
          controller.runTimer();
          return Stack(children: [
            Container(
                width: double.infinity,
                height: 35,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.orange, width: 3),
                    borderRadius: BorderRadius.circular(20)),
                child: Stack(
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
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                    Positioned.fill(
                        child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: kDefaultPaddingValue, vertical: 3),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    '${(controller.animation.value * 600).round()} sec'),
                                FaIcon(FontAwesomeIcons.clock)
                              ],
                            )))
                  ],
                )),
          ]);
        });
  }
}
