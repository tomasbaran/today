class MyTask {
  DateTime? startTime;
  DateTime? finishTime;
  DateTime? date;
  String title;
  bool completed;
  int? key;
  MyTask({
    this.startTime,
    this.finishTime,
    this.date,
    this.key,
    required this.title,
    this.completed = false,
  });

  @override
  String toString() {
    return '\n[$key] $title: $completed; $startTime';
  }
}
