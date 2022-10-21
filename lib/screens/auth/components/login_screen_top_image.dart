import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vnrdn_tai/shared/constants.dart';

class LoginScreenTopImage extends StatelessWidget {
  const LoginScreenTopImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/logo.png",
              height: 36.0,
              width: 32.0,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 5.0),
              child: Text(
                "VNRDnTAI",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: FONTSIZES.textMediumLarge,
                    color: kPrimaryTextColor),
              ),
            ),
          ],
        ),
        const SizedBox(height: kDefaultPaddingValue * 2),
        const Text(
          "ĐĂNG NHẬP",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: FONTSIZES.textHuge,
              color: kPrimaryButtonColor),
        ),
        const SizedBox(height: kDefaultPaddingValue * 2),
        Row(
          children: [
            const Spacer(),
            Expanded(
              flex: 6,
              child: SvgPicture.asset(
                "assets/icons/login.svg",
                height: 240,
              ),
            ),
            const Spacer(),
          ],
        ),
        const SizedBox(height: kDefaultPaddingValue * 2),
      ],
    );
  }
}
