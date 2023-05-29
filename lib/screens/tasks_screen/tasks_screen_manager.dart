import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:today/models/my_task.dart';
import 'package:today/models/my_list.dart';
import 'package:today/services/task_service.dart';
import 'package:today/style/style_constants.dart';

class TasksScreenManager {
  final selectedList = ValueNotifier<MyList>(MyList());
  final selectedDate = ValueNotifier<DateTime>(DateTime.now());

  countFillInHeight(double screenHeight, double safeAreaBottom) =>
      screenHeight - (selectedList.value.tasks.length * taskCardHeight) - kTextTabBarHeight - safeAreaBottom - bottomCompletedPadding;

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
    getDateList();
  }

  showNextDay() {
    selectedDate.value = selectedDate.value.add(const Duration(days: 1));
    getDateList();
  }

  showPreviousDay() {
    selectedDate.value = selectedDate.value.subtract(const Duration(days: 1));
    getDateList();
  }

  addTaskToDateList() {
    String randomTitle = 'My Title ' + math.Random().nextInt(20).toString();
    DateTime startTime = selectedDate.value;
    DateTime finishTime = selectedDate.value.add(const Duration(hours: 1));
    MyTask newHardCodedTask = MyTask(
      title: randomTitle,
      startTime: startTime,
      finishTime: finishTime,
    );
    TaskService().addTaskToDateList(newHardCodedTask, selectedDate.value);
  }

  toggleTaskCompleted(MyTask task) {
    selectedList.value.tasks.firstWhere((element) => element.key == task.key).toggleCompleted();
    TaskService().updateDateList(selectedList.value);
  }

  reorderList(int oldIndex, int newIndex) {
    // print('0. before ordering List: ${selectedList.value}');

    if (newIndex < oldIndex) {
      newIndex = newIndex + 1;
    }
    final element = selectedList.value.tasks.removeAt(oldIndex);
    selectedList.value.tasks.insert(newIndex, element);
    print('1. reordered List: ${selectedList.value}');
    TaskService().updateDateList(selectedList.value);
  }

  getDateList() {
    TaskService().getDateList(date: selectedDate.value)?.onData((data) {
      selectedList.value = TaskService().formatFirebaseSnapshotToMyList(
        firebaseSnapshot: data,
        myListTitle: selectedDate.value.toString(),
      );
    });
  }
}
