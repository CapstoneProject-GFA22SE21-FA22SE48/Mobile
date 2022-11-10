import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:vnrdn_tai/controllers/auth_controller.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/screens/settings/setting_screen.dart';
import 'package:vnrdn_tai/services/AuthService.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'package:vnrdn_tai/utils/dialogUtil.dart';
import 'package:vnrdn_tai/utils/form_validator.dart';
import 'package:vnrdn_tai/widgets/templated_buttons.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ProfileScreen> {
  final displayNameController = TextEditingController();
  final emailController = TextEditingController();
  final newPasswordConfirmController = TextEditingController();

  GlobalController gc = Get.put(GlobalController());
  AuthController ac = Get.put(AuthController());

  @override
  void dispose() {
    displayNameController.dispose();
    emailController.dispose();
    newPasswordConfirmController.dispose();
    super.dispose();
  }

  void handleChangePassword(String oldPassword, String newPassword) {
    AuthService().changePassword(oldPassword, newPassword).then((value) {
      if (value.isNotEmpty) {
        if (value.toLowerCase().contains('không đúng') || value.isEmpty) {
          // oldP is wrong
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
          // password changed
          DialogUtil.showDCDialog(
              context,
              const Text(
                "Thành công",
                style: TextStyle(
                  color: kSuccessButtonColor,
                ),
              ),
              value,
              [TemplatedButtons.okWithscreen(context, const SettingsScreen())]);
        }
      } else {
        // Something went wrong
        DialogUtil.showDCDialog(
            context,
            const Text(
              "Thất bại",
              style: TextStyle(
                color: kDangerButtonColor,
              ),
            ),
            value.isNotEmpty ? value : 'Thông tin người dùng không khớp.',
            [TemplatedButtons.ok(context)]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: UniqueKey(),
      backgroundColor: kPrimaryBackgroundColor,
      appBar: AppBar(
        title: const Text("Change Password"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
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
              TextFormField(
                validator: (value) => FormValidator.validPassword(value),
                controller: displayNameController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                cursorColor: kPrimaryButtonColor,
                onSaved: (username) {},
                decoration: InputDecoration(
                  labelText: "Tên hiển thị",
                  hintText: ac.displayName.value,
                  prefixIcon: const Padding(
                    padding: EdgeInsets.all(kDefaultPaddingValue / 2),
                    child: Icon(Icons.lock),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: kDefaultPaddingValue),
                child: TextFormField(
                  validator: (value) => FormValidator.validPassword(value),
                  controller: emailController,
                  textInputAction: TextInputAction.done,
                  cursorColor: kPrimaryButtonColor,
                  decoration: InputDecoration(
                    labelText: "Email",
                    hintText: ac.email.value,
                    prefixIcon: const Padding(
                      padding: EdgeInsets.all(kDefaultPaddingValue / 2),
                      child: Icon(Icons.mail_outline_rounded),
                    ),
                  ),
                ),
              ),
              // Padding(
              //   padding:
              //       const EdgeInsets.symmetric(vertical: kDefaultPaddingValue),
              //   child: TextFormField(
              //     validator: (value) => FormValidator.validPasswordConfirm(
              //         emailController.text, value),
              //     controller: newPasswordConfirmController,
              //     textInputAction: TextInputAction.done,
              //     cursorColor: kPrimaryButtonColor,
              //     decoration: InputDecoration(
              //       labelText: "Tên đăng nhập",
              //       hintText: gc.username.value,
              //       prefixIcon: const Padding(
              //         padding: EdgeInsets.all(kDefaultPaddingValue / 2),
              //         child: Icon(Icons.lock),
              //       ),
              //     ),
              //   ),
              // ),
              const SizedBox(height: kDefaultPaddingValue),
              Hero(
                tag: "update_btn",
                child: ElevatedButton(
                  onPressed: () {
                    handleChangePassword(
                        displayNameController.text, emailController.text);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: kDefaultPaddingValue),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Cập nhật ngay".toUpperCase()),
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
