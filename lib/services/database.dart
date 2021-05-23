import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserCollection {
  String docId;
  bool isLoggedIn() {
    if (FirebaseAuth.instance.currentUser != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> tradesmanProfiles(tradesmanData, email) async {
    if (isLoggedIn()) {
      Firestore.instance.collection(email).add(tradesmanData).catchError((e) {
        print(e);
      });
    } else {
      print("U need to be Logged in");
    }
  }

  Future<void> addTradesman(tradesmanData, tradesmanId) async {
    if (isLoggedIn()) {
      Firestore.instance
          .collection("TradesmanData")
          .document(tradesmanId)
          .setData(tradesmanData)
          .catchError((e) {
        print(e);
      });
    } else {
      print("U need to be Logged in");
    }
  }

  Future<void> userProfiles(customerData, email, customerId) async {
    if (isLoggedIn()) {
      Firestore.instance
          .collection(email)
          .document(customerId)
          .setData(customerData)
          .catchError((e) {
        print(e);
      });
    } else {
      print("U need to be Logged in");
    }
  }

  Future<Stream> getTradesman() async {
    Stream result = Firestore.instance.collection('TradesmanData').snapshots();

    return result;
  }

  Future<Stream> getTradesmanProfile(email) async {
    Stream result = Firestore.instance.collection(email).snapshots();
    return result;
  }

  Future<QuerySnapshot> getUserRole(email) async {
    QuerySnapshot result =
        await Firestore.instance.collection(email).getDocuments();
    return result;
  }

  Future<void> addTask(task, tradesmanId) async {
    CollectionReference tradesmanref =
        Firestore.instance.collection("TradesmanData");
    tradesmanref.document(tradesmanId).collection("PendingTasks").add(task);
  }

  Future<Stream> getPendingTasks(uid) async {
    Stream result = Firestore.instance
        .collection("TradesmanData")
        .document(uid)
        .collection("PendingTasks")
        .snapshots();
    return result;
  }

  deleteTask(docId, uid) async {
    return Firestore.instance
        .collection('TradesmanData')
        .document(uid)
        .collection("PendingTasks")
        .document(docId)
        .delete()
        .catchError((e) {
      print(e);
    });
  }

  Future<void> addCompletedTask(task, tradesmanId) async {
    CollectionReference tradesmanref =
        Firestore.instance.collection("TradesmanData");
    tradesmanref.document(tradesmanId).collection("CompletedTasks").add(task);
  }

  Future<Stream> getCompletedTasks(tradesmanId) async {
    Stream result = Firestore.instance
        .collection("TradesmanData")
        .document(tradesmanId)
        .collection("CompletedTasks")
        .snapshots();
    return result;
  }

  Future<void> currentlyHired(
      customerId, customerEmail, tradesmanEmail, task) async {
    CollectionReference customerRef =
        Firestore.instance.collection(customerEmail);
    customerRef
        .document(customerId)
        .collection("currentlyHired")
        .document(tradesmanEmail)
        .setData(task);
  }

  Future<void> previouslyHired(customerId, customerEmail, task) async {
    CollectionReference customerRef =
        Firestore.instance.collection(customerEmail);
    customerRef.document(customerId).collection("previouslyHired").add(task);
  }

  deleteCurrentlyTask(customerEmail, customerId, tradesmanId) async {
    return Firestore.instance
        .collection(customerEmail)
        .document(customerId)
        .collection("currentlyHired")
        .document(tradesmanId)
        .delete()
        .catchError((e) {
      print(e);
    });
  }

  Future<Stream> getCurrentlyTasks(custEmail, custId) async {
    Stream result = Firestore.instance
        .collection(custEmail)
        .document(custId)
        .collection("currentlyHired")
        .snapshots();
    return result;
  }

  Future<Stream> getprevTasks(
    custEmail,
    custId,
  ) async {
    Stream result = Firestore.instance
        .collection(custEmail)
        .document(custId)
        .collection("previouslyHired")
        .snapshots();
    return result;
  }
}
