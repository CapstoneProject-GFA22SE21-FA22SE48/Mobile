import 'package:email_auth/email_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:vnrdn_tai/controllers/auth_controller.dart';
import 'package:vnrdn_tai/screens/auth/components/change_forgot_password.dart';
import 'package:vnrdn_tai/screens/auth/login_screen.dart';
import 'package:vnrdn_tai/screens/settings/change_password_screen.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'package:vnrdn_tai/utils/dialogUtil.dart';
import 'package:vnrdn_tai/utils/form_validator.dart';
import 'package:vnrdn_tai/widgets/templated_buttons.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();
  final otpController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    otpController.dispose();
    super.dispose();
  }

  TextButton handleVerify(BuildContext context, Widget screen) {
    AuthController ac = Get.put(AuthController());
    return TextButton(
      style: TemplatedButtons().confirmStyle,
      onPressed: () {
        ac.updateEmail(emailController.text);
        Navigator.pop(context, 'OK');
        Get.to(screen);
      },
      child: const Text(
        "OK",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  void sendEmail() async {
    EmailAuth emailAuth = EmailAuth(sessionName: "forgot_password_session");
    emailAuth.config({
      "server":
          "https://vnrdntai-default-rtdb.asia-southeast1.firebasedatabase.app/",
      "serverKey":
          "AAAAMXHGdIY:APA91bEI8dkyaYPFl0jOdLtz2lC-JHpwXEGN01I2J_nNahkZwTovBhO_pWWTmN8QgCR_9T4dQid8UmVVBINmVcqkjN6MBZQgW7CdrSklu_clOQG-o8StDJSFqIIwXB96N4RVJdUoopLw"
    });

    AuthController ac = Get.put(AuthController());
    ac.updateEmail(emailController.text);

    await emailAuth
        .sendOtp(recipientMail: emailController.text, otpLength: 6)
        .then(
      (res) {
        if (res) {
          print("OTP Sent.");
          DialogUtil.showTextDialog(
              context,
              "Thành công",
              "Một mã xác nhận đã được gửi tới email của bạn.",
              [TemplatedButtons.ok(context)]);
        } else {
          print("OTP could not sent.");
          DialogUtil.showTextDialog(
              context,
              "Thất bại",
              "Rất tiếc! Email xác nhận không thể gửi tới địa chỉ này.",
              [TemplatedButtons.ok(context)]);
        }
      },
    );
  }

  void verifyOTP() {
    EmailAuth emailAuth = EmailAuth(sessionName: "forgot_password_session");
    dynamic res = emailAuth.validateOtp(
        recipientMail: emailController.text, userOtp: otpController.text);

    if (res) {
      print("OTP Verified.");
      DialogUtil.showTextDialog(context, "Thành công", "Xác nhận thành công.", [
        handleVerify(context, ChangeForgotPasswordScreen()),
      ]);
    } else {
      print("OTP is Invalid.");
      DialogUtil.showTextDialog(context, "Thất bại", "Xác nhận thất bại.",
          [TemplatedButtons.ok(context)]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final _forgotFormKey = GlobalKey<FormState>();

    return Scaffold(
        backgroundColor: kPrimaryBackgroundColor,
        appBar: AppBar(
          title: const Text("Quên mật khẩu"),
          actions: [
            IconButton(
                icon: Icon(Icons.home), onPressed: () => Get.to(LoginScreen())),
          ],
        ),
        body: KeyboardVisibilityBuilder(
          builder: (context, isKeyboardVisible) {
            return Form(
              key: _forgotFormKey,
              child: Column(
                children: [
                  Padding(
                    padding: kDefaultPadding * 2,
                    child: Image.asset(
                      "assets/images/snapchat.png",
                      scale: isKeyboardVisible ? 5 : 2,
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(kDefaultPaddingValue),
                    child: Column(
                      children: [
                        TextFormField(
                          validator: ((value) => value!.isNotEmpty
                              ? FormValidator.validEmail(value)
                              : 'Bạn cần nhập email'),
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          cursorColor: kPrimaryButtonColor,
                          onSaved: (username) {},
                          decoration: InputDecoration(
                            hintText: "Email",
                            prefixIcon: const Padding(
                              padding: EdgeInsets.all(kDefaultPaddingValue / 2),
                              child: Icon(Icons.person),
                            ),
                            suffixIcon: TextButton(
                              onPressed: () => {
                                if (_forgotFormKey.currentState!.validate())
                                  {sendEmail()}
                              },
                              child: const Text("Gửi OTP"),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: kDefaultPaddingValue),
                          child: TextFormField(
                            controller: otpController,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.number,
                            cursorColor: kPrimaryButtonColor,
                            decoration: const InputDecoration(
                              hintText: "OTP",
                              prefixIcon: Padding(
                                padding:
                                    EdgeInsets.all(kDefaultPaddingValue / 2),
                                child: Icon(Icons.lock),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: kDefaultPaddingValue),
                        Hero(
                          tag: "verify_btn",
                          child: ElevatedButton(
                            onPressed: () {
                              verifyOTP();
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: kDefaultPaddingValue),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Xác nhận".toUpperCase()),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ));
  }
}
