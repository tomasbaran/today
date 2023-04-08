// Home page screen

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:googleapis/tasks/v1.dart';
import 'package:today/models/task_model.dart';
import 'package:today/screens/today_screen/today_screen_manager.dart';
import 'package:today/services/calendar_service.dart';
import 'package:today/services/service_locator.dart';
import 'package:today/widgets/task_card.dart';

class TodayScreen extends StatefulWidget {
  TodayScreen({Key? key}) : super(key: key);

  @override
  _TodayScreenState createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  final screenManager = getIt<TodayScreenManager>();

  @override
  void initState() {
    super.initState();
    screenManager.loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;
    String username = currentUser?.displayName ?? 'unknown';

    // CalendarService().showTasksOnADate(DateTime.now());

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => CalendarService().addEvent(),
        label: Text('+ Add task'),
      ),
      appBar: AppBar(
        // backgroundColor: Colors.green,
        centerTitle: true,

        // on appbar text containing 'GEEKS FOR GEEKS'
        title: Text("Today for $username"),
      ),

      // In body text containing 'Home page ' in center
      body: ValueListenableBuilder<List<TaskModel>>(
          valueListenable: screenManager.tasksNotifier,
          builder: (context, tasks, child) {
            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: ((context, index) {
                return TaskCard(title: tasks[index].title);
              }),
            );
          }),
    );
  }
}
