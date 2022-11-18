import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:vnrdn_tai/shared/constants.dart';

class DialogUtil {
  static void showTextDialog(BuildContext context, String title,
      String? content, List<Widget>? actions) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.pop(context, 'OK');
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text('$title'),
      content: Text('$content'),
      actions: actions ??
          [
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

  // show dynamic content
  static void showDCDialog(BuildContext context, Widget title, String? content,
      List<Widget>? actions) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.pop(context, 'OK');
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: title,
      content: Text('$content'),
      actions: actions ??
          [
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

  static void showAwesomeDialog(
      BuildContext context,
      DialogType type,
      String title,
      String desc,
      Function okCallback,
      Function? cancelCallback) {
    AwesomeDialog(
      context: context,
      dialogType: type,
      animType: AnimType.rightSlide,
      title: title,
      titleTextStyle: const TextStyle(
          fontWeight: FontWeight.bold, fontSize: FONTSIZES.textLarge),
      desc: desc,
      btnCancelText: 'Huỷ',
      btnOkText: 'Đồng ý',
      descTextStyle: const TextStyle(fontSize: FONTSIZES.textMediumLarge),
      btnOkOnPress: () {},
      btnCancelOnPress: cancelCallback != null ? () {} : null,
      onDismissCallback: (type) {
        if (type == DismissType.btnOk) {
          okCallback();
        } else if (cancelCallback != null) {
          cancelCallback();
        }
      },
    ).show();
  }

  static Text failedText(String text) => Text(
        text,
        style: const TextStyle(
          color: kDangerButtonColor,
        ),
      );
  static Text successText(String text) => Text(
        text,
        style: const TextStyle(
          color: kSuccessButtonColor,
        ),
      );
  static Text primaryText(String text) => Text(
        text,
        style: const TextStyle(
          color: kPrimaryButtonColor,
        ),
      );
  static Text alertText(String text) => Text(
        text,
        style: const TextStyle(
          color: kWarningButtonColor,
        ),
      );
}
