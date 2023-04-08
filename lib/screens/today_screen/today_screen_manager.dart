import 'package:flutter/foundation.dart';
import 'package:today/models/task_model.dart';

class TodayScreenManager {
  final tasksNotifier = ValueNotifier<List<TaskModel>>([]);

  loadTasks() {
    tasksNotifier.value.add(TaskModel(title: 'Task One'));
  }
}
