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

  getList() {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    TaskService().getList(date: today)?.onData((data) {
      final listData = data.data();
      int i = 0;
      MyList myList = MyList();

      if (listData != null && listData.isNotEmpty) {
        print('listData: $listData');
        for (var task in listData['tasks']) {
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
