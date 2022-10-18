import 'package:flutter/material.dart';
import 'package:vnrdn_tai/shared/constants.dart';

class AlreadyHaveAnAccountCheck extends StatelessWidget {
  final bool login;
  final Function? press;
  const AlreadyHaveAnAccountCheck({
    Key? key,
    this.login = true,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          login ? "Bạn chưa có tài khoản? " : "Bạn đã có tài khoản? ",
          style: const TextStyle(color: kPrimaryButtonColor),
        ),
        GestureDetector(
          onTap: press as void Function()?,
          child: Text(
            login ? "Đăng kí ngay" : "Đăng nhập ngay",
            style: const TextStyle(
              color: kPrimaryButtonColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
}
