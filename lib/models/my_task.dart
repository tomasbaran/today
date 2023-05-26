class MyTask {
  DateTime? startTime;
  DateTime? finishTime;
  String title;
  bool completed;
  int? key;
  MyTask({
    this.startTime,
    this.finishTime,
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
