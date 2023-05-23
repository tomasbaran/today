import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:today/models/my_task.dart';
import 'package:today/models/my_list.dart';
import 'package:today/services/task_service.dart';

class TasksScreenManager {
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

  reorderList(int oldIndex, int newIndex) {
    if (newIndex < oldIndex) {
      newIndex = newIndex + 1;
    }
    final element = selectedList.value.tasks.removeAt(oldIndex);
    selectedList.value.tasks.insert(newIndex, element);
    log('reordered List: ${selectedList.value}');

    TaskService().updateList(selectedList.value);
  }

  getList({DateTime? date, String? listId}) {
    TaskService().getList(date: date)?.onData((data) async {
      MyList myList = MyList();
      if (date != null) {
        myList.title = date.toString();
        myList.id = data.id;
      }

      if (listId != null) {
        myList.title = listId;
      }
      final Map<String, dynamic>? dbList = data.data();
      if (dbList != null) {
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
      } else {
        // else there are no tasks for that day assigned (yet)
        print('no tasks for that day');
      }
      selectedList.value = myList;
    });
  }
}
