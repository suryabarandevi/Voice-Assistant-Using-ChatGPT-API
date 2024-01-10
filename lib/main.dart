import 'package:allen/home_page.dart';
import 'package:allen/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void configLoading() {
  EasyLoading.instance
    ..loadingStyle = EasyLoadingStyle.custom //This was missing in earlier code
    ..indicatorType = EasyLoadingIndicatorType.rotatingPlain
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.red
    ..indicatorColor = Colors.white
    ..textColor = Colors.white
    ..maskColor = Colors.blue.withOpacity(0.7)
    ..userInteractions = true
    ..dismissOnTap = false;
}

void main() {
  runApp(const MyApp());
  configLoading();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Team-14',
      theme: ThemeData.light(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: Pallete.whiteColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: Pallete.whiteColor,
        ),
      ),
      home: const HomePage(),
      builder: EasyLoading.init(),
    );
  }
}
