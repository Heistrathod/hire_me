import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_me_app/shared/styles.dart';
import 'package:hire_me_app/views/Widgets/text_field_helper.dart';

class FormDropdown extends StatelessWidget {
  final GlobalKey fdropdownkey;
  final String hintText;
  final Function onChanged;
  final IconData prefixIcon;
  final List<String> itemList;

  const FormDropdown(
      {Key key,
      this.fdropdownkey,
      this.itemList,
      this.onChanged,
      this.hintText,
      this.prefixIcon})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: DropdownButtonFormField(
          items: itemList.map<DropdownMenuItem<String>>((String value) {
            return new DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: GoogleFonts.montserrat(color: Colors.grey),
              ),
            );
          }).toList(),
          hint: Text(
            hintText,
            style: GoogleFonts.montserrat(color: Colors.grey, fontSize: 18),
          ),
          onChanged: onChanged,
          validator: (value) =>
              value == null ? 'This field is required !' : null,
          isDense: true,
          dropdownColor: Colors.white,
          decoration: inputDecoration.copyWith(
            prefixIcon: Icon(
              prefixIcon,
              color: primarySwatchColor,
            ),
          )),
    );
  }
}
