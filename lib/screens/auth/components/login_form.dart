import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vnrdn_tai/controllers/auth_controller.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/models/UserInfo.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vnrdn_tai/screens/auth/components/or_divider.dart';
import 'package:vnrdn_tai/screens/auth/forgot_password_screen.dart';
import 'package:vnrdn_tai/screens/container_screen.dart';
import 'package:vnrdn_tai/screens/search/search_screen.dart';
import 'package:vnrdn_tai/services/AuthService.dart';

import 'package:vnrdn_tai/screens/auth/components/already_have_an_account_acheck.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'package:vnrdn_tai/utils/form_validator.dart';
import 'package:vnrdn_tai/utils/io_utils.dart';
import 'package:vnrdn_tai/utils/dialogUtil.dart';
import 'package:vnrdn_tai/widgets/templated_buttons.dart';
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
  final loginFormKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // handle login
  void handleLogin(BuildContext context) async {
    await AuthService()
        .loginWithUsername(usernameController.text, passwordController.text)
        .then(((value) => {
              if (value.length > 1)
                {afterLoggedIn(value)}
              else
                {
                  // ignore: use_build_context_synchronously
                  DialogUtil.showTextDialog(
                      context,
                      "Đăng nhập thất bại",
                      "Sai tên đăng nhập hoặc mật khẩu.",
                      [TemplatedButtons.ok(context)])
                }
            }));
  }

  void handleGLogin(BuildContext context, String gmail) async {
    await AuthService().loginWithGmail(gmail).then(((value) => {
          if (value.length > 1)
            {afterLoggedIn(value)}
          else
            {
              DialogUtil.showTextDialog(context, "Đăng nhập thất bại",
                  "Sai tên đăng nhập hoặc mật khẩu.", null)
            }
        }));
  }

  // do after logged in
  void afterLoggedIn(String token) async {
    await IOUtils.saveToStorage('token', token);

    GlobalController gc = Get.put(GlobalController());
    AuthController ac = Get.put(AuthController());
    Jwt.parseJwt(token).forEach((key, value) {
      IOUtils.saveToStorage(key, value.toString());
      if (key == 'Id') {
        gc.updateUserId(value);
      }
      if (key == 'Username') {
        gc.updateUsername(value);
      }
      if (key == 'Email') {
        ac.updateEmail(value);
      }
      if (key == 'Status') {
        ac.updateStatus(int.parse(value));
      }
      Get.to(const ContainerScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        return Form(
          key: loginFormKey,
          child: Column(
            children: [
              TextFormField(
                validator: (value) => FormValidator.validUsername(value),
                controller: usernameController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                cursorColor: kPrimaryButtonColor,
                onSaved: (username) {},
                decoration: const InputDecoration(
                  labelText: "Tên đăng nhập",
                  hintText: "Tên đăng nhập",
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(kDefaultPaddingValue / 2),
                    child: Icon(Icons.person),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: kDefaultPaddingValue),
                child: TextFormField(
                  validator: (value) => FormValidator.validPassword(value),
                  controller: passwordController,
                  textInputAction: TextInputAction.done,
                  obscureText: true,
                  cursorColor: kPrimaryButtonColor,
                  decoration: const InputDecoration(
                    labelText: "Mật khẩu",
                    hintText: "Mật khẩu",
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(kDefaultPaddingValue / 2),
                      child: Icon(Icons.lock),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () => {Get.to(ForgotPasswordScreen())},
                    child: const Text(
                      "Quên mật khẩu?",
                      style: TextStyle(
                        color: kPrimaryButtonColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: kDefaultPaddingValue),
              Hero(
                tag: "login_btn",
                child: ElevatedButton(
                  onPressed: () {
                    if (loginFormKey.currentState!.validate()) {
                      handleLogin(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: const [
                              // CircularProgressIndicator()
                              Text('Logging in'),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: kDefaultPaddingValue),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Đăng nhập".toUpperCase()),
                      ],
                    ),
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
                    // handleGLogin(context, "");
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const ContainerScreen();
                    }));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    alignment: Alignment.center,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: kDefaultPaddingValue / 2),
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
              SizedBox(height: isKeyboardVisible ? 160 : 40),
            ],
          ),
        );
      },
    );
  }
}
