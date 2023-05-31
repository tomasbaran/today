import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:today/screens/tasks_screen/tasks_screen_manager.dart';
import 'package:today/services/service_locator.dart';
import 'package:today/style/style_constants.dart';
import 'package:today/widgets/task_time_tile.dart';

class AddNewTaskSheet extends StatelessWidget {
  AddNewTaskSheet({super.key});
  final widgetManager = getIt<TasksScreenManager>();

  @override
  Widget build(BuildContext context) {
    String? taskTitle;
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        shadowColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.cancel),
          color: Colors.grey,
        ),
        title: const Text(
          'Add New Task',
          style: addNewTaskSheetTitleTextStyle,
        ),
        actions: [
          TextButton(
            child: const Text(
              'Add',
              style: addNewTaskSheetButtonsTextStyle,
            ),
            onPressed: () {
              widgetManager.addTaskToDateList(title: taskTitle);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          CupertinoListSection.insetGrouped(
            children: [
              CupertinoListTile.notched(
                title: TextField(
                  style: addNewTaskSheetTaskTitleTextStyle,
                  maxLines: 2,
                  onChanged: (text) => taskTitle = text,
                  autofocus: true,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(hintText: 'Write Task Title', border: InputBorder.none),
                ),
              ),
            ],
          ),
          CupertinoListSection.insetGrouped(
            dividerMargin: cupertinoListTileLeadingSize,
            children: [
              GestureDetector(
                onTap: () {},
                child: const TaskTimeTile(
                  title: 'Starts',
                  icon: Icons.access_time,
                  value: 'not assigned',
                ),
              ),
              const TaskTimeTile(
                title: 'Ends',
                icon: Icons.access_time_filled,
                value: 'not assigned',
              ),
              TaskTimeTile(
                title: 'Date',
                icon: Icons.calendar_today_rounded,
                value: DateFormat.yMMMMd('en_US').format(widgetManager.selectedDate.value),
              ),
            ],
          ),
          const Expanded(
            child: SizedBox(),
          ),
        ],
      ),
    );
  }
}
