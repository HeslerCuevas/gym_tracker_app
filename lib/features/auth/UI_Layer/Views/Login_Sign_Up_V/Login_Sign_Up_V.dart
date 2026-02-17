import 'package:flutter/material.dart';
import 'package:gym_tracker_app/features/auth/UI_Layer/Views/Auth_Classes_Definition.dart';
import 'package:gym_tracker_app/features/auth/UI_Layer/Views_Models/Login_Sign_In_VM.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 10, 19, 21),
      body: Column(
        children: [
          
      //Logo Section
      const DisplayMainLogo(),
      const SizedBox(height: 20),

      //Create your Account Section
      const MainText(text: "Create Account"),
      const SizedBox(height: 5),
      
      //Don't have an account? Sign Up Section
      const SignInText(),
      
      //First Name, Last Name and Email Password Text Fields Section
      SpacedInputField(label: "First Name"),
      SpacedInputField(label: "Last Name"),
      SpacedInputField(label: "Email"),
      SpacedInputField(label: "Password"),
      
      const SizedBox(height: 25),

      //Forgot Your Password? Section
      const ForgetPasswordText(),

      const SizedBox(height: 25),

      //Log In Button Section
      LogInRegisterButton(text: "Register", onPressed: RegisterButtonPressed)
        ],
      ),
    );
  }
}