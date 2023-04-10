import 'package:flutter/foundation.dart';
import 'package:googleapis/tasks/v1.dart';
import 'package:today/models/my_task.dart';
import 'package:today/models/my_list.dart';
import 'package:today/services/calendar_service.dart';

class TodayScreenManager {
  final tasksNotifier = ValueNotifier<MyList>(MyList());
  final listsNotifier = ValueNotifier<List<TaskList>>([]);

  loadTasks() async {
    tasksNotifier.value = await CalendarService().getTasks();
  }

  loadLists() async {
    listsNotifier.value = await CalendarService().getLists();
  }
}
