import 'dart:io';
import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/screens/container_screen.dart';
import 'package:vnrdn_tai/shared/bindings.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'package:vnrdn_tai/utils/firebase_options.dart';
import 'package:vnrdn_tai/utils/io_utils.dart';

import 'shared/themes.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  getAllData(BuildContext context) async {
    GlobalController gc = Get.put(GlobalController());
    if (gc.userId.isEmpty) {
      var token = await IOUtils.getFromStorage('token');
      if (token.isNotEmpty) {
        IOUtils.setUserInfoController(token);
      } else {
        IOUtils.clearUserInfoController();
      }
    }
  }

  getPermission() async {
    GlobalController gc = Get.put(GlobalController());
    await Permission.notification.request().then((value) {
      if (value.isGranted) {
        gc.updatePushNotiMode(true);
      } else {
        gc.updatePushNotiMode(false);
      }
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    getAllData(context);
    return Sizer(builder: (context, orientation, deviceType) {
      return GetMaterialApp(
        title: 'VNRDnTAI',
        // enableLog: false,
        themeMode: ThemeMode.light,
        debugShowCheckedModeBanner: false,
        theme: defaultTheme,
        darkTheme: ThemeData(
          fontFamily: 'SVN_Aleo',
          backgroundColor: Color(0xFF131313),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF000000),
            titleTextStyle: TextStyle(
              color: Colors.blueAccent,
              fontSize: FONTSIZES.textLarger,
              fontWeight: FontWeight.bold,
              fontFamily: 'SVN_Aleo',
            ),
            toolbarTextStyle: TextStyle(
              color: Colors.white70,
            ),
            actionsIconTheme: IconThemeData(
              color: Color(0xFFFFFFFF),
              size: FONTSIZES.textHuge,
            ),
            iconTheme: IconThemeData(
              color: Color(0xFFFFFFFF),
              size: FONTSIZES.textHuge,
            ),
          ),
        ),
        // home: const LoginScreen(),
        home: const LoaderOverlay(child: ContainerScreen()),
        initialBinding: GlobalBinding(),
      );
    });
  }
}
