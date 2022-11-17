import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/screens/auth/login_screen.dart';
import 'package:vnrdn_tai/services/AuthService.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'package:vnrdn_tai/utils/dialog_util.dart';
import 'package:vnrdn_tai/utils/form_validator.dart';
import 'package:vnrdn_tai/widgets/templated_buttons.dart';

class ChangeForgotPasswordScreen extends StatefulWidget {
  const ChangeForgotPasswordScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangeForgotPasswordScreen> {
  final changeForgotPasswordFormKey = GlobalKey<FormState>();
  final newPasswordController = TextEditingController();
  final newPasswordConfirmController = TextEditingController();

  GlobalController gc = Get.put(GlobalController());
  bool newObSecure = true;
  bool confirmObSecure = true;

  @override
  void dispose() {
    newPasswordController.dispose();
    newPasswordConfirmController.dispose();
    gc.updateNewObSecure(true);
    gc.updateConfirmObSecure(true);
    super.dispose();
  }

  void handleChangeForgotPassword(String newPassword) {
    AuthService().forgotPassword(newPassword).then((value) {
      if (value.isNotEmpty) {
        if (value.toLowerCase().contains('thất bại')) {
          DialogUtil.showAwesomeDialog(context, DialogType.error, "Thất bại",
              "Thay đổi mật khẩu thất bại. Vui lòng thử lại sau.", () {}, null);
        } else {
          DialogUtil.showAwesomeDialog(
              context,
              DialogType.success,
              "Thành công",
              value.isNotEmpty
                  ? value
                  : "Thay đổi mật khẩu thành công. Mời bạn đăng nhập để tiếp tục.",
              () => Get.off(() => const LoginScreen()),
              () {});
        }
      } else {
        DialogUtil.showAwesomeDialog(context, DialogType.error, "Thất bại",
            "Thay đổi mật khẩu thất bại. Vui lòng thử lại sau.", () {}, null);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    newObSecure = gc.newObSecure.value;
    confirmObSecure = gc.confirmObSecure.value;

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: const Text("Đổi mật khẩu"),
        elevation: 0,
      ),
      body: KeyboardVisibilityBuilder(
        key: UniqueKey(),
        builder: (p0, isKeyboardVisible) => Form(
          key: changeForgotPasswordFormKey,
          child: Column(children: [
            const SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: kDefaultPaddingValue * 2),
              child: Column(
                children: [
                  const Text(
                    'Mời bạn đổi mật khẩu mới',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: FONTSIZES.textLarger,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: kDefaultPaddingValue),
                    child: TextFormField(
                      validator: (value) => FormValidator.validPassword(value),
                      controller: newPasswordController,
                      obscureText: gc.newObSecure.value,
                      textInputAction: TextInputAction.done,
                      cursorColor: kPrimaryButtonColor,
                      decoration: InputDecoration(
                        labelText: "Mật khẩu mới",
                        hintText: "Mật khẩu mới",
                        prefixIcon: const Padding(
                          padding: EdgeInsets.all(kDefaultPaddingValue / 2),
                          child: Icon(Icons.lock),
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () => setState(
                            () {
                              newObSecure = !newObSecure;
                              gc.updateNewObSecure(newObSecure);
                            },
                          ),
                          child: Icon(newObSecure
                              ? Icons.visibility_off_rounded
                              : Icons.visibility_rounded),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: kDefaultPaddingValue),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: kDefaultPaddingValue),
                    child: TextFormField(
                      validator: (value) => FormValidator.validPasswordConfirm(
                          newPasswordController.text, value),
                      controller: newPasswordConfirmController,
                      obscureText: gc.confirmObSecure.value,
                      textInputAction: TextInputAction.done,
                      cursorColor: kPrimaryButtonColor,
                      decoration: InputDecoration(
                        labelText: "Xác nhận mật khẩu mới",
                        hintText: "Xác nhận mật khẩu mới",
                        prefixIcon: const Padding(
                          padding: EdgeInsets.all(kDefaultPaddingValue / 2),
                          child: Icon(Icons.lock),
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () => setState(
                            () {
                              confirmObSecure = !confirmObSecure;
                              gc.updateConfirmObSecure(confirmObSecure);
                            },
                          ),
                          child: Icon(confirmObSecure
                              ? Icons.visibility_off_rounded
                              : Icons.visibility_rounded),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: kDefaultPaddingValue),
                  Hero(
                    tag: "change_btn",
                    child: ElevatedButton(
                      onPressed: () {
                        if (changeForgotPasswordFormKey.currentState!
                            .validate()) {
                          handleChangeForgotPassword(
                              newPasswordController.text);
                        }
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
          ]),
        ),
      ),
    );
  }
}
