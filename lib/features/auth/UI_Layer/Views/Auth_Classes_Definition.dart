import 'package:flutter/material.dart';
import 'package:gym_tracker_app/features/auth/ui_layer/Views/Login_Sign_In_V/Login_Sign_In_Page_V.dart';
import 'package:gym_tracker_app/features/auth/ui_layer/Views_Models/Login_Sign_In_VM.dart';
import 'Forget_Password_V/Forget_Password_Enter_Email_V.dart';
import 'Login_Sign_Up_V/Login_Sign_Up_V.dart';


//CLASSES DEFINITION

class TextInputField extends StatelessWidget {
  final String text;

  const TextInputField({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
            style: TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.bold,
            fontFamily: "Roboto"
          ),  
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color.fromARGB(255, 255, 255, 255),
          hintText: text,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none
          )
        ),
      );
  }
}

class SignUpText extends StatelessWidget {
  const SignUpText({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        const Text(
        "Don't have an account?",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.bold,
          fontFamily: "Roboto"
        ),
      ),
      TextButton(onPressed: () { navigateToNextScreen(context, SignUpScreen(),);
      },
       child: const Text(
        "Sign Up",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color(0xFF66BCF2),
          fontSize: 15,
          fontWeight: FontWeight.bold,
          fontFamily: "Roboto"
                  ),
                ),
              ),
            ],
          );
  }
}

class SignInText extends StatelessWidget {
  const SignInText({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        const Text(
        "Already have an account?",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.bold,
          fontFamily: "Roboto"
        ),
      ),
      TextButton(onPressed: () { navigateToNextScreen(context, MainLoginScreen(),);
      },
       child: const Text(
        "Login",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color(0xFF66BCF2),
          fontSize: 15,
          fontWeight: FontWeight.bold,
          fontFamily: "Roboto"
                  ),
                ),
              ),
            ],
          );
  }
}

class DisplayMainLogo extends StatelessWidget {
  const DisplayMainLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 140.0),
          child: Image.asset('assets/app_main_logo_blue.png', width: 70, height: 70)
        ),
      );
  }
}

class MainText extends StatelessWidget {
  final String text;

  const MainText({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 40,
          fontWeight: FontWeight.bold,
          fontFamily: "Roboto"
        )
      );
  }
}

class ForgetPasswordText extends StatelessWidget {
  const ForgetPasswordText({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.center,
        child: TextButton(
          onPressed: () {
            navigateToNextScreen(context, const ForgetPasswordEnterEmailV());
          },
          child: const Text(
            "Forgot Your Password?",
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
              fontFamily: "Roboto",
              decoration: TextDecoration.underline,
              decorationColor: Colors.white,
              decorationThickness: 1
            ),
          ),
        ),
      );
  }
}

class LogInRegisterButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const LogInRegisterButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(const Color.fromARGB(255, 36, 90, 226)),
        padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 142.5, vertical: 10)),
        shape: WidgetStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)
        ))
      ),

            child: Text(text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 25,
          fontFamily: "Roboto"
        ),
      ),
    );
  }
}

class SpacedInputField extends StatelessWidget {
  final String label;

  const SpacedInputField({required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: TextInputField(text: label),
        ),
      ],
    );
  }
}