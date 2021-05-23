import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hire_me_app/services/database.dart';
import 'package:hire_me_app/shared/styles.dart';
import 'package:hire_me_app/views/Screens/task_detail_page.dart';

class PendingTaskPage extends StatefulWidget {
  final String docId, tradesmanId;

  final Timestamp taskDate;
  const PendingTaskPage({Key key, this.docId, this.tradesmanId, this.taskDate})
      : super(key: key);

  @override
  _PendingTaskPageState createState() => _PendingTaskPageState();
}

class _PendingTaskPageState extends State<PendingTaskPage> {
  UserCollection getTasks = new UserCollection();
  Stream pendingTasks;
  Stream completedTasks;
  @override
  void initState() {
    getTasks.getPendingTasks(widget.tradesmanId).then((result) {
      setState(() {
        pendingTasks = result;
      });
    });
    getTasks.getCompletedTasks(widget.tradesmanId).then((result) {
      setState(() {
        completedTasks = result;
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
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: IconThemeData(
              color: labelColor,
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                DefaultTabController(
                  length: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TabBar(
                        tabs: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Pending",
                              style: titlelabelStyle,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Completed",
                              style: titlelabelStyle,
                            ),
                          )
                        ],
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height,
                        child: (TabBarView(
                          children: [
                            pendingTaskTile(),
                            completedTaskTile(),
                          ],
                        )),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Widget pendingTaskTile() {
    return StreamBuilder(
      stream: pendingTasks,
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  tileColor: fillColor,
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TaskDetails(
                                tradesmanId: widget.tradesmanId,
                                docId:
                                    snapshot.data.documents[index].documentID,
                                taskTitle: snapshot
                                    .data.documents[index].data['title'],
                                taskDetail: snapshot
                                    .data.documents[index].data['description'],
                                taskDate:
                                    snapshot.data.documents[index].data['date'],
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
                    snapshot.data.documents[index].data['title'],
                    style: titlelabelStyle,
                  ),
                  subtitle: Text(
                    snapshot.data.documents[index].data['date'].toString(),
                    style: subtitlelabelStyle,
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }

  Widget completedTaskTile() {
    return StreamBuilder(
      stream: completedTasks,
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  tileColor: fillColor,
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TaskDetails(
                                tradesmanId: widget.tradesmanId,
                                docId:
                                    snapshot.data.documents[index].documentID,
                                taskTitle: snapshot
                                    .data.documents[index].data['title'],
                                taskDetail: snapshot
                                    .data.documents[index].data['description'],
                                taskDate:
                                    snapshot.data.documents[index].data['date'],
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
                    snapshot.data.documents[index].data['title'],
                    style: titlelabelStyle,
                  ),
                  subtitle: Text(
                    snapshot.data.documents[index].data['date'].toString(),
                    style: subtitlelabelStyle,
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
