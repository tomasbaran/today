import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:googleapis/tasks/v1.dart';
import 'package:today/models/dumby_data.dart';
import 'package:today/models/my_task.dart';
import 'package:today/models/my_list.dart';
import 'package:today/services/calendar_service.dart';
import 'package:today/services/task_service.dart';

class TodayScreenManager {
  final listNotifier = ValueNotifier<MyList>(MyList());

  getList({DateTime? date, String? listId}) {
    log('getList for: $date');
    MyList myList = MyList();
    TaskService().getList(date: date)?.onData((data) {
      final listData = data.data();
      int i = 0;

      if (listData != null && listData.isNotEmpty) {
        myList.title = listData['title'];
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
