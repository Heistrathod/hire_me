import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hire_me_app/authentication/sign_in.dart';
import 'package:hire_me_app/services/database.dart';
import 'package:hire_me_app/shared/styles.dart';
import 'package:hire_me_app/views/Screens/pending_task_page.dart';
import 'package:hire_me_app/views/Screens/task_detail_page.dart';
import 'package:hire_me_app/views/Widgets/outline_button.dart';
import 'package:line_icons/line_icons.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  final String tradesmanEmail,
      tradesmanUserName,
      tradesmanProfession,
      tradesmanId;
  const ProfilePage(
      {Key key,
      this.tradesmanId,
      this.tradesmanEmail,
      this.tradesmanUserName,
      this.tradesmanProfession})
      : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserCollection tradesManProfiles = new UserCollection();
  Stream pendingTask;

  @override
  void initState() {
    tradesManProfiles.getPendingTasks(widget.tradesmanId).then((result) {
      setState(() {
        pendingTask = result;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            actions: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: GestureDetector(
                    onTap: () => _signOut(),
                    child: Text(
                      "Sign Out",
                      style: subtitlelabelStyle.copyWith(
                          fontSize: 20, color: primarySwatchColor),
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
          ),
          body: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  _userProfileCard(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Pending Tasks",
                      style: titlelabelStyle.copyWith(fontSize: 20),
                    ),
                  ),
                  StreamBuilder(
                    stream: pendingTask,
                    builder: (context, snapshot) {
                      if (snapshot.data.documents.length == 0) {
                        return Container(
                          height: 90,
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(child: Text("no tasks assingned")),
                        );
                      } else {
                        return Container(
                          height:
                              90 * snapshot.data.documents.length.toDouble(),
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
                                            builder: (context) => TaskDetails(
                                                  tradesmanEmail:
                                                      widget.tradesmanEmail,
                                                  customerEmail: snapshot
                                                      .data
                                                      .documents[index]
                                                      .data['customerEmail'],
                                                  customerId: snapshot
                                                      .data
                                                      .documents[index]
                                                      .data['customerId'],
                                                  tradesmanId:
                                                      widget.tradesmanId,
                                                  docId: snapshot
                                                      .data
                                                      .documents[index]
                                                      .documentID,
                                                  taskTitle: snapshot
                                                      .data
                                                      .documents[index]
                                                      .data['title'],
                                                  taskDetail: snapshot
                                                      .data
                                                      .documents[index]
                                                      .data['description'],
                                                  taskDate: snapshot
                                                      .data
                                                      .documents[index]
                                                      .data['date'],
                                                ))),
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
                                          .data.documents[index].data['title'],
                                      style: titlelabelStyle,
                                    ),
                                    subtitle: Text(
                                      snapshot
                                          .data.documents[index].data['date']
                                          .toString(),
                                      style: subtitlelabelStyle,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }
                    },
                  ),
                  Container(
                    height: 30,
                    width: 50,
                    child: CustomOutlineButton(
                      text: "See More",
                      onpressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PendingTaskPage(
                                    tradesmanId: widget.tradesmanId,
                                  ))),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("About",
                        style: titlelabelStyle.copyWith(fontSize: 20)),
                  ),
                  _about(),
                  SizedBox(
                    height: 50,
                  )
                ],
              ),
            ),
          )),
    );
  }

  Widget _about() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 150,
              width: MediaQuery.of(context).size.width * 0.41,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15), color: fillColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      LineIcons.heart,
                      color: Colors.red,
                      size: 50,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Number of Satisfied Customer",
                          style: titlelabelStyle,
                        ),
                        Text(
                          "89",
                          style: subtitlelabelStyle,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 150,
              width: MediaQuery.of(context).size.width * 0.41,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15), color: fillColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      LineIcons.star,
                      color: Colors.yellow,
                      size: 50,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Rating",
                          style: titlelabelStyle,
                        ),
                        Text(
                          "4.5/5",
                          style: subtitlelabelStyle,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _userProfileCard() {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.4,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomRight,
                colors: [primarySwatchColor, Color(0xffA494F0)]),
            borderRadius: BorderRadius.circular(15)),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    maxRadius: 40,
                    backgroundColor: backgroundColor,
                    backgroundImage: NetworkImage(
                        "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500"),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          widget.tradesmanUserName,
                          style: titlelabelStyle.copyWith(fontSize: 20),
                        ),
                        Text(
                          widget.tradesmanProfession,
                          style: subtitlelabelStyle,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SignInPage()));
  }
}
