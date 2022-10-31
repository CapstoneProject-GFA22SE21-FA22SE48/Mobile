import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/screens/container_screen.dart';
import 'package:vnrdn_tai/screens/settings/change_password_screen.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'package:vnrdn_tai/widgets/switch.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SwitchClassState();
}

class _SwitchClassState extends State<SettingsScreen> {
  GlobalController gc = Get.put(GlobalController());
  bool isNotiOn = false;

  @override
  Widget build(BuildContext context) {
    isNotiOn = gc.pushNotiMode.value;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        title: const Text('Cài đặt'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.to(ContainerScreen()),
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(197, 189, 189, 189),
                  offset: Offset(0, 2),
                  blurRadius: 2,
                )
              ],
            ),
            child: ListTile(
              leading: Icon(isNotiOn
                  ? Icons.notifications_active_rounded
                  : Icons.notifications_off_rounded),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              title: Row(children: [
                Text(
                  'Thông báo',
                  style: TextStyle(
                    color: isNotiOn ? kPrimaryButtonColor : kPrimaryTextColor,
                    fontSize: FONTSIZES.textMediumLarge,
                  ),
                ),
                const Spacer(),
                CupertinoSwitch(
                  dragStartBehavior: DragStartBehavior.start,
                  value: isNotiOn,
                  activeColor: Colors.blueAccent,
                  trackColor: Colors.grey,
                  onChanged: (value) {
                    setState(() {
                      isNotiOn = value;
                      gc.updatePushNotiMode(value);
                    });
                  },
                ),
              ]),
            ),
          ),
          // helps
          Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(197, 189, 189, 189),
                  offset: Offset(0, 2),
                  blurRadius: 2,
                )
              ],
            ),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              leading: const Icon(Icons.help_outline),
              title: GestureDetector(
                onTap: () {},
                child: Row(
                  children: const [
                    Text(
                      'Trợ giúp',
                      style: TextStyle(
                        color: kPrimaryTextColor,
                        fontSize: FONTSIZES.textMediumLarge,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // change password
          gc.userId.value.isNotEmpty
              ? Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromARGB(197, 189, 189, 189),
                        offset: Offset(0, 2),
                        blurRadius: 2,
                      )
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                    tileColor: Colors.white,
                    leading: const Icon(Icons.password_rounded),
                    title: GestureDetector(
                      onTap: () {
                        Get.to(ChangePasswordScreen());
                      },
                      child: Row(
                        children: const [
                          Text(
                            'Đổi mật khẩu',
                            style: TextStyle(
                              backgroundColor: Colors.white,
                              color: kPrimaryTextColor,
                              fontSize: FONTSIZES.textMediumLarge,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
