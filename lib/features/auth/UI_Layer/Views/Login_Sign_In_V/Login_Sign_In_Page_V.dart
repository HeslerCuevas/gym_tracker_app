import 'package:flutter/material.dart';
import 'package:gym_tracker_app/features/auth/UI_Layer/Views_Models/Login_Sign_In_VM.dart';
import '../Forget_Password_V/Forget_Password_V.dart';
import '../Login_Sign_Up_V/Login_Sign_Up_V.dart';

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
      SignInText(),
      const SizedBox(height: 5),
      
      //Don't have an account? Sign Up Section
      SignUpText(),
      
      //Email and Password Text Fields Section
      const SizedBox(height: 25),
      Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
            child: TextFieldEmail()),
      const SizedBox(height: 25),
      Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
            child: TextFieldPassword()),
      
      const SizedBox(height: 25),

      //Forgot Your Password? Section
      const ForgetPasswordText(),

      const SizedBox(height: 25),

      //Log In Button Section
      const LogInButton()
        ],
      ),
    );
  }
}


//CLASSES DEFINITATION

class TextFieldEmail extends StatelessWidget {
  const TextFieldEmail({super.key});

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
          hintText: "Email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none
          )
        ),
      );
  }
}

class TextFieldPassword extends StatelessWidget {
  const TextFieldPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
            style: const TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.bold,
            fontFamily: "Roboto"
          ),
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color.fromARGB(255, 255, 255, 255),
          hintText: "Password",
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

class SignInText extends StatelessWidget {
  const SignInText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
        "Sign in to your\nAccount",
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
            navigateToNextScreen(context, const ForgetPasswordScreen());
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

class LogInButton extends StatelessWidget {
  const LogInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () { 
      },
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(const Color.fromARGB(255, 36, 90, 226)),
        padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 142.5, vertical: 10)),
        shape: WidgetStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)
        ))
      ),

            child: const Text("Log In",
        style: TextStyle(
          color: Colors.white,
          fontSize: 25,
          fontFamily: "Roboto"
        ),
      ),
    );
  }
}