import 'package:flutter/material.dart';

class ExerciseMainScreen extends StatelessWidget {
  const ExerciseMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Exercise Main Screen',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}