import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:today/models/my_list.dart';
import 'package:today/models/my_task.dart';
import 'package:today/services/auth.dart';
import 'package:logger/logger.dart';

class TaskService {
  final _db = FirebaseFirestore.instance;
  final String? _uid = Auth().uid;

  // REFACTOR #100: ? maybe better have two seperate functions: getListByDate, getListById
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? getDateList({DateTime? date, String? listId}) {
    if (_uid == null) {
      throw ('Error #2[getting list]: User not signed in.');
    } else {
      final DocumentReference<Map<String, dynamic>> listDocRef;
      // REFACTOR #100: ? maybe better have two seperate functions: getListByDate, getListById
      if (date != null) {
        String listDateId = '${date.year}-${date.month}-${date.day}_$_uid';
        listDocRef = _db.collection("users").doc(_uid).collection('date_lists').doc(listDateId);
      } else {
        listDocRef = _db.collection("users").doc(_uid).collection('id_lists').doc(listId);
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

  updateDateList(MyList updatedList) {
    if (_uid == null) {
      throw ('Error #6[updating task]: User not signed in.');
    } else {
      log('updatedList: $updatedList');

      Map<Object, Object> formattedUpdatedList = formatMyListToFirebaseList(updatedList);
      final DocumentReference<Map<String, dynamic>> listDocRef = _db.collection("users").doc(_uid).collection('date_lists').doc(updatedList.id);

      listDocRef.update(formattedUpdatedList).onError((error, stackTrace) {
        log('\x1B[31mError #6[updating task]: $error\x1B[0m');
        Logger(printer: PrettyPrinter(colors: false)).e('Error #6[updating task]: $error');
      });
    }
  }

  addTaskToDateList(MyTask myTask, DateTime date) {
    if (_uid == null) {
      throw ('Error #1[adding task]: User not signed in.');
    } else {
      final DocumentReference<Map<String, dynamic>> listDocRef;

      String listDateId = '${date.year}-${date.month}-${date.day}_$_uid';
      listDocRef = _db.collection("users").doc(_uid).collection('date_lists').doc(listDateId);
      log('listDocRef: ${listDocRef.path}');

      Map formattedTask = formatMyTaskToFirebaseTask(myTask);
      log('adding new task: $formattedTask');

      listDocRef.set({
        'tasks': FieldValue.arrayUnion([formattedTask])
      }, SetOptions(merge: true)).then((value) {
        print('added a new task');
      }, onError: (e) {
        log('\x1B[31mError #3[adding task]: $e\x1B[0m');
        Logger(printer: PrettyPrinter(colors: false)).e('Error #3[adding task]: $e');
      });
    }
  }

  Map<String, dynamic> formatMyTaskToFirebaseTask(MyTask myTask) => {
        'title': myTask.title,
        'completed': myTask.completed,
      };

  Map<Object, Object> formatMyListToFirebaseList(MyList myList) {
    List<Map> firebaseTasks = [];

    for (var task in myList.tasks) {
      Map firebaseTask = {
        'title': task.title,
        'completed': task.completed,
      };
      firebaseTasks.add(firebaseTask);
    }

    Map<Object, Object> firebaseList = {
      'tasks': firebaseTasks,
    };
    log('formattedList: $firebaseList');

    return firebaseList;
  }

  MyList formatFirebaseSnapshotToMyList({
    required DocumentSnapshot<Map<String, dynamic>> firebaseSnapshot,
    required String myListTitle,
  }) {
    MyList myList = MyList();
    myList.title = myListTitle;
    myList.id = firebaseSnapshot.id;

    final Map<String, dynamic>? firebaseList = firebaseSnapshot.data();

    if (firebaseList == null) {
      // there are no tasks for that day assigned (yet)
      print('no tasks for that day');
      return myList;
    } else {
      List firebaseTasks = firebaseList['tasks'];
      firebaseTasks.asMap().forEach(
        (key, value) {
          MyTask myTask = MyTask(
            key: key,
            title: value['title'],
            completed: value['completed'],
          );
          myList.tasks.add(myTask);
        },
      );
      return myList;
    }
  }
}
