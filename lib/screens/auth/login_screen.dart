import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/screens/container_screen.dart';
import 'package:vnrdn_tai/shared/responsive.dart';
import 'package:vnrdn_tai/shared/background.dart';
import 'package:vnrdn_tai/utils/io_utils.dart';

import 'components/login_form.dart';
import 'components/login_screen_top_image.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  void onInit() {
    // need call shared pref instead
    GlobalController gc = Get.put(GlobalController());

    // String token = IOUtils.getFromStorage("token") as String;

    gc.userId.isNotEmpty ? Get.to(const ContainerScreen()) : () {};
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      child: SingleChildScrollView(
        child: Responsive(
          mobile: MobileLoginScreen(pContext: context),
          desktop: const DesktopLoginScreen(),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class MobileLoginScreen extends StatefulWidget {
  BuildContext pContext;
  MobileLoginScreen({Key? key, required this.pContext}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MobileLoginState();
}

class _MobileLoginState extends State<MobileLoginScreen> {
  @override
  Widget build(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const LoginScreenTopImage(),
        Row(
          children: [
            const Spacer(),
            Expanded(
              flex: 8,
              child: LoaderOverlay(
                child: LoginForm(parentContext: widget.pContext),
              ),
            ),
            const Spacer(),
          ],
        ),
      ],
    );
  }
}

class DesktopLoginScreen extends StatelessWidget {
  const DesktopLoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      const Expanded(
        child: LoginScreenTopImage(),
      ),
      Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 450,
              child: LoaderOverlay(child: LoginForm(parentContext: context)),
            ),
          ],
        ),
      ),
    ]);
  }
}
