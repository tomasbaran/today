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
  final selectedList = ValueNotifier<MyList>(MyList());
  final selectedDate = ValueNotifier<DateTime>(DateTime.now());

  showAnotherDay(DateTime newDate) {
    selectedDate.value = newDate;
    getList(date: selectedDate.value);
  }

  showNextDay() {
    selectedDate.value = selectedDate.value.add(Duration(days: 1));
    getList(date: selectedDate.value);
  }

  showPreviousDay() {
    selectedDate.value = selectedDate.value.subtract(Duration(days: 1));
    getList(date: selectedDate.value);
  }

  addTask({DateTime? date, String? listId}) {}

  getList({DateTime? date, String? listId}) {
    TaskService().getList(date: date)?.onData((data) {
      MyList myList = MyList();
      if (date != null) {
        log('getList for: $date');
        myList.title = date.toString();
      }

      if (listId != null) {
        myList.title = listId;
      }
      final dbList = data.data();

      if (dbList != null && dbList.isNotEmpty) {
        print('listData: $dbList');
        for (var dbTask in dbList['tasks']) {
          print('dbTask: $dbTask');
          myList.items.add(MyTask(
            id: dbTask['id'],
            title: dbTask['title'],
          ));
        }
      } else {
        // else there are no tasks for that day assigned (yet)
        print('no tasks for that day');
      }
      selectedList.value = myList;
    });
  }
}
