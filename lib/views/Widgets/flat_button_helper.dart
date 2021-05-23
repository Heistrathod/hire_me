import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_me_app/shared/styles.dart';

class FlatButtonHelper extends StatelessWidget {
  final double height;
  final String text;
  final Function onPressed;

  const FlatButtonHelper(
      {Key key,
      this.height = 55,
      @required this.text,
      @required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      child: TextButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(primarySwatchColor),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
                side: BorderSide(color: primarySwatchColor)))),
        onPressed: onPressed,
        child: Text(text,
            style: GoogleFonts.montserrat(
                textStyle: TextStyle(
                    color: backgroundColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 20))),
      ),
    );
  }
}
