import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class ProgressBar extends StatelessWidget {
  const ProgressBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        LayoutBuilder(
            builder: (ctx, constraint) => Container(
                  width: constraint.maxWidth * 0.5,
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Colors.blue,
                          Colors.green,
                        ],
                      ),
                      borderRadius:
                          BorderRadius.circular(50)),
                )),
        Positioned.fill(
            child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 6),
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("10 sec left"),
                    FaIcon(FontAwesomeIcons.clock)
                  ],
                )))
      ],
    );
  }
}
