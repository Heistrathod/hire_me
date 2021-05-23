import 'package:flutter/material.dart';
import 'package:hire_me_app/services/database.dart';
import 'package:hire_me_app/shared/styles.dart';
import 'package:hire_me_app/views/Widgets/flat_button_helper.dart';
import 'package:intl/intl.dart';
import 'package:unicons/unicons.dart';

class TaskDetails extends StatefulWidget {
  final String taskTitle, taskDetail, docId, tradesmanId;
  final String customerId, customerEmail;
  final tradesmanEmail;
  final String taskDate;

  const TaskDetails({
    Key key,
    this.taskTitle,
    this.taskDetail,
    this.taskDate,
    this.docId,
    this.tradesmanId,
    this.customerId,
    this.customerEmail,
    this.tradesmanEmail,
  }) : super(key: key);

  @override
  _TaskDetailsState createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetails> {
  UserCollection completedTasks = new UserCollection();

  @override
  Widget build(BuildContext context) {
    print(widget.docId);
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: labelColor),
          elevation: 0,
          backgroundColor: backgroundColor,
          title: Text(
            "Details",
            style: titlelabelStyle.copyWith(fontSize: 25),
          ),
        ),
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: ListView(
            children: [
              SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0, left: 10.0),
                child: Text(
                  widget.taskTitle,
                  style: titlelabelStyle.copyWith(fontSize: 22),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0, left: 10.0),
                child: Text(
                  "To be done on " + widget.taskDate,
                  style: subtitlelabelStyle.copyWith(fontSize: 15),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: const EdgeInsets.only(top: 10.0, left: 10.0),
                  height: 350,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: fillColor),
                  child: (Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        UniconsLine.constructor_1,
                        size: 35,
                        color: primarySwatchColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          widget.taskDetail,
                          style: subtitlelabelStyle,
                        ),
                      ),
                    ],
                  )),
                ),
              ),
              SizedBox(
                height: 140,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FlatButtonHelper(
                  text: "Completed",
                  onPressed: () {
                    print(widget.customerEmail);
                    print(widget.customerId);
                    print(widget.tradesmanEmail);
                    addToCompletedTasks();
                    Navigator.of(context).pop();
                  },
                ),
              )
            ],
          ),
        ));
  }

  addToCompletedTasks() {
    Map<String, dynamic> task = {
      'title': this.widget.taskTitle,
      'description': this.widget.taskDetail,
      'date': this.widget.taskDate,
      'customerEmail': this.widget.customerEmail,
      'customerId': this.widget.customerId
    };
    completedTasks.addCompletedTask(task, widget.tradesmanId);
    completedTasks.deleteTask(widget.docId, widget.tradesmanId);
    completedTasks.previouslyHired(
        widget.customerId, widget.customerEmail, task);
    completedTasks.deleteCurrentlyTask(
        widget.customerEmail, widget.customerId, widget.tradesmanEmail);
  }

  String readTimestamp(int timestamp) {
    var now = DateTime.now();
    var format = DateFormat('HH:mm a');
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    var diff = now.difference(date);
    var time = '';

    if (diff.inSeconds <= 0 ||
        diff.inSeconds > 0 && diff.inMinutes == 0 ||
        diff.inMinutes > 0 && diff.inHours == 0 ||
        diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    } else if (diff.inDays > 0 && diff.inDays < 7) {
      if (diff.inDays == 1) {
        time = diff.inDays.toString() + ' DAY AGO';
      } else {
        time = diff.inDays.toString() + ' DAYS AGO';
      }
    } else {
      if (diff.inDays == 7) {
        time = (diff.inDays / 7).floor().toString() + ' WEEK AGO';
      } else {
        time = (diff.inDays / 7).floor().toString() + ' WEEKS AGO';
      }
    }

    return time;
  }
}
