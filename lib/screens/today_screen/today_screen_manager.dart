import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:googleapis/tasks/v1.dart';
import 'package:today/models/my_task.dart';
import 'package:today/models/my_list.dart';
import 'package:today/services/calendar_service.dart';
import 'package:today/services/task_service.dart';

class TodayScreenManager {
  final listNotifier = ValueNotifier<MyList>(MyList());

  getTasks() {
    TaskService().getTasks(listId: '2023-04-13', isDateList: true)?.onData((data) {
      log('*: ${data}');
    });

    // TaskService().getTasks(
    //       listId: '2023-04-13',
    //       isDateList: true,
    //     ) ??
    //     MyList();

    // final db = FirebaseFirestore.instance;
    // final FirebaseAuth auth = FirebaseAuth.instance;

    // if (auth.currentUser != null) {
    //   String uid = auth.currentUser!.uid;
    //   String listId;
    //   if (true) {
    //     listId = '2023-04-13' + '_' + uid;
    //   }

    //   final listDocRef = db.collection("users").doc(uid).collection('date_lists').doc(listId);
    //   listDocRef.snapshots().listen(
    //     (event) {
    //       listNotifier.value = MyList();
    //       final listData = event.data();
    //       print('listData: $listData');
    //       int i = 0;
    //       for (var task in listData?['tasks']) {
    //         print("id: ${task['id']}, title: ${task['title']})");
    //         listNotifier.value.items.add(MyTask(id: task['id'], title: task['title'], dateIndex: task['index']));

    //         print('myList: ${listNotifier.value.items.first.id}');
    //         print('myList-start: ${listNotifier.value.items.length}');
    //       }
    //       print("date: ${listData}");
    //       print('myList-end: ${listNotifier.value.items.length}');
    //     },
    //     onError: (error) => print("Listen failed: $error"),
    //   );
    // }
  }
}
