import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'package:vnrdn_tai/widgets/switch.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}

class SwitchClass extends State {
  bool isSwitched = false;
  var textValue = 'Switch is OFF';

  void toggleSwitch(bool value) {
    if (isSwitched == false) {
      setState(() {
        isSwitched = true;
        textValue = 'Switch Button is ON';
      });
      print('Switch Button is ON');
    } else {
      setState(() {
        isSwitched = false;
        textValue = 'Switch Button is OFF';
      });
      print('Switch Button is OFF');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          elevation: 0,
          title: const Text('Cài đặt'),
        ),
        body: ListView.builder(
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                color: kPrimaryButtonColor,
                border: Border.all(color: kDisabledButtonColor),
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: kDisabledTextColor,
                  )
                ],
              ),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: Row(children: [
                  Text('Thông báo'),
                  const Spacer(),
                  CupertinoSwitch(
                    dragStartBehavior: DragStartBehavior.start,
                    value: isSwitched,
                    activeColor: Colors.blueAccent,
                    onChanged: (value) {
                      print("VALUE : $value");
                      setState(() {
                        isSwitched = value;
                      });
                    },
                  )
                ]),
              ),
            );
          },
        ));
  }
}
