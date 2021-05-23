import 'package:flutter/material.dart';
import 'package:hire_me_app/shared/styles.dart';

class CustomOutlineButton extends StatefulWidget {
  final String text;
  final Function onpressed;
  const CustomOutlineButton({Key key, this.text, this.onpressed})
      : super(key: key);

  @override
  _CustomOutlineButtonState createState() => _CustomOutlineButtonState();
}

class _CustomOutlineButtonState extends State<CustomOutlineButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 250.0, right: 15),
      child: Container(
        height: 40,
        width: 40,
        child: OutlineButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          onPressed: widget.onpressed,
          child: Text(
            widget.text,
            style: TextStyle(color: primarySwatchColor),
          ),
        ),
      ),
    );
  }
}
