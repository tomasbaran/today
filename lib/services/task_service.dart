import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:today/models/my_list.dart';
import 'package:today/services/auth.dart';

class TaskService {
  final db = FirebaseFirestore.instance;
  String? uid = Auth().uid;

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? getList({DateTime? date, String? listId}) {
    if (uid == null) {
      throw ('Error #2[getting list]: User not signed in.');
    } else {
      final listDocRef;
      if (date != null) {
        String listDateId = '${date.year}-${date.month}-${date.day}_$uid';
        listDocRef = db.collection("users").doc(uid).collection('date_lists').doc(listDateId);
      } else {
        listDocRef = db.collection("users").doc(uid).collection('lists').doc(listId);
      }

      return listDocRef.snapshots().listen(
        (event) {
          log('event: $event;${event.data()}');
        },
        onError: (error) => log("Error #4: Listen failed: $error"),
      );
    }
  }

  updateList(MyList updatedList) {
    if (uid == null) {
      throw ('Error #6[updating task]: User not signed in.');
    } else {
      final DocumentReference<Map<String, dynamic>> listDocRef;
      listDocRef = db.collection("users").doc(uid).collection('date_lists').doc(updatedList.id);

      log('updatedList.tasks: ${updatedList.tasks}');
// REFACTOR#2: make separate functions for formatting from db->local and viceversa
//REFACTOR#2 also implement for adding a new task
//   // TODO: whenever a task has a new field, it has to be added here, so it is reflected upon reordering
      List<Map> formattedTasks = [];
      Map formattedTask;
      for (var task in updatedList.tasks) {
        formattedTask = {
          'id': task.id,
          'title': task.title,
          'completed': task.completed,
        };
        formattedTasks.add(formattedTask);
      }

      log('formattedTasks: $formattedTasks');

      listDocRef.update({'tasks': formattedTasks});
    }
  }

  addTask({DateTime? date, String? listId}) {
    if (uid == null) {
      throw ('Error #1[adding task]: User not signed in.');
    } else {
      final DocumentReference<Map<String, dynamic>> listDocRef;
      final String listTitle;
      if (date != null) {
        listTitle = '${date.year}-${date.month}-${date.day}';
        String listDateId = '${date.year}-${date.month}-${date.day}_$uid';
        // print(listDateId);
        listDocRef = db.collection("users").doc(uid).collection('date_lists').doc(listDateId);
        log('listDocRef: ${listDocRef.path}');
      } else {
        // TODO: Adding task in a list e.g. #Family
        listTitle = 'listTitle';
        listDocRef = db.collection("users").doc(uid).collection('lists').doc(listId);
      }
      // REFACTOR#2: add newTask via functions that convert local MyTask -> formatted dbMyTask
      final newTask = <String, dynamic>{
        'id': 'id3',
        'title': 'My Title ' + math.Random().nextInt(20).toString(),
        'completed': false,
      };

      listDocRef.set({
        'tasks': FieldValue.arrayUnion([newTask])
      }, SetOptions(merge: true)).then((value) {
        print('added a new task');
      }, onError: (e) {
        // TODO: Handle error with screen notification
        print('Error #3 adding a task:$e');
      });
    }
  }
}
