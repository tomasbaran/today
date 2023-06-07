import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:today/globals/constants.dart';
import 'package:today/models/my_task.dart';
import 'package:today/models/my_list.dart';
import 'package:today/services/date_time_service.dart';
import 'package:today/services/task_service.dart';
import 'package:today/style/style_constants.dart';

class TasksScreenManager {
  final selectedList = ValueNotifier<MyList>(MyList());
  DateTime _selectedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;

  final pageController = PageController(initialPage: todayIndex, viewportFraction: 0.95);

  updateSelectedDate(DateTime newDateTime) {
    _selectedDate = newDateTime;
    getDateList();
  }

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
    _selectedDate = newDate;
    getDateList();
  }

  showNextDay() {
    _selectedDate = _selectedDate.add(const Duration(days: 1));
    getDateList();
  }

  showPreviousDay() {
    _selectedDate = _selectedDate.subtract(const Duration(days: 1));
    getDateList();
  }

  addTaskToDateList({
    required String? title,
    DateTime? startTime,
    DateTime? endTime,
  }) {
    // use selectedDate's date and startTime's time
    startTime = DateTimeService().mixDateAndTime(_selectedDate, startTime);
    // use selectedDate's date and endTime's time
    endTime = DateTimeService().mixDateAndTime(_selectedDate, endTime);
    // Don't add an empty titled task
    if (title != null) {
      MyTask newTask = MyTask(
        title: title,
        startTime: startTime,
        endTime: endTime,
      );
      TaskService().addTaskToDateList(newTask, _selectedDate);
    }
  }

  toggleTaskCompleted(MyTask task) {
    if (!task.completed) {
      selectedList.value.tasks.remove(task);

      task.toggleCompleted();
      selectedList.value.completedTasks.add(task);
    } else {
      selectedList.value.completedTasks.remove(task);

      task.toggleCompleted();
      selectedList.value.tasks.add(task);
    }

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
    TaskService().getDateList(date: _selectedDate)?.onData((data) {
      selectedList.value = TaskService().convertFirebaseSnapshotToMyList(
        firebaseSnapshot: data,
        myListTitle: DateTimeService().niceDateTimeString(_selectedDate),
        listDate: _selectedDate,
      );
    });
  }
}
