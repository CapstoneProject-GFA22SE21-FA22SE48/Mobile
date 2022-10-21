import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:vnrdn_tai/screens/auth/components/already_have_an_account_acheck.dart';
import 'package:vnrdn_tai/screens/container_screen.dart';
import 'package:vnrdn_tai/services/AuthService.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'package:vnrdn_tai/utils/dialogUtil.dart';
import 'package:vnrdn_tai/utils/io_utils.dart';
import '../login_screen.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    Key? key,
  }) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();
  final emailController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.pop(context, 'OK');
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Đăng nhập thất bại"),
      content: Text('${usernameController.text}, ${passwordController.text}'),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  // handle login
  void handleLogin(BuildContext context) async {
    if (usernameController.text != "" && passwordController.text != "") {
      String token = '';
      await AuthService()
          .loginWithUsername(usernameController.text, passwordController.text)
          .then(((value) => {token = value}));
      if (token.length > 1) {
        afterLoggedIn(token);
        await IOUtils.getFromStorage("token").then((value) => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const ContainerScreen();
                  },
                ),
              )
            });
        // DialogUtil.showAlertDialog(context, "token", token);
      } else {
        // ignore: use_build_context_synchronously
        DialogUtil.showAlertDialog(context, "Đăng nhập thất bại",
            "Sai tên đăng nhập hoặc mật khẩu.", null);
      }
    }
  }

  // do after logged in
  Future<bool> afterLoggedIn(String token) async {
    IOUtils.saveToStorage('token', token);
    Jwt.parseJwt(token).forEach((key, value) {
      IOUtils.saveToStorage(key, value);
    });
    print(IOUtils.getFromStorage('username').then((value) => value.isNotEmpty));
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            controller: usernameController,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryButtonColor,
            onSaved: (username) {},
            decoration: const InputDecoration(
              hintText: "Tên đăng nhập",
              prefixIcon: Padding(
                padding: EdgeInsets.all(kDefaultPaddingValue / 2),
                child: Icon(Icons.person),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: kDefaultPaddingValue),
            child: TextFormField(
              controller: passwordController,
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: kPrimaryButtonColor,
              decoration: const InputDecoration(
                hintText: "Mật khẩu",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(kDefaultPaddingValue / 2),
                  child: Icon(Icons.lock),
                ),
              ),
            ),
          ),
          const SizedBox(height: kDefaultPaddingValue),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: kDefaultPaddingValue),
            child: TextFormField(
              controller: passwordController,
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: kPrimaryButtonColor,
              decoration: const InputDecoration(
                hintText: "Xác nhận mật khẩu",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(kDefaultPaddingValue / 2),
                  child: Icon(Icons.lock),
                ),
              ),
            ),
          ),
          const SizedBox(height: kDefaultPaddingValue),
          TextFormField(
            textInputAction: TextInputAction.done,
            obscureText: true,
            cursorColor: kPrimaryButtonColor,
            decoration: const InputDecoration(
              hintText: "Email",
              prefixIcon: Padding(
                padding: EdgeInsets.all(kDefaultPaddingValue / 2),
                child: Icon(Icons.mail),
              ),
            ),
          ),
          const SizedBox(height: kDefaultPaddingValue),
          Hero(
            tag: "login_btn",
            child: ElevatedButton(
              onPressed: () {
                handleLogin(context);
              },
              child: Text(
                "Đăng ký".toUpperCase(),
              ),
            ),
          ),
          const SizedBox(height: kDefaultPaddingValue * 2),
          AlreadyHaveAnAccountCheck(
            login: false,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const LoginScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
