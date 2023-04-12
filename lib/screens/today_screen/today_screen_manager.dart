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
      final listData = data.data();
      int i = 0;
      MyList myList = MyList();

      for (var task in listData?['tasks']) {
        print("id: ${task['id']}, title: ${task['title']}");
        myList.items.add(MyTask(id: task['id'], title: task['title'], dateIndex: i++));
      }

      listNotifier.value = myList;
    });
  }
}
