import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:email_auth/email_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:sizer/sizer.dart';
import 'package:vnrdn_tai/controllers/auth_controller.dart';
import 'package:vnrdn_tai/screens/auth/components/change_forgot_password.dart';
import 'package:vnrdn_tai/screens/auth/forgot_password_screen.dart';
import 'package:vnrdn_tai/screens/auth/login_screen.dart';
import 'package:vnrdn_tai/screens/settings/change_password_screen.dart';
import 'package:vnrdn_tai/services/AuthService.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'package:vnrdn_tai/utils/dialog_util.dart';
import 'package:vnrdn_tai/utils/form_validator.dart';
import 'package:vnrdn_tai/widgets/templated_buttons.dart';

class VerifyMailScreen extends StatefulWidget {
  const VerifyMailScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<VerifyMailScreen> {
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
    AuthService().getUserByEmail(emailController.text).then((user) async {
      if (user.isNotEmpty && !user.contains('notfound')) {
        AuthController ac = Get.put(AuthController());
        ac.updateEmail(emailController.text);

        await emailAuth
            .sendOtp(recipientMail: emailController.text, otpLength: 6)
            .then(
          (res) {
            // ScaffoldMessenger.of(context).clearSnackBars();
            context.loaderOverlay.hide();
            if (res) {
              DialogUtil.showAwesomeDialog(
                  context,
                  DialogType.success,
                  "Thành công",
                  "Một mã xác nhận đã được gửi tới email của bạn.",
                  () => Get.to(() => const ForgotPasswordScreen()),
                  null);
            } else {
              DialogUtil.showAwesomeDialog(
                  context,
                  DialogType.error,
                  "Thất bại",
                  "Rất tiếc! Email xác nhận không thể gửi tới địa chỉ này.",
                  () {},
                  null);
            }
          },
        );
      } else {
        context.loaderOverlay.hide();
        // ScaffoldMessenger.of(context).clearSnackBars();
        DialogUtil.showAwesomeDialog(
            context,
            DialogType.error,
            "Thất bại",
            "Email không tồn tại trong hệ thống!\n Vui lòng kiểm tra lại thông tin.",
            () {},
            null);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final forgotFormKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: const Text("Quên mật khẩu"),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => Get.to(LoginScreen()),
            icon: const Icon(Icons.home),
          ),
        ],
      ),
      body: KeyboardVisibilityBuilder(
        builder: (kContext, isKeyboardVisible) {
          return Form(
            key: forgotFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Image.asset(
                      "assets/images/auth/verify_success.png",
                      scale: isKeyboardVisible ? 5 : 3,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: kDefaultPaddingValue),
                      child: TextFormField(
                        validator: ((value) => value!.isNotEmpty
                            ? FormValidator.validEmail(value)
                            : 'Bạn cần nhập email'),
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        cursorColor: kPrimaryButtonColor,
                        onSaved: (username) {},
                        decoration: const InputDecoration(
                          hintText: "Email",
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(kDefaultPaddingValue / 2),
                            child: Icon(Icons.email_outlined),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: isKeyboardVisible ? 10.h : 30.h,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: kDefaultPaddingValue),
                  child: Hero(
                    tag: "verify_btn",
                    child: ElevatedButton(
                      onPressed: emailController.text.isNotEmpty
                          ? () => {
                                if (forgotFormKey.currentState!.validate())
                                  {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus(),
                                    context.loaderOverlay.show(),
                                    sendEmail()
                                  }
                              }
                          : null,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: kDefaultPaddingValue),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Gửi mã xác nhận".toUpperCase()),
                          ],
                        ),
                      ),
                    ),
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
