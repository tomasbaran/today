// Home page screen

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:googleapis/tasks/v1.dart';
import 'package:today/models/my_list.dart';
import 'package:today/models/my_task.dart';
import 'package:today/models/my_list.dart';
import 'package:today/screens/today_screen/today_screen_manager.dart';
import 'package:today/services/calendar_service.dart';
import 'package:today/services/service_locator.dart';
import 'package:today/services/task_service.dart';
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
    screenManager.getList();
    // screenManager.loadLists();
  }

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;
    String username = currentUser?.displayName ?? 'unknown';

    // CalendarService().showTasksOnADate(DateTime.now());

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => TaskService().addTask(date: DateTime.now()),
        label: Text('+ Add task'),
      ),
      appBar: AppBar(
        // backgroundColor: Colors.green,
        centerTitle: true,

        // on appbar text containing 'GEEKS FOR GEEKS'
        title: Text("Today for $username"),
      ),

      // In body text containing 'Home page ' in center
      body: ValueListenableBuilder<MyList>(
          valueListenable: screenManager.listNotifier,
          builder: (context, myTasks, child) {
            return ListView.builder(
              itemCount: myTasks.items.length,
              itemBuilder: ((context, index) {
                log('index: $index');
                return TaskCard(
                  key: Key(myTasks.items[index].dateIndex.toString()),
                  title: myTasks.items[index].title,
                  completed: myTasks.items[index].completed ?? false,
                  listTitle: myTasks.items[index].listId ?? 'null listId',
                );
              }),
            );

            return ReorderableListView.builder(
              itemCount: myTasks.items.length,
              onReorder: (oldIndex, newIndex) {
                // print('oldIndex: $oldIndex');
                // print('newIndex: $newIndex');
                // int changePosition = newIndex - oldIndex;

                // for (MyTask task in myTasks.items) {
                //   print('task[${task.id}]: ${task.dateIndex}');
                // }

                // setState(() {
                //   if (oldIndex < newIndex) {
                //     newIndex -= 1;
                //   }
                //   final MyTask item = myTasks.items.removeAt(oldIndex);
                //   myTasks.items.insert(newIndex, item);
                // });
                // int tmpIndex = 0;
                // for (MyTask task in myTasks.items) {
                //   task.dateIndex = tmpIndex++;
                //   log('task[${task.id}]: ${task.dateIndex}');
                // }
              },
              itemBuilder: ((context, index) {
                return TaskCard(
                  key: Key(myTasks.items[index].dateIndex.toString()),
                  title: myTasks.items[index].title,
                  completed: myTasks.items[index].completed ?? false,
                  listTitle: myTasks.items[index].listId ?? 'null listId',
                );
              }),
            );

            // return ListView.builder(
            //   itemCount: tasks.length,
            //   itemBuilder: ((context, index) {
            //     // DEV-MODE:
            //     // return Text('${lists[index].title}:${lists[index].id} ' ?? 'null list');
            //     // RELEASE-MODE:

            //     return TaskCard(
            //       title: tasks[index].title ?? 'null title',
            //       hidden: tasks[index].hidden ?? false,
            //       listTitle: tasks[index].position ?? 'null list',
            //     );
            //   }),
            // );
          }),
    );
  }
}
