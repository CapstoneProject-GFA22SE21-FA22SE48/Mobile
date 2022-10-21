import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'package:vnrdn_tai/widgets/switch.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SwitchClassState();
}

class _SwitchClassState extends State<SettingsScreen> {
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
          padding: const EdgeInsets.all(10.0),
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 10,
                  )
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(10.0),
                title: Row(children: [
                  Text(
                    'Thông báo',
                    style: TextStyle(
                      color:
                          isSwitched ? kPrimaryButtonColor : kPrimaryTextColor,
                      fontSize: FONTSIZES.textMediumLarge,
                    ),
                  ),
                  const Spacer(),
                  CupertinoSwitch(
                    dragStartBehavior: DragStartBehavior.start,
                    value: isSwitched,
                    activeColor: Colors.blueAccent,
                    trackColor: Colors.grey,
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
