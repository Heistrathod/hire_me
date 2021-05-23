import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_me_app/shared/styles.dart';

class TextFormFieldHelper extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Function validator;
  final TextInputType textInputType;
  final IconData prefixIconData;
  final IconData suffixIconData;
  final Function suffixonPressed;
  final Function onSaved;
  final bool obscureText;
  final Function onChanged;
  const TextFormFieldHelper(
      {Key key,
      this.controller,
      this.hintText,
      this.validator,
      this.textInputType,
      this.prefixIconData,
      this.suffixIconData,
      this.suffixonPressed,
      this.obscureText,
      this.onSaved,
      this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: controller,
        validator: validator,
        onSaved: onSaved,
        style: TextStyle(fontSize: 18),
        obscureText: obscureText ?? false,
        onChanged: onChanged,
        decoration: inputDecoration.copyWith(
          hintText: hintText,
          hintStyle: GoogleFonts.montserrat(color: Colors.grey),
          prefixIcon: Icon(prefixIconData, color: primarySwatchColor),
          suffixIcon: IconButton(
            icon: Icon(suffixIconData, color: Colors.grey),
            onPressed: suffixonPressed,
          ),
        ));
  }
}

InputDecoration inputDecoration = InputDecoration(
  contentPadding: new EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
  fillColor: fillColor,
  filled: true,
  focusedBorder: OutlineInputBorder(
    borderSide: const BorderSide(color: backgroundColor, width: 1.0),
    borderRadius: BorderRadius.circular(15.0),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: backgroundColor, width: 0.0),
    borderRadius: BorderRadius.circular(15.0),
  ),
  errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(15)),
      borderSide: BorderSide(width: 1.0, color: Colors.red)),
);
