import 'package:email_auth/email_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:vnrdn_tai/controllers/auth_controller.dart';
import 'package:vnrdn_tai/screens/auth/components/change_forgot_password.dart';
import 'package:vnrdn_tai/screens/auth/login_screen.dart';
import 'package:vnrdn_tai/screens/settings/change_password_screen.dart';
import 'package:vnrdn_tai/services/AuthService.dart';
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
  @override
  void dispose() {
    super.dispose();
  }

  TextButton handleVerify(BuildContext context, Widget screen) {
    AuthController ac = Get.put(AuthController());
    return TextButton(
      style: TemplatedButtons().confirmStyle,
      onPressed: () {
        Navigator.pop(context, 'OK');
        Get.to(screen);
      },
      child: const Text(
        "OK",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  void verifyOTP(String verificationCode) {
    AuthController ac = Get.put(AuthController());
    EmailAuth emailAuth = EmailAuth(sessionName: "forgot_password_session");
    dynamic res = emailAuth.validateOtp(
        recipientMail: ac.email.value, userOtp: verificationCode);

    if (res) {
      DialogUtil.showTextDialog(context, "Thành công", "Xác nhận thành công.", [
        handleVerify(context, ChangeForgotPasswordScreen()),
      ]);
    } else {
      DialogUtil.showTextDialog(context, "Thất bại", "Xác nhận thất bại.",
          [TemplatedButtons.ok(context)]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final _forgotFormKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: const Text("Quên mật khẩu"),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () => Get.offAll(LoginScreen()),
          ),
        ],
      ),
      body: KeyboardVisibilityBuilder(
        builder: (context, isKeyboardVisible) {
          return Form(
            key: _forgotFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: kDefaultPaddingValue),
                  child: Image.asset(
                    "assets/images/auth/verify_success.png",
                    scale: 3,
                  ),
                ),
                OtpTextField(
                  numberOfFields: 6,
                  autoFocus: true,
                  borderColor: const Color.fromARGB(255, 65, 93, 255),
                  borderWidth: 3.6,
                  cursorColor: Colors.blueAccent,
                  showFieldAsBox: true,
                  onSubmit: (String verificationCode) {
                    verifyOTP(verificationCode);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
