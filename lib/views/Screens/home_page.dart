import 'package:flutter/material.dart';
import 'package:hire_me_app/services/database.dart';
import 'package:hire_me_app/shared/styles.dart';
import 'package:hire_me_app/views/Screens/partner_detail.dart';
import 'package:hire_me_app/views/Screens/user_profile.dart';
import 'package:line_icons/line_icons.dart';

class HomePage extends StatefulWidget {
  final String customerId, customerEmail;

  const HomePage({Key key, this.customerId, this.customerEmail})
      : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Stream tradesmanList;

  UserCollection tradesman = new UserCollection();
  @override
  void initState() {
    tradesman.getTradesman().then((result) {
      setState(() {
        tradesmanList = result;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: primarySwatchColor),
          elevation: 0.5,
          backgroundColor: backgroundColor,
          title: Text(
            "Home",
            style: titlelabelStyle,
          ),
          actions: [
            IconButton(
              icon: Icon(LineIcons.user),
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CustomerProfile(
                            custEmail: widget.customerEmail,
                            custId: widget.customerId,
                          ))),
              color: primarySwatchColor,
            )
          ],
        ),
        backgroundColor: backgroundColor,
        body: StreamBuilder(
          stream: tradesmanList,
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return Center(child: CircularProgressIndicator());
            } else {
              return ListView.builder(
                physics: BouncingScrollPhysics(),
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
                                builder: (context) => PartnerDetailPage(
                                      customerEmail: widget.customerEmail,
                                      customerId: widget.customerId,
                                      tradesmanId: snapshot
                                          .data.documents[index].data['uid'],
                                      tradesmanFullName: snapshot.data
                                          .documents[index].data['fullName'],
                                      tradesmanProfession: snapshot.data
                                          .documents[index].data['profession'],
                                      tradesmanAddress: snapshot.data
                                          .documents[index].data['address'],
                                      tradesmanPhoneNo: snapshot.data
                                          .documents[index].data['phoneNumber'],
                                      tradesmanEmail: snapshot
                                          .data.documents[index].data['email'],
                                      image:
                                          "https://i.pravatar.cc/450?img=$index",
                                      tag:
                                          "https://i.pravatar.cc/450?img=$index",
                                    ))),
                        contentPadding: const EdgeInsets.all(0),
                        leading: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: primarySwatchColor)),
                          child: Hero(
                            tag: "https://i.pravatar.cc/450?img=$index",
                            child: CircleAvatar(
                              maxRadius: 40,
                              backgroundColor: backgroundColor,
                              backgroundImage: NetworkImage(
                                "https://i.pravatar.cc/450?img=$index",
                              ),
                            ),
                          ),
                        ),
                        title: Text(
                          snapshot.data.documents[index].data['fullName'],
                          style: titlelabelStyle,
                        ),
                        subtitle: Text(
                          snapshot.data.documents[index].data['profession'] +
                              "\n" +
                              snapshot.data.documents[index].data['address'],
                          style: subtitlelabelStyle,
                        ),
                        isThreeLine: true,
                        trailing: IconButton(
                          icon: Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: primarySwatchColor,
                            size: 13,
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ));
  }
}
