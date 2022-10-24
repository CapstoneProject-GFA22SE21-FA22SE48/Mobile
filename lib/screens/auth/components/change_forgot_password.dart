import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    super.dispose();
  }

  void handleChangePassword(String oldPassword, String newPassword) {
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
    return Scaffold(
      backgroundColor: kPrimaryBackgroundColor,
      appBar: AppBar(
        title: const Text("Change Password"),
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
          padding: const EdgeInsets.all(kDefaultPaddingValue),
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: kDefaultPaddingValue),
                child: TextFormField(
                  validator: (value) => FormValidator.validPassword(value),
                  controller: newPasswordController,
                  textInputAction: TextInputAction.done,
                  cursorColor: kPrimaryButtonColor,
                  decoration: const InputDecoration(
                    labelText: "Mật khẩu mới",
                    hintText: "Mật khẩu mới",
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(kDefaultPaddingValue / 2),
                      child: Icon(Icons.lock),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: kDefaultPaddingValue),
              Hero(
                tag: "change_btn",
                child: ElevatedButton(
                  onPressed: () {
                    handleChangePassword(
                        oldPasswordController.text, newPasswordController.text);
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
