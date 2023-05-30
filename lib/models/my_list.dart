import 'package:today/models/my_task.dart';

class MyList {
  String? title;
  String? id;
  List<MyTask> tasks;
  List<MyTask> completedTasks;
  MyList({
    this.title,
    this.id,
  })  : tasks = [],
        completedTasks = [];

  @override
  String toString() {
    return '\ntasks: $tasks\ncompleted: $completedTasks';
  }
}
