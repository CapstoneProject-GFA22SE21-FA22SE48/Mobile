import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/screens/settings/setting_screen.dart';
import 'package:vnrdn_tai/services/AuthService.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'package:vnrdn_tai/utils/dialog_util.dart';
import 'package:vnrdn_tai/utils/form_validator.dart';
import 'package:vnrdn_tai/widgets/templated_buttons.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePasswordScreen> {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final newPasswordConfirmController = TextEditingController();

  GlobalController gc = Get.put(GlobalController());
  bool oldObSecure = true;
  bool newObSecure = true;
  bool confirmObSecure = true;

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    newPasswordConfirmController.dispose();
    gc.updateOldObSecure(true);
    gc.updateNewObSecure(true);
    gc.updateConfirmObSecure(true);
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
    oldObSecure = gc.oldObSecure.value;
    newObSecure = gc.newObSecure.value;
    confirmObSecure = gc.confirmObSecure.value;

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
                controller: oldPasswordController,
                obscureText: gc.oldObSecure.value,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                cursorColor: kPrimaryButtonColor,
                onSaved: (username) {},
                decoration: InputDecoration(
                  labelText: "Mật khẩu hiện tại",
                  hintText: "Mật khẩu hiện tại",
                  prefixIcon: const Padding(
                    padding: EdgeInsets.all(kDefaultPaddingValue / 2),
                    child: Icon(Icons.lock),
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () => setState(
                      () {
                        oldObSecure = !oldObSecure;
                        gc.updateOldObSecure(oldObSecure);
                      },
                    ),
                    child: Icon(oldObSecure
                        ? Icons.visibility_off_rounded
                        : Icons.visibility_rounded),
                  ),
                ),
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
