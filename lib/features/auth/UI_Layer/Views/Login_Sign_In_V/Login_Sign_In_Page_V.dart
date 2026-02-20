import 'package:flutter/material.dart';
import 'package:gym_tracker_app/features/auth/ui_layer/Views/Auth_Classes_Definition.dart';
import 'package:gym_tracker_app/features/auth/ui_layer/Views_Models/Login_Sign_In_VM.dart';

class MainLoginScreen extends StatelessWidget {
  const MainLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 10, 19, 21),
      body: Column(
        children: [
          
      //Logo Section
      DisplayMainLogo(),
      const SizedBox(height: 20),

      //Sign in to your Account Section
      MainText(text: "Sign in to your\nAccount"),
      const SizedBox(height: 5),
      
      //Don't have an account? Sign Up Section
      SignUpText(),
      
      //Email and Password Text Fields Section
      SpacedInputField(label: "Email"),
      SpacedInputField(label: "Password"),
      
      const SizedBox(height: 25),

      //Forgot Your Password? Section
      const ForgetPasswordText(),

      const SizedBox(height: 25),

      //Log In Button Section
      LogInRegisterButton(text: "Log In", onPressed: () => LogInButtonPressed(context))
        ],
      ),
    );
  }
}