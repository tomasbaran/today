import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:today/models/my_task.dart';
import 'package:today/models/my_list.dart';
import 'package:today/services/task_service.dart';

class TasksScreenManager {
  final selectedList = ValueNotifier<MyList>(MyList());
  final selectedDate = ValueNotifier<DateTime>(DateTime.now());

  changePage(double oldPageIndex, int newPageIndex) {
    // print('$oldPageIndex -> $newPageIndex');
    if (newPageIndex.toDouble() > oldPageIndex) {
      showNextDay();
    } else {
      showPreviousDay();
    }
  }

  showAnyDay(DateTime newDate) {
    selectedDate.value = newDate;
    getListBySelectedDate();
  }

  showNextDay() {
    selectedDate.value = selectedDate.value.add(const Duration(days: 1));
    getListBySelectedDate();
  }

  showPreviousDay() {
    selectedDate.value = selectedDate.value.subtract(const Duration(days: 1));
    getListBySelectedDate();
  }

  addTaskToDateList() {
    TaskService().addTaskToDateList(selectedDate.value);
  }

  reorderList(int oldIndex, int newIndex) {
    if (newIndex < oldIndex) {
      newIndex = newIndex + 1;
    }
    final element = selectedList.value.tasks.removeAt(oldIndex);
    selectedList.value.tasks.insert(newIndex, element);
    log('reordered List: ${selectedList.value}');

    TaskService().updateDateList(selectedList.value);
  }

  getListBySelectedDate() {
    TaskService().getDateList(date: selectedDate.value)?.onData((data) {
      MyList myList = MyList();
      myList.title = selectedDate.value.toString();
      myList.id = data.id;

      final Map<String, dynamic>? dbList = data.data();
      log('newData!');
      if (dbList == null) {
        // there are no tasks for that day assigned (yet)
        print('no tasks for that day');
      } else {
        List dbTasks = dbList['tasks'];
        dbTasks.asMap().forEach((key, value) {
          MyTask task = MyTask(
            key: key,
            title: value['title'],
          );
          myList.tasks.add(task);
          print('loadedTask as Map: ${task}');
        });
      }
      selectedList.value = myList;
    });
  }
}
