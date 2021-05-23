import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_me_app/shared/styles.dart';

class TextButtonHelper extends StatelessWidget {
  final String text;
  final Function onPressed;
  final Color buttonColor;

  const TextButtonHelper({Key key, this.text, this.onPressed, this.buttonColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Container(
      decoration: BoxDecoration(
          color: buttonColor, borderRadius: BorderRadius.circular(20)),
      height: 45,
      width: 160,
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: GoogleFonts.montserrat(
            textStyle: TextStyle(
                color: fillColor,
                letterSpacing: .5,
                fontWeight: FontWeight.w500,
                fontSize: 18),
          ),
        ),
      ),
    ));
  }
}
