import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/screens/auth/components/or_divider.dart';
import 'package:vnrdn_tai/screens/auth/components/verify_mail_screen.dart';
import 'package:vnrdn_tai/screens/container_screen.dart';
import 'package:vnrdn_tai/services/AuthService.dart';

import 'package:vnrdn_tai/screens/auth/components/already_have_an_account_acheck.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'package:vnrdn_tai/utils/form_validator.dart';
import 'package:vnrdn_tai/utils/io_utils.dart';
import 'package:vnrdn_tai/utils/dialog_util.dart';
import 'package:vnrdn_tai/widgets/templated_buttons.dart';
import '../signup_screen.dart';

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

  late String guessContinue = '';

  GlobalController gc = Get.put(GlobalController());
  bool oldObSecure = true;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    usernameController.dispose();
    passwordController.dispose();
    gc.updateOldObSecure(true);
    super.dispose();
  }

  // handle login
  void handleLogin(BuildContext context) async {
    FocusManager.instance.primaryFocus?.unfocus();
    await AuthService()
        .loginWithUsername(usernameController.text, passwordController.text)
        .then(((token) {
      if (token.length > 1) {
        ScaffoldMessenger.of(context).clearSnackBars();
        afterLoggedIn(context, token);
      } else {
        DialogUtil.showAwesomeDialog(context, DialogType.error, "Thất bại",
            "Sai tên đăng nhập hoặc mật khẩu.", () {}, null);
      }
    }));
  }

  void handleGLogin(BuildContext context) async {
    FocusManager.instance.primaryFocus?.unfocus();
    DialogUtil.showTextDialog(context, "Thông báo",
        "Chức năng hiện không khả dụng!", [TemplatedButtons.ok(context)]);
    // await AuthService().loginWithGmail(gmail).then(((token) => {
    //       if (token.length > 1)
    //         {afterLoggedIn(context, token)}
    //       else
    //         {
    //           DialogUtil.showTextDialog(context, "Đăng nhập thất bại",
    //               "Sai tên đăng nhập hoặc mật khẩu.", null)
    //         }
    //     }));
  }

  // do after logged in
  void afterLoggedIn(BuildContext context, String token) async {
    await IOUtils.saveToStorage('token', token);
    IOUtils.setUserInfoController(token)
        ? Get.to(() => const ContainerScreen())
        // ignore: use_build_context_synchronously
        : DialogUtil.showAwesomeDialog(
            context,
            DialogType.error,
            "Thất bại",
            "Một lỗi không mong muốn đã xảy ra.\nMời bạn đăng nhập lại.",
            () {},
            null);
  }

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      setState(() {
        guessContinue = 'Tiếp tục với tư cách khách';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    oldObSecure = gc.oldObSecure.value;

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
                  obscureText: gc.oldObSecure.value,
                  textInputAction: TextInputAction.done,
                  cursorColor: kPrimaryButtonColor,
                  decoration: InputDecoration(
                    labelText: "Mật khẩu",
                    hintText: "Mật khẩu",
                    prefixIcon: const Padding(
                      padding: EdgeInsets.all(kDefaultPaddingValue / 2),
                      child: Icon(Icons.lock),
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () => setState(
                        () {
                          oldObSecure = !oldObSecure;
                          gc.updateOldObSecure(oldObSecure);
                        },
                      ),
                      child: Icon(oldObSecure
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () => {Get.to(const VerifyMailScreen())},
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
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: const [
                              // CircularProgressIndicator()
                              Text('Đang xử lí'),
                            ],
                          ),
                        ),
                      );
                      isKeyboardVisible = false;
                      handleLogin(context);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: kDefaultPaddingValue),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Đăng nhập".toUpperCase(),
                          textScaleFactor: 1.1,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: kDefaultPaddingValue / 2),
              const OrDivider(),
              const SizedBox(height: kDefaultPaddingValue / 2),
              Hero(
                tag: "g_login_btn",
                child: ElevatedButton(
                  onPressed: () => handleGLogin(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    alignment: Alignment.center,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: kDefaultPaddingValue - 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/auth/google.png', width: 32),
                        const SizedBox(width: kDefaultPaddingValue * 2),
                        const Text(
                          "Đăng nhập với Google",
                          textScaleFactor: 1.2,
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
              const SizedBox(height: kDefaultPaddingValue * 2),
              SizedBox(
                height: 3.h,
                child: guessContinue.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          Get.to(() => const ContainerScreen());
                        },
                        child: Text(
                          guessContinue,
                          style: const TextStyle(
                            color: kDisabledTextColor,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      )
                    : Container(),
              ),
              SizedBox(height: isKeyboardVisible ? 32.h : 1.h),
            ],
          ),
        );
      },
    );
  }
}
