import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_me_app/authentication/register.dart';
import 'package:hire_me_app/services/database.dart';
import 'package:hire_me_app/views/Screens/home_page.dart';
import 'package:hire_me_app/views/Screens/partner_profile_page.dart';
import 'package:hire_me_app/views/Widgets/flat_button_helper.dart';
import 'package:line_icons/line_icons.dart';
import 'package:hire_me_app/shared/styles.dart';
import 'package:hire_me_app/views/Widgets/text_field_helper.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  String _email;
  String _password;
  String _userId;
  QuerySnapshot role;
  UserCollection userRole = new UserCollection();

  final GlobalKey<FormState> _formKey = new GlobalKey();
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: Stack(children: [
          Positioned(
              child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomRight,
                    colors: [primarySwatchColor, Color(0xffA494F0)])),
          )),
          SafeArea(
            child: Center(
              child: ListView(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Sign In',
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                            color: fillColor,
                            letterSpacing: .5,
                            fontWeight: FontWeight.w500,
                            fontSize: 35),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 70,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormFieldHelper(
                            onSaved: (input) {
                              _email = input;
                            },
                            hintText: "Email",
                            prefixIconData: LineIcons.envelopeAlt,
                            validator: (input) {
                              if (input == null) {
                                return 'Please enter a email';
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormFieldHelper(
                            obscureText: true,
                            onSaved: (input) {
                              _password = input;
                            },
                            hintText: "Password",
                            prefixIconData: LineIcons.lock,
                            validator: (input) {
                              if (input.length < 6) {
                                return 'Please provide a password';
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: FlatButtonHelper(
                          text: "Sign In",
                          onPressed: () {
                            signIn();
                          })),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterPage())),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: 'Don\'t have an account ?\n',
                        style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                                color: fillColor,
                                fontWeight: FontWeight.normal,
                                fontSize: 14)),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Sign Up',
                              style: TextStyle(
                                color: fillColor,
                                fontWeight: FontWeight.bold,
                              )),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ]));
  }

//............................SIGN IN..............................
  Future<void> signIn() async {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      try {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password)
            .then((result) {
          _userId = result.user.uid;
          print(_userId);
          userRole.getUserRole(_email).then((result) {
            setState(() {
              role = result;
            });
            String currentUserRole = role.documents[0].data['role'];
            print(currentUserRole);
            if (currentUserRole == "User") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomePage(
                            customerId: _userId,
                            customerEmail: _email,
                          )));
            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfilePage(
                            tradesmanEmail: _email,
                            tradesmanUserName:
                                role.documents[0].data['fullName'],
                            tradesmanProfession:
                                role.documents[0].data['profession'],
                            tradesmanId: role.documents[0].data['uid'],
                          )));
            }
          });
        });
      } catch (e) {
        print(e.message);
      }
    }
    return null;
  }
}
