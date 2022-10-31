import 'package:email_auth/email_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:vnrdn_tai/controllers/auth_controller.dart';
import 'package:vnrdn_tai/screens/auth/login_screen.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'package:vnrdn_tai/utils/dialogUtil.dart';
import 'package:vnrdn_tai/widgets/templated_buttons.dart';

class MailVerifyScreen extends StatefulWidget {
  const MailVerifyScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MailVerifyState();
}

class _MailVerifyState extends State<MailVerifyScreen> {
  final otpController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    otpController.dispose();
    super.dispose();
  }

  void sendEmail() async {
    EmailAuth emailAuth = EmailAuth(sessionName: "forgot_password_session");
    emailAuth.config({
      "server":
          "https://vnrdntai-default-rtdb.asia-southeast1.firebasedatabase.app/",
      "serverKey":
          "AAAAMXHGdIY:APA91bEI8dkyaYPFl0jOdLtz2lC-JHpwXEGN01I2J_nNahkZwTovBhO_pWWTmN8QgCR_9T4dQid8UmVVBINmVcqkjN6MBZQgW7CdrSklu_clOQG-o8StDJSFqIIwXB96N4RVJdUoopLw"
    });
  }

  Future<bool> verifyOTP() async {
    AuthController ac = Get.put(AuthController());
    EmailAuth emailAuth = EmailAuth(sessionName: "verify session");
    return emailAuth.validateOtp(
        recipientMail: ac.email.value, userOtp: otpController.text);
  }

  void handleVerify(BuildContext context) {
    verifyOTP().then((res) {
      if (res) {
        print("OTP Verified.");
        DialogUtil.showTextDialog(context, "Thành công",
            "Xác nhận thành công. Mời bạn đăng nhập để tiếp tục.", [
          afterVerified(context, LoginScreen()),
        ]);
      } else {
        print("OTP is Invalid.");
        DialogUtil.showTextDialog(context, "Thất bại", "Xác nhận thất bại.",
            [TemplatedButtons.ok(context)]);
      }
    });
  }

  TextButton afterVerified(BuildContext context, Widget screen) {
    AuthController ac = Get.put(AuthController());
    return TextButton(
      style: TemplatedButtons().confirmStyle,
      onPressed: () {
        ac.updateStatus(5);
        Navigator.pop(context, 'OK');
        Get.to(screen);
      },
      child: const Text(
        "OK",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text("Verify Account"),
      ),
      body: KeyboardVisibilityBuilder(
        builder: (context, isKeyboardVisible) {
          return Column(children: [
            Padding(
              padding: kDefaultPadding * 2,
              child: Image.asset(
                "assets/images/snapchat.png",
                scale: isKeyboardVisible ? 2 : 0.5,
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.all(kDefaultPaddingValue),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: kDefaultPaddingValue),
                    child: TextFormField(
                      controller: otpController,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.number,
                      cursorColor: kPrimaryButtonColor,
                      decoration: InputDecoration(
                        labelText: "Mã xác nhận",
                        hintText: "Mã xác nhận",
                        prefixIcon: const Padding(
                          padding: EdgeInsets.all(kDefaultPaddingValue / 2),
                          child: Icon(Icons.lock),
                        ),
                        suffixIcon: TextButton(
                          onPressed: () {},
                          child: const Text("Gửi lại OTP"),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: kDefaultPaddingValue),
                  Hero(
                    tag: "verify_btn",
                    child: ElevatedButton(
                      onPressed: () {
                        handleVerify(context);
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
          ]);
        },
      ),
    );
  }
}
