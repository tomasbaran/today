class MyTask {
  String id;
  String title;
  String? listId;
  bool completed;
  DateTime? createdOn;
  DateTime? scheduledFor;
  int? dateIndex;
  int key;
  MyTask({
    required this.key,
    required this.id,
    required this.title,
    this.dateIndex,
    this.completed = false,
    this.createdOn,
    this.listId,
    this.scheduledFor,
  });

  @override
  String toString() {
    return '[$key] $title: $completed';
  }
}
