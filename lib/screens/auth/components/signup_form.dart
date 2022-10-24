import 'package:email_auth/email_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:vnrdn_tai/controllers/auth_controller.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/screens/auth/components/already_have_an_account_acheck.dart';
import 'package:vnrdn_tai/screens/auth/verify_screen.dart';
import 'package:vnrdn_tai/screens/container_screen.dart';
import 'package:vnrdn_tai/services/AuthService.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'package:vnrdn_tai/utils/dialogUtil.dart';
import 'package:vnrdn_tai/utils/form_validator.dart';
import 'package:vnrdn_tai/widgets/templated_buttons.dart';
import '../login_screen.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    Key? key,
  }) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final registerFormKey = GlobalKey<FormState>();

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();
  final emailController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    usernameController.dispose();
    passwordController.dispose();
    passwordConfirmController.dispose();
    emailController.dispose();
    super.dispose();
  }

  TextButton yes(BuildContext context) {
    return TextButton(
      style: TemplatedButtons().confirmStyle,
      onPressed: () {
        Navigator.pop(context, 'YES');
        handleRegister(context);
      },
      child: const Text(
        "YES",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  void noEmailConfirm() {
    DialogUtil.showTextDialog(
        context,
        "Không có Email",
        "Nếu không có email bạn sẽ không thể sử dụng quên mật khẩu.\nBạn có muốn tiếp tục?",
        [yes(context), TemplatedButtons.no(context)]);
  }

  Future<bool> sendEmail() async {
    EmailAuth emailAuth = EmailAuth(sessionName: "verify session");

    emailAuth.config({
      "server": "https://api.smtp2go.com/v3/",
      "serverKey": "api-7246DDBA535811ED855EF23C91C88F4E"
    });
    return await emailAuth
        .sendOtp(recipientMail: emailController.text, otpLength: 6)
        .then((value) => value ? true : false);
  }

  // handle login
  void handleRegister(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            // CircularProgressIndicator()
            Text('Registering'),
          ],
        ),
      ),
    );
    await AuthService()
        .register(usernameController.text, passwordController.text,
            emailController.text.isNotEmpty ? emailController.text : null)
        .then(((value) => {
              if (value.length > 1)
                {afterRegistered(value)}
              else
                {
                  // need fix content
                  DialogUtil.showTextDialog(context, "Đăng ký thất bại", value,
                      [TemplatedButtons.ok(context)])
                }
            }));
  }

  // do after logged in
  void afterRegistered(String user) async {
    if (emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              // CircularProgressIndicator()
              Text('Registered successful.'),
            ],
          ),
        ),
      );

      Get.to(const LoginScreen());
    } else {
      AuthController ac = Get.put(AuthController());
      ac.updateEmail(emailController.text);
      sendEmail().then((value) {
        if (value) {
          DialogUtil.showDCDialog(
              context,
              const Text(
                "Thành công",
                style: TextStyle(
                  color: kSuccessButtonColor,
                ),
              ),
              "Đăng ký thành công!\nMời bạn xác nhận email để kích hoạt tài khoản",
              [
                TemplatedButtons.okWithscreen(context, const MailVerifyScreen())
              ]);
        } else {
          DialogUtil.showDCDialog(
              context,
              const Text(
                "Thất bại",
                style: TextStyle(
                  color: kDangerButtonColor,
                ),
              ),
              "Đăng ký thất bại!\nXin thử lại sau.",
              [TemplatedButtons.ok(context)]);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        return Form(
          key: registerFormKey,
          child: Column(
            children: [
              TextFormField(
                validator: (value) {
                  return FormValidator.validUsername(value);
                },
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
                padding: const EdgeInsets.symmetric(
                    vertical: kDefaultPaddingValue / 2),
                child: TextFormField(
                  validator: (value) {
                    return FormValidator.validPassword(value);
                  },
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
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: kDefaultPaddingValue / 2),
                child: TextFormField(
                  validator: (value) {
                    return FormValidator.validPasswordConfirm(
                        value, passwordController.text);
                  },
                  controller: passwordConfirmController,
                  textInputAction: TextInputAction.done,
                  obscureText: true,
                  cursorColor: kPrimaryButtonColor,
                  decoration: const InputDecoration(
                    labelText: "Xác nhận mật khẩu",
                    hintText: "Xác nhận mật khẩu",
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(kDefaultPaddingValue / 2),
                      child: Icon(Icons.lock),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: kDefaultPaddingValue / 2),
                child: TextFormField(
                  validator: (value) {
                    return FormValidator.validEmail(value);
                  },
                  controller: emailController,
                  textInputAction: TextInputAction.done,
                  cursorColor: kPrimaryButtonColor,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    hintText: "Email",
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(kDefaultPaddingValue / 2),
                      child: Icon(Icons.mail),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: kDefaultPaddingValue),
              Hero(
                tag: "login_btn",
                child: ElevatedButton(
                  onPressed: () {
                    if (registerFormKey.currentState!.validate()) {
                      if (emailController.text.isNotEmpty) {
                        handleRegister(context);
                      } else {
                        noEmailConfirm();
                      }
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: kDefaultPaddingValue),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Đăng ký".toUpperCase(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: kDefaultPaddingValue * 2),
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
              SizedBox(
                height: isKeyboardVisible ? 160 : 40,
              ),
            ],
          ),
        );
      },
    );
  }
}
