class MyTask {
  String title;
  bool completed;
  int? key;
  MyTask({
    this.key,
    required this.title,
    this.completed = false,
  });

  @override
  String toString() {
    return '[$key] $title: $completed';
  }
}
