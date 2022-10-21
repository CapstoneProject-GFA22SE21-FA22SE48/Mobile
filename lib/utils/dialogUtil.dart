import 'package:flutter/material.dart';

class DialogUtil {
  static void showAlertDialog(
      BuildContext context, String? title, content, List<Widget>? actions) {
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
}
