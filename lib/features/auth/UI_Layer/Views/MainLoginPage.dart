import 'package:flutter/material.dart';

class MainLoginPage extends StatelessWidget {
  const MainLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Main Login Page'),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 45.0),
          child: Image.asset('assets/app_main_logo_blue.png', width: 80, height: 80)
        ),
      ),
    );
  }
}