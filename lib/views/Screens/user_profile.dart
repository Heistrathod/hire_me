import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hire_me_app/authentication/sign_in.dart';
import 'package:hire_me_app/services/database.dart';
import 'package:hire_me_app/shared/styles.dart';
import 'package:hire_me_app/views/Screens/task_detail_page.dart';

class CustomerProfile extends StatefulWidget {
  final String custEmail, custId;
  const CustomerProfile({Key key, this.custEmail, this.custId})
      : super(key: key);

  @override
  _CustomerProfileState createState() => _CustomerProfileState();
}

class _CustomerProfileState extends State<CustomerProfile> {
  UserCollection taskManager = new UserCollection();
  Stream currentlyHired;
  Stream previouslyHired;

  @override
  void initState() {
    taskManager
        .getCurrentlyTasks(widget.custEmail, widget.custId)
        .then((result) {
      setState(() {
        currentlyHired = result;
      });
    });
    taskManager.getprevTasks(widget.custEmail, widget.custId).then((result) {
      setState(() {
        previouslyHired = result;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            actions: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: GestureDetector(
                    onTap: () => _signOut(),
                    child: Text(
                      "SignOut",
                      style: subtitlelabelStyle,
                    ),
                  ),
                ),
              )
            ],
            iconTheme: IconThemeData(
              color: labelColor,
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: Text(
              "User",
              style: titlelabelStyle,
            ),
          ),
          backgroundColor: backgroundColor,
          body: ListView(
            children: [
              Container(
                height: 150,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        maxRadius: 60,
                        backgroundColor: backgroundColor,
                        backgroundImage: NetworkImage(
                            "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500"),
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                              text: widget.custEmail + "\n",
                              style: titlelabelStyle.copyWith(fontSize: 15)),
                          TextSpan(
                              text: "UID:" + widget.custId,
                              style: subtitlelabelStyle.copyWith(fontSize: 10)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Currently Hired",
                  style: titlelabelStyle.copyWith(fontSize: 20),
                ),
              ),
              _streamBuilder(currentlyHired, "No one Hired Currently"),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Previously Hired",
                  style: titlelabelStyle.copyWith(fontSize: 20),
                ),
              ),
              _streamBuilder(previouslyHired, "No Previous Hirings")
            ],
          ),
        ),
      ),
    );
  }

  Widget _streamBuilder(Stream snapshhot, String message) {
    String nullMsg = message;
    return StreamBuilder(
      stream: snapshhot,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.data == null) {
          return Container(
            height: 50,
            child: Center(
              child: Text(
                nullMsg,
                style: subtitlelabelStyle,
              ),
            ),
          );
        } else {
          return Container(
              height: 90 * snapshot.data.documents.length.toDouble(),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: fillColor),
                        child: ListTile(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TaskDetails())),
                          contentPadding: const EdgeInsets.all(0),
                          leading: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.handyman_outlined,
                              color: primarySwatchColor,
                            ),
                          ),
                          title: Text(
                            snapshot
                                .data.documents[index].data['tradesmanName'],
                            style: titlelabelStyle,
                          ),
                          subtitle: Text(
                            snapshot.data.documents[index].data['date']
                                .toString(),
                            style: subtitlelabelStyle,
                          ),
                        ),
                      ),
                    );
                  }));
        }
      },
    );
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SignInPage()));
  }
}
