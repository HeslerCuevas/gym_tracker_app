import 'package:flutter/material.dart';

void navigateToNextScreen(BuildContext context, Widget destinationScreen) {
  Navigator.push(
    context,
    MaterialPageRoute<void>(builder: (context) => destinationScreen),
  );
}

void navigateBack(BuildContext context) {
  Navigator.pop(context);
}