import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/screens/auth/login_screen.dart';
import 'package:vnrdn_tai/screens/settings/setting_screen.dart';
import 'package:vnrdn_tai/services/AuthService.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'package:vnrdn_tai/utils/dialogUtil.dart';
import 'package:vnrdn_tai/utils/form_validator.dart';
import 'package:vnrdn_tai/widgets/templated_buttons.dart';

class ChangeForgotPasswordScreen extends StatefulWidget {
  const ChangeForgotPasswordScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangeForgotPasswordScreen> {
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
          DialogUtil.showDCDialog(
              context,
              const Text(
                "Thất bại",
                style: TextStyle(
                  color: kDangerButtonColor,
                ),
              ),
              value,
              [TemplatedButtons.ok(context)]);
        } else {
          DialogUtil.showDCDialog(
              context,
              const Text(
                "Thành công",
                style: TextStyle(
                  color: kSuccessButtonColor,
                ),
              ),
              value,
              [TemplatedButtons.okWithscreen(context, const LoginScreen())]);
        }
      } else {
        DialogUtil.showDCDialog(
            context,
            const Text(
              "Thất bại",
              style: TextStyle(
                color: kDangerButtonColor,
              ),
            ),
            value,
            [TemplatedButtons.ok(context)]);
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
      body: Column(children: [
        // Image.asset(
        //   "assets/images/snapchat.png",
        //   fit: BoxFit.contain,
        // ),
        const SizedBox(
          height: 20.0,
        ),
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: kDefaultPaddingValue * 2),
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
                padding:
                    const EdgeInsets.symmetric(vertical: kDefaultPaddingValue),
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
                padding:
                    const EdgeInsets.symmetric(vertical: kDefaultPaddingValue),
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
                    handleChangeForgotPassword(newPasswordController.text);
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
    );
  }
}
