import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/models/UserInfo.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vnrdn_tai/screens/auth/components/or_divider.dart';
import 'package:vnrdn_tai/screens/container_screen.dart';
import 'package:vnrdn_tai/screens/search/search_screen.dart';
import 'package:vnrdn_tai/services/AuthService.dart';

import 'package:vnrdn_tai/screens/auth/components/already_have_an_account_acheck.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'package:vnrdn_tai/utils/android_io.dart';
import 'package:vnrdn_tai/utils/dialogUtil.dart';
import '../signup_screen.dart';

import 'dart:convert';
import 'dart:developer' as developer;

class LoginForm extends StatefulWidget {
  const LoginForm({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final controller = GlobalController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.pop(context, 'OK');
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Đăng nhập thất bại"),
      content: Text('${usernameController.text}, ${passwordController.text}'),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  // handle login
  void handleLogin(BuildContext context) async {
    if (usernameController.text != "" && passwordController.text != "") {
      String token = '';
      await AuthService()
          .loginWithUsername(usernameController.text, passwordController.text)
          .then(((value) => {token = value}));
      if (token.length > 1) {
        afterLoggedIn(token, 0);
        token = await AndroidIO.getFromStorage("token");
        // DialogUtil.showAlertDialog(context, "token", token);
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const ContainerScreen();
            },
          ),
        );
      } else {
        // ignore: use_build_context_synchronously
        DialogUtil.showAlertDialog(
            context, "Đăng nhập thất bại", "Sai tên đăng nhập hoặc mật khẩu.");
      }
    }
  }

  void handleGLogin(BuildContext context, String gmail) async {
    if (usernameController.text != "" && passwordController.text != "") {
      String token = '';
      await AuthService()
          .loginWithGmail(gmail)
          .then(((value) => {token = value}));
      if (token.length > 1) {
        afterLoggedIn(token, 0);
        token = await AndroidIO.getFromStorage("token");
        // DialogUtil.showAlertDialog(context, "token", token);
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const ContainerScreen();
            },
          ),
        );
      } else {
        // ignore: use_build_context_synchronously
        DialogUtil.showAlertDialog(
            context, "Đăng nhập thất bại", "Sai tên đăng nhập hoặc mật khẩu.");
      }
    } else {
      // ignore: use_build_context_synchronously
      DialogUtil.showAlertDialog(
          context, "Đăng nhập thất bại", "Sai tên đăng nhập hoặc mật khẩu.");
    }
  }

  // do after logged in
  Future<bool> afterLoggedIn(String token, int tabIndex) async {
    AndroidIO.saveToStorage("token", token);
    controller.updateTab(tabIndex);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            controller: usernameController,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryButtonColor,
            onSaved: (username) {},
            decoration: const InputDecoration(
              hintText: "Tên đăng nhập",
              prefixIcon: Padding(
                padding: EdgeInsets.all(kDefaultPaddingValue / 2),
                child: Icon(Icons.person),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: kDefaultPaddingValue),
            child: TextFormField(
              controller: passwordController,
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
          ),
          const SizedBox(height: kDefaultPaddingValue),
          Hero(
            tag: "login_btn",
            child: ElevatedButton(
              onPressed: () {
                handleLogin(context);
              },
              child: Text(
                "Đăng nhập".toUpperCase(),
              ),
            ),
          ),
          const SizedBox(height: kDefaultPaddingValue),
          const OrDivider(),
          const SizedBox(height: kDefaultPaddingValue),
          Hero(
            tag: "g_login_btn",
            child: ElevatedButton(
              onPressed: () {
                handleGLogin(context, "");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                alignment: Alignment.center,
              ),
              child: Padding(
                padding:
                    EdgeInsets.symmetric(vertical: kDefaultPaddingValue / 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/auth/google.png', width: 32),
                    const SizedBox(width: kDefaultPaddingValue),
                    const Text(
                      "Đăng nhập bằng Google",
                      style: TextStyle(color: kPrimaryButtonColor),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: kDefaultPaddingValue * 2),
          AlreadyHaveAnAccountCheck(
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const SignUpScreen();
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
