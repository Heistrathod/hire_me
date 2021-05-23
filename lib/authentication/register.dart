import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_me_app/authentication/partner_form.dart';
import 'package:hire_me_app/authentication/sign_in.dart';
import 'package:hire_me_app/services/database.dart';
import 'package:hire_me_app/views/Widgets/flat_button_helper.dart';
import 'package:hire_me_app/views/Widgets/form_dropdown.dart';
import 'package:line_icons/line_icons.dart';
import 'package:hire_me_app/shared/styles.dart';
import 'package:hire_me_app/views/Widgets/text_field_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String _username;
  String _customerUid;
  String _email;
  String _password;
  String _role;
  final GlobalKey<FormState> _signUpkey = new GlobalKey();
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
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
                      'Sign Up',
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
                    key: _signUpkey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormFieldHelper(
                            onSaved: (input) {
                              _username = input;
                            },
                            hintText: "User name",
                            prefixIconData: LineIcons.user,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormFieldHelper(
                            onSaved: (input) {
                              _email = input;
                            },
                            hintText: "Email",
                            prefixIconData: LineIcons.envelopeAlt,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormFieldHelper(
                            onSaved: (input) {
                              _password = input;
                            },
                            hintText: "Password",
                            obscureText: true,
                            prefixIconData: LineIcons.lock,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: FormDropdown(
                            itemList: ["User", "Partner"],
                            hintText: "Sign up As",
                            prefixIcon: LineIcons.briefcase,
                            onChanged: (input) {
                              setState(() {
                                _role = input;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: FlatButtonHelper(
                          text: "Sign Up",
                          onPressed: () {
                            signUp();
                          })),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignInPage())),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: 'Already have an account ?\n',
                        style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                                color: fillColor,
                                fontWeight: FontWeight.normal,
                                fontSize: 14)),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Sign In',
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
        ],
      ),
    );
  }

//........................CUSTOMER SIGN UP................................

  Future<void> signUp() async {
    final formState = _signUpkey.currentState;
    if (formState.validate()) {
      formState.save();
      try {
        if (_role == 'User') {
          await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                  email: _email, password: _password)
              .then((result) {
            FirebaseUser user = result.user;
            _customerUid = user.uid;
            Map<String, dynamic> userData = {
              'uid': this._customerUid,
              'email': this._email,
              'userName': this._username,
              'role': this._role
            };
            UserCollection().userProfiles(userData, _email, _customerUid);
          });
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => SignInPage()));
        } else {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      PartnerFormPage(_email, _password, _role)));
        }
      } catch (e) {
        print(e);
      }
    }
  }
}
