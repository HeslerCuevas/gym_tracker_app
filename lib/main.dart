import 'package:flutter/material.dart';
import 'package:gym_tracker_app/features/auth/UI_Layer/Views/MainLoginPage.dart';

void main() {
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
      ),
      home: MainLoginPage(),
    );
  }
}