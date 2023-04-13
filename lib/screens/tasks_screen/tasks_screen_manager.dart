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

  addTask({DateTime? date, String? listId}) {}

  getList({DateTime? date, String? listId}) {
    MyList myList = MyList();

    if (date != null) {
      log('getList for: $date');
      myList.title = date.toString();
    }

    if (listId != null) {
      myList.title = listId;
    }

    TaskService().getList(date: date)?.onData((data) {
      final dbList = data.data();
      int i = 0;

      if (dbList != null && dbList.isNotEmpty) {
        print('listData: $dbList');
        for (var task in dbList['tasks']) {
          print('task: $task');
          print("id: ${task['id']}, title: ${task['title']}");
          myList.items.add(MyTask(
            id: task['id'],
            title: task['title'],
            dateIndex: i++,
          ));
        }
      } else {
        // else there are no tasks for that day assigned (yet)
        print('no tasks for that day');
      }

      listNotifier.value = myList;
    });
  }
}
