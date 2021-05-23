import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_me_app/services/database.dart';
import 'package:hire_me_app/shared/styles.dart';
import 'package:hire_me_app/views/Screens/partner_profile_page.dart';
import 'package:hire_me_app/views/Widgets/flat_button_helper.dart';
import 'package:hire_me_app/views/Widgets/form_dropdown.dart';
import 'package:hire_me_app/views/Widgets/text_field_helper.dart';
import 'package:line_icons/line_icons.dart';

class PartnerFormPage extends StatefulWidget {
  final String _email;
  final String _password;
  final String _role;
  const PartnerFormPage(this._email, this._password, this._role);

  @override
  _PartnerFormPageState createState() => _PartnerFormPageState();
}

class _PartnerFormPageState extends State<PartnerFormPage> {
  String _fullName,
      _phoneNumber,
      _shopName,
      _address,
      _pincode,
      _profession,
      _uid,
      milgayaid;

  final GlobalKey<FormState> _partnerSignupKey = new GlobalKey();
  UserCollection usercollections = new UserCollection();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Center(
          child: ListView(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Container(
                  alignment: Alignment.center,
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: 'Please fill up your\n ',
                      style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                              color: primarySwatchColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14)),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Detail',
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                  color: primarySwatchColor,
                                  letterSpacing: .5,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 35),
                            ))
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Form(
                key: _partnerSignupKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormFieldHelper(
                        onSaved: (input) {
                          _fullName = input;
                        },
                        hintText: "Full name",
                        prefixIconData: LineIcons.user,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormFieldHelper(
                        onSaved: (input) {
                          _phoneNumber = input;
                        },
                        hintText: "Phone Number",
                        prefixIconData: LineIcons.phone,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormFieldHelper(
                        onSaved: (input) {
                          _shopName = input;
                        },
                        hintText: "Shop name",
                        prefixIconData: LineIcons.phone,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormFieldHelper(
                        onSaved: (input) {
                          _address = input;
                        },
                        hintText: "Address",
                        prefixIconData: LineIcons.phone,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormFieldHelper(
                        onSaved: (input) {
                          _pincode = input;
                        },
                        hintText: "Pincode",
                        prefixIconData: LineIcons.phone,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: FormDropdown(
                        itemList: [
                          "Electrician",
                          "Plumber",
                          "Painter",
                          "Carpenter",
                          "Mechanic",
                          "Trainer",
                          "Photographer"
                        ],
                        hintText: "Profession",
                        prefixIcon: LineIcons.briefcase,
                        onChanged: (value) {
                          setState(() {
                            _profession = value;
                          });
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
                    onPressed: () {
                      partnerSignUp();
                    },
                    text: "Submit",
                  )),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

//......................PARTNER SIGNUP & TRADESMAN LIST CREATOR & TRADESMAN PROFILE CREATOR.......................

  Future<void> partnerSignUp() async {
    final formkey = _partnerSignupKey.currentState;
    if (formkey.validate()) {
      formkey.save();
      try {
        //..........................CREATING TRADESMAN ACCOUNT.................
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: widget._email, password: widget._password)
            .then((result) {
          FirebaseUser user = result.user;
          _uid = user.uid;
          Map<String, dynamic> tradesmanData = {
            'email': this.widget._email,
            'fullName': this._fullName,
            'uid': this._uid,
            'phoneNumber': this._phoneNumber,
            'shopName': this._shopName,
            'profession': this._profession,
            'address': this._address,
            'pincode': this._pincode,
            'role': this.widget._role,
          };
          usercollections.addTradesman(tradesmanData,
              _uid); //............................CREATING TRADESMAN LIST......................

          usercollections.tradesmanProfiles(
              tradesmanData,
              widget
                  ._email); //.....................CREATING TRADESMAN USER PROFILES................

          print(_uid);
        });
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProfilePage(
                      tradesmanEmail: widget._email,
                      tradesmanId: _uid,
                      tradesmanProfession: _profession,
                      tradesmanUserName: _fullName,
                    )));
      } catch (e) {
        print(e);
      }
    }
  }
}
