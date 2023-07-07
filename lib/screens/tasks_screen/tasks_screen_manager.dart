import 'dart:async';
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
    listenToDateList();
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

  removeTaskFromList({
    required DateTime date,
    required MyTask task,
  }) async {
    final dateListSnapshot = await TaskService().getDateListSnapshot(date);

    MyList dateList = TaskService().convertFirebaseSnapshotToMyList(
      firebaseSnapshot: dateListSnapshot,
      myListTitle: DateTimeService().niceDateTimeString(date),
      listDate: date,
    );
    log('old dateList: ${dateList.tasks}');

    // delete task locally
    dateList.tasks.removeAt(task.key!);
    log('new dateList: ${dateList.tasks}');

    // delete task in the db
    await TaskService().updateDateListInDatabase(dateList);
  }

  updateTask({
    required DateTime originalDate,
    String? newTitle,
    DateTime? newStartTime,
    DateTime? newEndTime,
  }) async {
    MyTask? originalTask = _selectedTask;

    log('\x1B[31moriginal[$originalDate]selectedTask[${originalTask!.key}]: ${originalTask.title}');

    DateTime newDate = _selectedDate;

    MyTask newTask = originalTask;
    if (newTitle != null) {
      newTask.title = newTitle;
    }
    if (newStartTime != null) {
      newTask.startTime = newStartTime;
    }
    if (newEndTime != null) {
      newTask.endTime = newEndTime;
    }
    log('\x1B[32m[$newDate]widgetManager.updateTask: ${newTask.title}, ${newTask.startTime}, ${newTask.endTime}  \x1B[0m');

    // check whether the date was changed
    if (DateTimeService().isSpecialDay(originalDate, newDate) == MyDate.isToday) {
      // SAME DAY
      log('original: SAME DAY[${newTask.key}]: ${selectedList.value.tasks[newTask.key!]}');
      // update the new task to the selectedList locally
      selectedList.value.tasks[newTask.key!] = newTask;
      log('new: SAME DAY[${newTask.key}]: ${selectedList.value.tasks[newTask.key!]}');
    } else {
      // DIFF DAY
      log('DIFF DAY');
      // delete the original task from the original date in the db
      removeTaskFromList(date: originalDate, task: originalTask);
      // add new task the selectedList locally
      selectedList.value.tasks.add(newTask);
    }

    // update the list with the updated task in db
    log('final updateDateList: ${selectedList.value}');
    TaskService().updateDateListInDatabase(selectedList.value);
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

    TaskService().updateDateListInDatabase(selectedList.value);
  }

  reorderList(int oldIndex, int newIndex) {
    // print('0. before ordering List: ${selectedList.value}');

    if (newIndex < oldIndex) {
      newIndex = newIndex + 1;
    }
    final element = selectedList.value.tasks.removeAt(oldIndex);
    selectedList.value.tasks.insert(newIndex, element);
    print('1. reordered List: ${selectedList.value}');
    TaskService().updateDateListInDatabase(selectedList.value);
  }

  StreamSubscription? _subscription;

  listenToDateList() {
    _subscription?.cancel();

    _subscription = TaskService().listenToDateListSnapshot(date: _selectedDate);
    _subscription?.onData((data) {
      try {
        log('selected DAY [$_selectedDate]: ${selectedList.value.tasks}');
        selectedList.value = TaskService().convertFirebaseSnapshotToMyList(
          firebaseSnapshot: data,
          myListTitle: DateTimeService().niceDateTimeString(_selectedDate),
          listDate: _selectedDate,
        );
      } catch (e) {
        throw 'Error #12: $e';
      }
    });
  }

  disposeSubscription() {
    _subscription?.cancel();
  }
}
