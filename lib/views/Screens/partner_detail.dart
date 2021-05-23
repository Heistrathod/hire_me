import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_me_app/services/database.dart';
import 'package:hire_me_app/shared/styles.dart';
import 'package:hire_me_app/views/Screens/hired_succesfully.dart';
import 'package:hire_me_app/views/Widgets/text_button_helper.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:url_launcher/url_launcher.dart';

class PartnerDetailPage extends StatefulWidget {
  final String tradesmanFullName,
      tradesmanEmail,
      tradesmanProfession,
      tradesmanAddress,
      tradesmanPhoneNo,
      tradesmanId,
      customerId,
      customerEmail;
  final String image;
  final String tag;
  const PartnerDetailPage(
      {Key key,
      this.image,
      this.tag,
      this.tradesmanId,
      this.customerId,
      this.customerEmail,
      this.tradesmanFullName,
      this.tradesmanAddress,
      this.tradesmanPhoneNo,
      this.tradesmanProfession,
      this.tradesmanEmail})
      : super(key: key);

  @override
  _PartnerDetailPageState createState() => _PartnerDetailPageState();
}

class _PartnerDetailPageState extends State<PartnerDetailPage> {
  String custId, custEmail;
  String _taskTitle, _taskDescription;
  String tradeEmail;
  String datefinal;

  // ignore: unused_field
  DateTime _selectedValue = DateTime.now();
  DatePickerController _dateController = DatePickerController();
  DateFormat _dateFormat = DateFormat("MMM dd, yyyy ");

  UserCollection taskManager = new UserCollection();
  GlobalKey<FormState> _formkey = new GlobalKey();

  @override
  void initState() {
    setState(() {
      custId = widget.customerId;
      custEmail = widget.customerEmail;
      tradeEmail = widget.tradesmanEmail;
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(custId);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: labelColor),
        elevation: 0.5,
        backgroundColor: backgroundColor,
        title: Text(
          "About",
          style: titlelabelStyle,
        ),
      ),
      backgroundColor: backgroundColor,
      body: Center(
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            Hero(
                tag: widget.tag,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 30),
                  decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
                    BoxShadow(
                        blurRadius: 50,
                        color: primarySwatchColor.withOpacity(0.30))
                  ]),
                  child: CircleAvatar(
                    backgroundColor: fillColor,
                    backgroundImage: NetworkImage(widget.image),
                    maxRadius: 150,
                  ),
                )),
            SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                widget.tradesmanFullName,
                style:
                    titlelabelStyle.copyWith(fontSize: 25, letterSpacing: 0.5),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                widget.tradesmanProfession,
                style: subtitlelabelStyle.copyWith(fontSize: 18),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    LineIcons.mapPin,
                    size: 20,
                    color: primarySwatchColor,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    widget.tradesmanAddress,
                    style: subtitlelabelStyle.copyWith(fontSize: 15),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () => launch("tel:" + widget.tradesmanPhoneNo),
                    icon: Icon(LineIcons.phone),
                    color: Colors.blueAccent,
                    iconSize: 40,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  IconButton(
                    onPressed: () => _messageOnWhatsapp(
                        phone: 919892985064,
                        message: "want to hire u for some job"),
                    icon: Icon(LineIcons.whatSApp),
                    color: Colors.green,
                    iconSize: 40,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 165,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: DatePicker(
                DateTime.now(),
                width: 60,
                height: 80,
                controller: _dateController,
                initialSelectedDate: DateTime.now(),
                daysCount: 45,
                selectionColor: primarySwatchColor,
                selectedTextColor: Colors.white,
                onDateChange: (date) {
                  setState(() {
                    _dateController.animateToSelection();
                    _selectedValue = date;
                    datefinal = _dateFormat.format(_selectedValue);
                  });
                  _dateController.animateToSelection();
                },
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              height: 70,
              width: double.infinity,
              child: TextButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(primarySwatchColor),
                  ),
                  child: Text(
                    "HIRE",
                    style: titlelabelStyle.copyWith(
                        color: Colors.white, fontSize: 20, letterSpacing: 1),
                  ),
                  onPressed: () {
                    _bottomSheet();
                  }),
            ),
          ],
        ),
      ),
    );
  }

  void _messageOnWhatsapp({
    @required int phone,
    @required String message,
  }) async {
    String url() {
      if (Platform.isAndroid) {
        return "https://wa.me/$phone/?text=${Uri.parse(message)}"; // new line
      } else {
        return "https://api.whatsapp.com/send?phone=$phone=${Uri.parse(message)}"; // new line
      }
    }

    if (await canLaunch(url())) {
      await launch(url());
    } else {
      throw 'Could not launch ${url()}';
    }
  }

  void displayBottomSheet(BuildContext context) {
    showBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        builder: (BuildContext context) {
          return Container(
              color: Colors.transparent, height: 200, child: Container());
        });
  }

  Future _bottomSheet() {
    return showModalBottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.all(8.0),
            height: 350,
            decoration: (BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(15))),
            child: ListView(
              children: [
                Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      TextFormField(
                        onSaved: (input) {
                          _taskTitle = input;
                        },
                        decoration: inputDecoration.copyWith(
                          hintText: "Add Title",
                          hintStyle: GoogleFonts.montserrat(color: Colors.grey),
                        ),
                        validator: (input) {
                          if (input == null) {
                            return "Please Provide a title";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        onSaved: (input) {
                          _taskDescription = input;
                        },
                        maxLines: 10,
                        decoration: inputDecoration.copyWith(
                            hintText: "Add Description",
                            hintStyle:
                                GoogleFonts.montserrat(color: Colors.grey)),
                        validator: (input) {
                          if (input == null) {
                            return "Please Provide a description of the job";
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButtonHelper(
                        text: "Confirm",
                        buttonColor: primarySwatchColor,
                        onPressed: () {
                          print(widget.tradesmanEmail);
                          hireTradesman();
                        }),
                    TextButtonHelper(
                      onPressed: () => Navigator.pop(context),
                      text: "Cancel",
                      buttonColor: labelColor,
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }

  Future<void> hireTradesman() async {
    final formstate = _formkey.currentState;
    if (formstate.validate()) {
      formstate.save();
      Map<String, dynamic> task = {
        'title': this._taskTitle,
        'description': this._taskDescription,
        'date': this.datefinal,
        'customerId': this.custId,
        'customerEmail': this.custEmail,
        'tradesmanName': this.widget.tradesmanFullName,
      };
      await taskManager.addTask(task, widget.tradesmanId);
      await taskManager.currentlyHired(custId, custEmail, tradeEmail, task);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => HiringSuccessfulPage()));
      print("task added");
    } else {
      print("Task not added");
    }
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
