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

  changePage(double? oldPageIndex, int newPageIndex) {
    print('$oldPageIndex -> $newPageIndex');
    if (oldPageIndex != null) {
      if (newPageIndex.toDouble() > oldPageIndex) {
        showNextDay();
      } else {
        showPreviousDay();
      }
    }
  }

  showAnyDay(DateTime newDate) {
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

  addTask({DateTime? date}) {
    TaskService().addTask(date: date);
  }

  bool reorderIsUpdating = false;
  // REFACTOR#1: Is Future,async,await necessary?
  // REFACTOR#1: Is reorderIsUpdating necessary?
  Future reorderList(int oldIndex, int newIndex) async {
    reorderIsUpdating = true;

    if (newIndex < oldIndex) {
      newIndex = newIndex + 1;
    }
    final element = selectedList.value.tasks.removeAt(oldIndex);
    selectedList.value.tasks.insert(newIndex, element);

    log('reordered List: ${selectedList.value}');

    await TaskService().updateList(selectedList.value);

    reorderIsUpdating = false;
  }

  getList({DateTime? date, String? listId}) {
    TaskService().getList(date: date)?.onData((data) async {
      // REFACTOR#1: Is reorderIsUpdating necessary?
      // don't update the screen nor the list while the reordering is happening
      while (reorderIsUpdating) {
        await Future.delayed(const Duration(milliseconds: 100));
        print('waiting');
      }
      MyList myList = MyList();
      if (date != null) {
        myList.title = date.toString();
        myList.id = data.id;
      }

      if (listId != null) {
        myList.title = listId;
      }
      final Map<String, dynamic>? dbList = data.data();

      if (dbList != null && dbList.isNotEmpty) {
        // print('getList.onData: $dbList');
        // for (final dbTask in dbList['tasks']) {
        //   // print('readTask: $dbTask');
        //   myList.items.add(MyTask(
        //     // listId: ,
        //     key: dbTask,
        //     id: dbTask['id'],
        //     title: dbTask['title'],
        //     // DEV-MODE: listIndex
        //     // listIndex: dbTask['list_index'],
        //   ));
        //   print('loadedTask: ${myList.items.last}');
        // }

        // ------------------START
        List dbTasks = dbList['tasks'];

        dbTasks.asMap().forEach((key, value) {
          MyTask task = MyTask(
            key: key,
            id: value['id'],
            title: value['title'],
          );
          myList.tasks.add(task);
          print('loadedTask as Map: ${task}');
        });
        // -------------------END
      } else {
        // else there are no tasks for that day assigned (yet)
        print('no tasks for that day');
      }
      // DEV-MODE: listIndex
      // orderBy `listIndex`
      // myList.items.sort((a, b) => b.listIndex.compareTo(a.listIndex));
      selectedList.value = myList;
    });
  }
}
