class MyTask {
  String id;
  String title;
  String? listId;
  bool completed;
  DateTime? createdOn;
  DateTime? scheduledFor;
  int? dateIndex;
  int key;
  // DEV-MODE: listIndex
  // int listIndex;
  MyTask({
    required this.key,
    required this.id,
    required this.title,
    this.dateIndex,
    this.completed = false,
    this.createdOn,
    this.listId,
    // DEV-MODE: listIndex
    // required this.listIndex,
    this.scheduledFor,
  });

  @override
  String toString() {
    return '[$key] $title: $completed';
  }
}
