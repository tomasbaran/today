class MyTask {
  String id;
  String title;
  String? listId;
  bool completed;
  DateTime? createdOn;
  DateTime? scheduledFor;
  int? dateIndex;
  int? listIndex;
  MyTask({
    required this.id,
    required this.title,
    this.dateIndex,
    this.completed = false,
    this.createdOn,
    this.listId,
    this.listIndex,
    this.scheduledFor,
  });
}
