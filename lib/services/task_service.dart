import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:today/models/dumby_data.dart';
import 'package:today/models/my_list.dart';
import 'package:today/models/my_task.dart';
import 'package:today/screens/tasks_screen/tasks_screen.dart';
import 'package:today/screens/tasks_screen/tasks_screen_manager.dart';

class TaskService {
  final db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? getList({
    DateTime? date,
    String? listId,
  }) {
    if (auth.currentUser != null) {
      String uid = auth.currentUser!.uid;

      final listDocRef;
      if (date != null) {
        String listDateId = '${date.year}-${date.month}-${date.day}_$uid';
        // print(listDateId);
        listDocRef = db.collection("users").doc(uid).collection('date_lists').doc(listDateId);
      } else {
        listDocRef = db.collection("users").doc(uid).collection('lists').doc(listId);
      }

      return listDocRef.snapshots().listen(
        (event) {
          print('event: $event;${event.data()}');
        },
        onError: (error) => print("Listen failed: $error"),
      );
    } else {
      throw ('Error #2: User not signed in.');
    }
  }

  addTask({DateTime? date, String? listId}) async {
    if (auth.currentUser != null) {
      String uid = auth.currentUser!.uid;
      final DocumentReference<Map<String, dynamic>> listDocRef;
      final String listTitle;
      if (date != null) {
        listTitle = '${date.year}-${date.month}-${date.day}';
        String listDateId = '${date.year}-${date.month}-${date.day}_$uid';
        // print(listDateId);
        listDocRef = db.collection("users").doc(uid).collection('date_lists').doc(listDateId);
      } else {
        // TODO:
        listTitle = 'listTitle';
        listDocRef = db.collection("users").doc(uid).collection('lists').doc(listId);
      }

      final newTask = <String, dynamic>{
        'id': 'id3',
        'title': 'My Title 4',
        'completed': false,
      };

      listDocRef.update({
        'title': listTitle,
        'tasks': FieldValue.arrayUnion([newTask])
      }).then(
        (value) => print('added a new task'),
        onError: (e) => print('Error #3 adding a task:$e'),
      );
    } else {
      throw ('Error #1: User not signed in.');
    }
  }
}
