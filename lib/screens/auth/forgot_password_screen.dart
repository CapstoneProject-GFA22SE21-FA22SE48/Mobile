import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:email_auth/email_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:sizer/sizer.dart';
import 'package:vnrdn_tai/controllers/auth_controller.dart';
import 'package:vnrdn_tai/screens/auth/components/change_forgot_password.dart';
import 'package:vnrdn_tai/screens/auth/login_screen.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'package:vnrdn_tai/utils/dialog_util.dart';
import 'package:vnrdn_tai/widgets/templated_buttons.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPasswordScreen> {
  late String resendOtp = '';

  TextButton handleVerify(BuildContext context, Widget screen) {
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
      FocusManager.instance.primaryFocus?.unfocus();
      DialogUtil.showAwesomeDialog(
          context,
          DialogType.success,
          "Thành công",
          "Xác nhận thành công.",
          () => Get.off(
              () => const LoaderOverlay(child: ChangeForgotPasswordScreen())),
          () {});
    } else {
      DialogUtil.showAwesomeDialog(
          context, DialogType.error, "Thất bại", "Xác nhận thất bại.", () {
        resendOtp.isEmpty
            ? setState(() {
                resendOtp = 'Gửi lại mã xác nhận';
              })
            : () {};
      }, null);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
            onPressed: () => Get.offAll(() => const LoginScreen()),
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
                Container(
                  height: 6.h,
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                    onTap: () {},
                    child: Text(resendOtp),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
