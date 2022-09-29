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
                        child: Column(
                          children: [
                            ProgressBar(),
                            SizedBox(height: kDefaultPaddingValue),
                            Text.rich(TextSpan(
                                text: "Question 1",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4
                                    ?.copyWith(color: Colors.red),
                                children: [
                                  TextSpan(
                                    text: "/10",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline4
                                        ?.copyWith(color: Colors.red),
                                  ),
                                ])),
                            Divider(thickness: 1.5),
                            SizedBox(height: kDefaultPaddingValue),
                            Container(
                              padding: EdgeInsets.all(kDefaultPaddingValue),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(25)),
                              child: Column(
                                children: [
                                  Text("Question 1",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6
                                          ?.copyWith(color: Colors.black)),
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: kDefaultPaddingValue),
                                    padding:
                                        EdgeInsets.all(kDefaultPaddingValue),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                    child: Row(children: [
                                      Text(
                                        "1. Test QUestion",
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 16),
                                      ),
                                      Container(
                                        height: 26,
                                        width: 26,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            border:
                                                Border.all(color: Colors.grey)),
                                      )
                                    ]),
                                  )
                                ],
                              ),
                            )
                          ],
                        ))
                  ],
                ))))
      ],
    );
  }
}
