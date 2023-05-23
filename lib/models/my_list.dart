import 'package:today/models/my_task.dart';

class MyList {
  String? title;
  String? id;
  List<MyTask> tasks;
  MyList({
    this.title,
    this.id,
  }) : tasks = [];

  @override
  String toString() {
    return '$id.items: $tasks';
  }
}
