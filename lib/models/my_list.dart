import 'package:today/models/my_task.dart';

class MyList {
  String? title;
  List<MyTask> items;
  int? index;
  DateTime? scheduledFor;
  MyList({
    this.title,
    this.index,
    this.scheduledFor,
  }) : items = [];
}
