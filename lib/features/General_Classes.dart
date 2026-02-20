import 'package:flutter/material.dart';

class GeneralText extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;
  final TextAlign textAlign;
  final FontWeight fontWeight;

  const GeneralText({
    super.key,
    required this.text,
    required this.color,
    required this.fontSize,
    required this.textAlign,
    required this.fontWeight
  });

  @override
  Widget build(BuildContext context) {
    return Text(
        text,
        textAlign: textAlign,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: fontWeight,
          fontFamily: "Roboto"
        )
      );
  }
}

class Button extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double fontSize;
  final double horizontalPadding;
  final double verticalPadding;
  final double borderRadius;

  const Button({
    super.key,
    required this.text,
    required this.onPressed,
    required this.fontSize,
    required this.horizontalPadding,
    required this.verticalPadding,
    required this.borderRadius
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(const Color.fromARGB(255, 36, 90, 226)),
        padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding)),
        shape: WidgetStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius)
        ))
      ),

            child: Text(text,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontFamily: "Roboto"
        ),
      ),
    );
  }
}

class IconButtonNew extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const IconButtonNew({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(const Color.fromARGB(255, 36, 90, 226)),
          padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
          shape: WidgetStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15)
        )),
      ),
    );
  }
}