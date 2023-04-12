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

  StreamSubscription<DocumentSnapshot>? getTasks({
    required String listId,
    bool isDateList = false,
  }) {
    log('--------0');
    if (auth.currentUser != null) {
      String uid = auth.currentUser!.uid;
      if (isDateList) {
        listId = listId + '_' + uid;
      }

      final listDocRef = db.collection("users").doc(uid).collection('date_lists').doc(listId);

      MyList myList = MyList();
      myList.items.add(MyTask(id: 'id', title: 'title'));
      return listDocRef.snapshots().listen(
        (event) {
          print('event: $event');

          myList = MyList();
          final listData = event.data();
          int i = 0;
          for (var task in listData?['tasks']) {
            print("id: ${task['id']}, title: ${task['title']})");
            myList.items.add(MyTask(id: task['id'], title: task['title'], dateIndex: i++));
            print('myList: ${myList.items.first.id}');
            print('myList-start: ${myList.items.length}');
          }
          print("date: ${listData}");
          print('myList-end: ${myList.items.length}');
          // yield MyList();
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
