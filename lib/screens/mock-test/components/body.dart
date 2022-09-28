import 'package:flutter/material.dart';
import 'package:vnrdn_tai/screens/mock-test/components/progress_bar.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'package:websafe_svg/websafe_svg.dart';

class Body extends StatelessWidget {
  const Body({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebsafeSvg.asset("assets/icons/bg.svg", fit: BoxFit.fill),
        SafeArea(
            child: Padding(
                padding: kDefaultPadding,
                child: (Column(
                  children: [
                    Container(
                        width: double.infinity,
                        height: 35,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.orange, width: 3),
                            borderRadius: BorderRadius.circular(20)),
                        child: ProgressBar()
                        )
                  ],
                ))))
      ],
    );
  }
}
