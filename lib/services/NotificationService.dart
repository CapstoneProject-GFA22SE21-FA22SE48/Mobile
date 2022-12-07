import 'dart:ui';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:rxdart/subjects.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/utils/download_util.dart';

class NotificationService {
  GlobalController gc = Get.find<GlobalController>();
  NotificationService();

  final _localNotifications = FlutterLocalNotificationsPlugin();
  final BehaviorSubject<String> behaviorSubject = BehaviorSubject();

  Future<void> initializePlatformNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('mipmap/ic_launcher');

    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            requestSoundPermission: true,
            requestBadgePermission: true,
            requestAlertPermission: true,
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _localNotifications.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {
    print('id $id');
  }

  void selectNotification(String? payload) {
    if (payload != null && payload.isNotEmpty) {
      behaviorSubject.add(payload);
    }
  }

  Future<NotificationDetails> _notificationDetails(String imageUrl) async {
    final bigPicture = await DownloadUtil.downloadAndSaveFile(imageUrl, "sign");

    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('vnrdntai', 'vnrdntai_sign_gps',
            groupKey: 'com.example.flutter_push_notifications',
            channelDescription: 'vnrdntai sign gps notification',
            importance: Importance.max,
            priority: Priority.max,
            playSound: true,
            ticker: 'ticker',
            largeIcon: FilePathAndroidBitmap(bigPicture),
            styleInformation: BigPictureStyleInformation(
              FilePathAndroidBitmap(bigPicture),
              hideExpandedLargeIcon: false,
            ),
            color: const Color(0xff2196f3),
            timeoutAfter: 3000,
            autoCancel: false,
            indeterminate: true,
            fullScreenIntent: true,
            groupAlertBehavior: GroupAlertBehavior.all,
            icon: "mipmap/ic_launcher");

    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails(
        threadIdentifier: "thread_vnrdntai",
        attachments: <IOSNotificationAttachment>[
          IOSNotificationAttachment(bigPicture)
        ]);

    final details = await _localNotifications.getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {
      behaviorSubject.add(details.payload!);
    }
    NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iosNotificationDetails);

    return platformChannelSpecifics;
  }

  Future<bool> showLocalNotification({
    required int id,
    required String title,
    required String image,
    required String body,
    required String payload,
  }) async {
    if (gc.pushNotiMode.value == false) return false;
    final platformChannelSpecifics = await _notificationDetails(image);
    await _localNotifications.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
    return true;
  }
}
