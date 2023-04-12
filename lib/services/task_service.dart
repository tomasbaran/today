import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:today/models/dumby_data.dart';
import 'package:today/models/my_list.dart';
import 'package:today/models/my_task.dart';
import 'package:today/screens/today_screen/today_screen.dart';
import 'package:today/screens/today_screen/today_screen_manager.dart';

class TaskService {
  final db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? getTasks({
    required String listId,
    bool isDateList = false,
  }) {
    if (auth.currentUser != null) {
      String uid = auth.currentUser!.uid;
      if (isDateList) {
        listId = listId + '_' + uid;
      }

      final listDocRef = db.collection("users").doc(uid).collection('date_lists').doc(listId);

      return listDocRef.snapshots().listen(
        (event) {
          print('event: $event;${event.data()}');
        },
        onError: (error) => print("Listen failed: $error"),
      );
    }
  }

  addTask() async {
    print('-----');
    if (auth.currentUser != null) {
      print(auth.currentUser!.uid);
      // Create a new user with a first and last name
      final user = <String, dynamic>{
        "first": "Ada",
        "last": "Lovelace",
        "born": 1815,
      };

      String uid = auth.currentUser!.uid;

      db.collection('users').doc(uid).set(user).then((value) => print('added'));

// Add a new document with a generated ID
      // await db.collection("users").add(user).then((DocumentReference doc) => print('DocumentSnapshot added with ID: ${doc.id}'));
    } else {
      throw ('Error #1: User not signed in.');
    }
  }
}
