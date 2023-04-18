import 'package:flutter/material.dart';
import 'package:today/screens/tasks_screen/tasks_screen_manager.dart';
import 'package:today/services/service_locator.dart';

class CollapsedAppBar extends StatelessWidget {
  const CollapsedAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final tasksScreenManager = getIt<TodayScreenManager>();
    return AppBar(
      backgroundColor: Color(0xFFFAFAFA),
      shadowColor: Colors.transparent,
      centerTitle: true,
      title: Column(
        children: [
          ValueListenableBuilder(
            valueListenable: tasksScreenManager.selectedList,
            builder: ((_, selectedList, __) => Text(
                  selectedList.title ?? '...',
                  style: TextStyle(color: Colors.blue),
                )),
          ),
        ],
      ),
      // actions: <Widget>[
      //   IconButton(
      //     icon: const Icon(Icons.question_mark),
      //     onPressed: () {
      //       tasksScreenManager.showAnotherDay(DateTime(2023, 1, 1));
      //     },
      //   ),
      //   IconButton(
      //     icon: const Icon(Icons.arrow_right),
      //     onPressed: () {
      //       tasksScreenManager.showNextDay();
      //     },
      //   ),
      // ],
    );
  }
}
