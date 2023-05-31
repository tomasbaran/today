class MyTask {
  DateTime? startTime;
  DateTime? endTime;
  String title;
  bool completed;
  int? key;
  MyTask({
    this.startTime,
    this.endTime,
    this.key,
    required this.title,
    this.completed = false,
  });

  @override
  String toString() {
    return '\n[$key] $title: $completed; $startTime';
  }

  toggleCompleted() {
    completed = !completed;
  }
}
