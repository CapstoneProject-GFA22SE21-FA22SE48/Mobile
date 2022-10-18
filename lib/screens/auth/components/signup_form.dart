import 'package:flutter/material.dart';
import 'package:vnrdn_tai/screens/auth/components/already_have_an_account_acheck.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import '../login_screen.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryButtonColor,
            onSaved: (email) {},
            decoration: const InputDecoration(
              hintText: "Tên đăng nhập",
              prefixIcon: Padding(
                padding: EdgeInsets.all(kDefaultPaddingValue / 2),
                child: Icon(Icons.person),
              ),
            ),
          ),
          const SizedBox(height: kDefaultPaddingValue),
          TextFormField(
            textInputAction: TextInputAction.done,
            obscureText: true,
            cursorColor: kPrimaryButtonColor,
            decoration: const InputDecoration(
              hintText: "Mật khẩu",
              prefixIcon: Padding(
                padding: EdgeInsets.all(kDefaultPaddingValue / 2),
                child: Icon(Icons.lock),
              ),
            ),
          ),
          const SizedBox(height: kDefaultPaddingValue),
          TextFormField(
            textInputAction: TextInputAction.done,
            obscureText: true,
            cursorColor: kPrimaryButtonColor,
            decoration: const InputDecoration(
              hintText: "Nhập lại mật khẩu",
              prefixIcon: Padding(
                padding: EdgeInsets.all(kDefaultPaddingValue / 2),
                child: Icon(Icons.lock),
              ),
            ),
          ),
          const SizedBox(height: kDefaultPaddingValue),
          TextFormField(
            textInputAction: TextInputAction.done,
            obscureText: true,
            cursorColor: kPrimaryButtonColor,
            decoration: const InputDecoration(
              hintText: "Email",
              prefixIcon: Padding(
                padding: EdgeInsets.all(kDefaultPaddingValue / 2),
                child: Icon(Icons.mail),
              ),
            ),
          ),
          const SizedBox(height: kDefaultPaddingValue),
          ElevatedButton(
            onPressed: () {},
            child: Text("Đăng kí".toUpperCase()),
          ),
          const SizedBox(height: kDefaultPaddingValue),
          AlreadyHaveAnAccountCheck(
            login: false,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const LoginScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
