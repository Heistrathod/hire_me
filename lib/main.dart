import 'package:flutter/material.dart';
import 'package:hire_me_app/authentication/sign_in.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var Colors;
    return MaterialApp(
      title: 'GET ME',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SignInPage(),
      debugShowCheckedModeBanner: false,
    );
  }

  ThemeData({primarySwatch, visualDensity}) {}

  MaterialApp({String title, theme, SignInPage home, bool debugShowCheckedModeBanner}) {}
}

mixin VisualDensity {
  static var adaptivePlatformDensity;
}
