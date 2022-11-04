import 'dart:io';
import 'dart:ui';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/controllers/search_controller.dart';
import 'package:vnrdn_tai/screens/auth/login_screen.dart';
import 'package:vnrdn_tai/screens/container_screen.dart';
import 'package:vnrdn_tai/shared/bindings.dart';
import 'package:vnrdn_tai/shared/constants.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = new MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return GetMaterialApp(
        title: 'VNRDnTAI',
        // enableLog: false,
        themeMode: ThemeMode.light,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'SVN_Aleo',
          backgroundColor: Color.fromARGB(255, 143, 143, 143),
          primaryColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            titleTextStyle: TextStyle(
              color: Colors.blueAccent,
              fontSize: FONTSIZES.textLarge,
              fontWeight: FontWeight.bold,
            ),
            actionsIconTheme: IconThemeData(
              color: Colors.black54,
              size: FONTSIZES.textHuge,
            ),
            iconTheme: IconThemeData(
              color: Colors.black54,
              size: FONTSIZES.textHuge,
            ),
          ),
        ),
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
        home: const ContainerScreen(),
        initialBinding: GlobalBinding(),
      );
    });
  }
}
