import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:today/globals/constants.dart';
import 'package:today/models/my_task.dart';
import 'package:today/models/my_list.dart';
import 'package:today/services/date_time_service.dart';
import 'package:today/services/task_service.dart';
import 'package:today/style/style_constants.dart';

enum NavBarSelection {
  unselected,
  calendar,
  list,
}

class TasksScreenManager {
  final selectedList = ValueNotifier<MyList>(MyList());
  MyTask? _selectedTask;
  get selectedTask => _selectedTask;
  set selectTask(MyTask task) => _selectedTask = task;
  unselectTask() {
    _selectedTask = null;
  }

  DateTime _selectedDate = DateTime.now();
  final isSelectedDateToday = ValueNotifier<bool>(true);

  final navBar = ValueNotifier<NavBarSelection>(NavBarSelection.unselected);

  updateNavBarSelection(NavBarSelection newNavBarSelection) => navBar.value = newNavBarSelection;

  DateTime get selectedDate => _selectedDate;

  final pageController = PageController(initialPage: todayIndex, viewportFraction: 0.95);

  updateSelectedDate(DateTime newDateTime) {
    _selectedDate = newDateTime;

    checkIfSelectedDateIsToday();
    getDateList();
  }

  checkIfSelectedDateIsToday() {
    DateTimeService().isSpecialDay(DateTime.now(), _selectedDate) == MyDate.isToday
        ? isSelectedDateToday.value = true
        : isSelectedDateToday.value = false;
  }

  double screenHeight = 0;
  EdgeInsets safeArea = EdgeInsets.zero;
  getScreenMeasurments(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    safeArea = MediaQuery.of(context).padding;
  }

  double calcEmptySpaceHeight() =>
      screenHeight -
      safeArea.top - //iOS status bar
      AppBar().preferredSize.height - //appBar's height
      (selectedList.value.tasks.length * taskCardHeight) -
      completedTitleHeight -
      completedTitleBottomPadding -
      calcFloatingBottomSafeArea();

  double calcFloatingBottomSafeArea() => safeArea.bottom + floatingNavBarContainerHeight + 4;

  changePage(double oldPageIndex, int newPageIndex) {
    // print('$oldPageIndex -> $newPageIndex');
    if (newPageIndex.toDouble() > oldPageIndex) {
      updateSelectedDate(_selectedDate.add(const Duration(days: 1)));
    } else {
      updateSelectedDate(_selectedDate.subtract(const Duration(days: 1)));
    }
  }

  updateTask({
    required DateTime originalDate,
    String? newTitle,
    DateTime? newStartTime,
    DateTime? newEndTime,
  }) {
    DateTime newDate = _selectedDate;
    MyTask? originalTask = _selectedTask;
    log('\x1B[31moriginal[$originalDate]selectedTask[${originalTask!.key}]: ${originalTask.title}');
    log('\x1B[32m[$newDate]widgetManager.updateTask: $newTitle, $newStartTime, $newEndTime  \x1B[0m');
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
