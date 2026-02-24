import 'package:flutter/material.dart';
import 'package:gym_tracker_app/features/home/UI_Layer/Views/Home_V/Home_V.dart';

bool _isSnackBarShowing = false;

void navigateToNextScreen(BuildContext context, Widget destinationScreen) {
  Navigator.push(
    context,
    MaterialPageRoute<void>(builder: (context) => destinationScreen),
  );
}

void LogInButtonPressed(BuildContext context) {
  //API call to log in the user with the provided email and password

  //If everything goes well with the login process, navigate to the Home Screen
  navigateToNextScreen(context, const HomeScreen());

  //Else, show an error message to the user
  /*
  if (!_isSnackBarShowing) {
    _isSnackBarShowing = true;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Login failed. Please check your credentials and try again.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
            fontFamily: "Roboto",
          ),
        ),
        backgroundColor: Color.fromARGB(255, 239, 113, 104),
      ),
    ).closed.then((_) {
      _isSnackBarShowing = false;
    });
  }
  */
}

void RegisterButtonPressed() {

}

void navigateBack(BuildContext context) {
  Navigator.pop(context);
}