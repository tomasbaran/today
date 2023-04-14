// Home page screen

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:googleapis/tasks/v1.dart';
import 'package:today/models/my_list.dart';
import 'package:today/models/my_task.dart';
import 'package:today/models/my_list.dart';
import 'package:today/screens/tasks_screen/tasks_screen_manager.dart';
import 'package:today/services/calendar_service.dart';
import 'package:today/services/service_locator.dart';
import 'package:today/services/task_service.dart';
import 'package:today/widgets/task_card.dart';
import 'package:today/constants.dart';

class TasksScreen extends StatefulWidget {
  DateTime? date;
  String? listId;
  TasksScreen({
    Key? key,
    this.date,
    this.listId,
  }) : super(key: key);

  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final widgetManager = getIt<TodayScreenManager>();

  @override
  void initState() {
    super.initState();
    widgetManager.getList(date: widgetManager.selectedDate.value);
  }

  @override
  Widget build(BuildContext context) {
    final pageController = PageController(
      initialPage: todayIndex,
      viewportFraction: 0.95,
    );
    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            TaskService().addTask(date: widgetManager.selectedDate.value);
          },
          label: Text('+ Add task'),
        ),
        appBar: AppBar(
          // backgroundColor: Colors.green,
          centerTitle: true,

          // on appbar text containing 'GEEKS FOR GEEKS'
          title: Column(
            children: [
              ValueListenableBuilder(
                valueListenable: widgetManager.selectedList,
                builder: ((_, selectedList, __) => Text(selectedList.title ?? '...')),
              ),
            ],
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.question_mark),
              onPressed: () {
                widgetManager.showAnotherDay(DateTime(2023, 1, 1));
              },
            ),
            IconButton(
              icon: const Icon(Icons.arrow_right),
              onPressed: () {
                widgetManager.showNextDay();
              },
            ),
          ],
        ),
        body: PageView.builder(
            onPageChanged: (newPage) {
              print('${pageController.page} -> $newPage; ');
              if (pageController.page != null) {
                if (newPage.toDouble() > pageController.page!) {
                  widgetManager.showNextDay();
                } else {
                  widgetManager.showPreviousDay();
                }
              }
            },
            controller: pageController,
            itemBuilder: (context, index) {
              return ValueListenableBuilder<MyList>(
                  valueListenable: widgetManager.selectedList,
                  builder: (context, selectedList, child) {
                    return ListView.builder(
                      itemCount: selectedList.items.length,
                      itemBuilder: ((context, index) {
                        return TaskCard(
                          key: Key(selectedList.items[index].dateIndex.toString()),
                          title: selectedList.items[index].title,
                          completed: selectedList.items[index].completed ?? false,
                          listTitle: selectedList.items[index].listId ?? 'null listId',
                        );
                      }),
                    );

                    // const Placeholder(color:Color.fromARGB(0, 255, 0, 0)),
                    // const Placeholder(color:Color.fromARGB(0, 0, 255, 0)),
                  });
            }));

//             return ReorderableListView.builder(
//               itemCount: selectedList.items.length,
//               onReorder: (oldIndex, newIndex) {
//                 // print('oldIndex: $oldIndex');
//                 // print('newIndex: $newIndex');
//                 // int changePosition = newIndex - oldIndex;

//                 // for (MyTask task in myTasks.items) {
//                 //   print('task[${task.id}]: ${task.dateIndex}');
//                 // }

//                 // setState(() {
//                 //   if (oldIndex < newIndex) {
//                 //     newIndex -= 1;
//                 //   }
//                 //   final MyTask item = myTasks.items.removeAt(oldIndex);
//                 //   myTasks.items.insert(newIndex, item);
//                 // });
//                 // int tmpIndex = 0;
//                 // for (MyTask task in myTasks.items) {
//                 //   task.dateIndex = tmpIndex++;
//                 //   log('task[${task.id}]: ${task.dateIndex}');
//                 // }
//               },
//               itemBuilder: ((context, index) {
//                 return TaskCard(
//                   key: Key(selectedList.items[index].dateIndex.toString()),
//                   title: selectedList.items[index].title,
//                   completed: selectedList.items[index].completed ?? false,
//                   listTitle: selectedList.items[index].listId ?? 'null listId',
//                 );
//               }),
//             );

//             // return ListView.builder(
//             //   itemCount: tasks.length,
//             //   itemBuilder: ((context, index) {
//             //     // DEV-MODE:
//             //     // return Text('${lists[index].title}:${lists[index].id} ' ?? 'null list');
//             //     // RELEASE-MODE:

//             //     return TaskCard(
//             //       title: tasks[index].title ?? 'null title',
//             //       hidden: tasks[index].hidden ?? false,
//             //       listTitle: tasks[index].position ?? 'null list',
//             //     );
//             //   }),
//             // );
//           }),
//     );
//   }
  }
}
