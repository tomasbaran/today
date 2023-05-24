import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:today/models/my_list.dart';
import 'package:today/services/auth.dart';
import 'package:logger/logger.dart';

class TaskService {
  final db = FirebaseFirestore.instance;
  String? uid = Auth().uid;

  // REFACTOR: ? maybe better have two seperate functions: getListByDate, getListById
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? getListByDate({DateTime? date, String? listId}) {
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
        onError: (error) {
          log('Error #4: Listen failed: $error');
          throw 'Error #4: Listen failed: $error';
        },
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
          'title': task.title,
          'completed': task.completed,
        };
        formattedTasks.add(formattedTask);
      }

      log('formattedTasks: $formattedTasks');
      listDocRef.update({'tasks': formattedTasks}).onError((error, stackTrace) {
        log('\x1B[31mError #6[updating task]: $error\x1B[0m');
        Logger(printer: PrettyPrinter(colors: false)).e('Error #6[updating task]: $error');
      });
    }
  }

  addTaskToDateList(DateTime date) {
    if (uid == null) {
      throw ('Error #1[adding task]: User not signed in.');
    } else {
      final DocumentReference<Map<String, dynamic>> listDocRef;
      final String listTitle;

      listTitle = '${date.year}-${date.month}-${date.day}';
      String listDateId = '${date.year}-${date.month}-${date.day}_$uid';
      listDocRef = db.collection("users").doc(uid).collection('date_lists').doc(listDateId);
      log('listDocRef: ${listDocRef.path}');

      // REFACTOR#2: add newTask via functions that convert local MyTask -> formatted dbMyTask
      String randomTitle = 'My Title ' + math.Random().nextInt(20).toString();
      final newTask = <String, dynamic>{
        'title': randomTitle,
        'completed': false,
      };

      log('adding new task: $randomTitle');

      listDocRef.set({
        'tasks': FieldValue.arrayUnion([newTask])
      }, SetOptions(merge: true)).then((value) {
        print('added a new task');
      }, onError: (e) {
        log('\x1B[31mError #3[adding task]: $e\x1B[0m');
        Logger(printer: PrettyPrinter(colors: false)).e('Error #3[adding task]: $e');
      });
    }
  }
}
