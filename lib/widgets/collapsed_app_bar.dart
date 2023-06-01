import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:today/screens/tasks_screen/tasks_screen_manager.dart';
import 'package:today/services/service_locator.dart';
import 'package:today/style/style_constants.dart';

class CollapsedAppBar extends StatelessWidget {
  const CollapsedAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final tasksScreenManager = getIt<TasksScreenManager>();
    return AppBar(
      backgroundColor: kBackgroundColor,
      shadowColor: Colors.transparent,
      centerTitle: true,
      title: ValueListenableBuilder(
        valueListenable: tasksScreenManager.selectedList,
        builder: ((_, selectedList, __) => Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  selectedList.title ?? '...',
                  style: collapsedAppBarTitleTextStyle,
                ),
                Text(
                  selectedList.date == null ? '?' : DateFormat.MMMMd('en_US').format(selectedList.date!),
                  style: collapsedAppBarSubtitleTextStyle,
                ),
                const SizedBox(height: 16),
              ],
            )),
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
