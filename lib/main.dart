import 'package:flutter/material.dart';
import 'package:gym_tracker_app/features/auth/UI_Layer/Views/Login_Sign_In_V/Login_Sign_In_Page_V.dart';
import 'package:flutter/rendering.dart';

void main() {
  debugPaintSizeEnabled = false;
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  //Root of the app
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gym Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 219, 194, 66)),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color.fromARGB(255, 65, 79, 95),
        ),
      ),
      home: MainLoginScreen(),
    );
  }
}