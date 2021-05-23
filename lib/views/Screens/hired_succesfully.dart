import 'package:flutter/material.dart';
import 'package:hire_me_app/shared/styles.dart';
import 'package:hire_me_app/views/Screens/home_page.dart';
import 'package:unicons/unicons.dart';

class HiringSuccessfulPage extends StatelessWidget {
  const HiringSuccessfulPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(mainAxisAlignment: MainAxisAlignment.end, children: [
            Padding(
              padding: const EdgeInsets.only(top: 250.0),
              child: Center(
                  child: Icon(
                UniconsSolid.check_circle,
                size: 100,
                color: primarySwatchColor,
              )),
            ),
            Text("Hired Succefully!!", style: titlelabelStyle),
          ]),
          Column(
            children: [
              GestureDetector(
                onTap: () => Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => HomePage())),
                child: Container(
                  color: primarySwatchColor,
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                      child: Text(
                    "Go Back",
                    style: titlelabelStyle.copyWith(
                        color: Colors.white, fontSize: 20, letterSpacing: 1),
                  )),
                ),
              )
            ],
          ),
        ],
      ),
    ));
  }
}
