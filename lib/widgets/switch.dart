import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SwitchButton extends StatefulWidget {
  final bool isSwitched;
  const SwitchButton({super.key, required this.isSwitched});

  @override
  SwitchClass createState() => SwitchClass();
}

class SwitchClass extends State {
  bool isSwitched = false;
  @override
  Widget build(BuildContext context) {
    return CupertinoSwitch(
      dragStartBehavior: DragStartBehavior.start,
      value: isSwitched,
      activeColor: Colors.blueAccent,
      onChanged: (value) {
        print("VALUE : $value");
        setState(() {
          isSwitched = value;
        });
      },
    );
  }
}
