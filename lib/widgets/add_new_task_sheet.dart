import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:today/screens/tasks_screen/tasks_screen_manager.dart';
import 'package:today/services/service_locator.dart';
import 'package:today/style/style_constants.dart';
import 'package:today/widgets/task_time_tile.dart';
import 'package:today/services/date_time_service.dart';

class AddNewTaskSheet extends StatefulWidget {
  final String title;
  const AddNewTaskSheet({super.key, required this.title});

  @override
  State<AddNewTaskSheet> createState() => _AddNewTaskSheetState();
}

class _AddNewTaskSheetState extends State<AddNewTaskSheet> {
  final widgetManager = getIt<TasksScreenManager>();
  String? taskTitle;
  DateTime? startTime;
  DateTime? endTime;

  @override
  void initState() {
    taskTitle = widgetManager.selectedTask?.title;
    startTime = widgetManager.selectedTask?.startTime;
    endTime = widgetManager.selectedTask?.endTime;
    super.initState();
  }

  @override
  void dispose() {
    widgetManager.unselectTask();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.cancel),
          color: kThemeColor4,
        ),
        title: Text(
          widget.title,
          style: addNewTaskSheetTitleTextStyle,
        ),
        actions: [
          TextButton(
            child: const Text(
              'Add',
              style: addNewTaskSheetButtonsTextStyle,
            ),
            onPressed: () {
              widgetManager.addTaskToDateList(
                title: taskTitle,
                startTime: startTime,
                endTime: endTime,
              );
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
                backgroundColor: kBackgroundColor,
                title: TextField(
                  controller: TextEditingController.fromValue(TextEditingValue(text: taskTitle ?? '')),
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
                child: TaskTimeTile(
                  title: 'Starts',
                  icon: Icons.access_time,
                  value: startTime == null ? null : DateTimeService().formatTime(startTime!),
                ),
                onTap: () => DateTimeService().showCupertinoTimePicker(
                  context: context,
                  defaultTime: startTime,
                  onDateTimeChanged: (DateTime newTime) {
                    setState(() => startTime = newTime);
                  },
                ),
              ),
              GestureDetector(
                child: TaskTimeTile(
                  title: 'Ends',
                  icon: Icons.access_time_filled,
                  value: endTime == null ? null : DateTimeService().formatTime(endTime!),
                ),
                onTap: () => DateTimeService().showCupertinoTimePicker(
                  context: context,
                  onDateTimeChanged: (DateTime newTime) {
                    setState(() => endTime = newTime);
                  },
                  defaultTime: endTime ?? startTime,
                ),
              ),
              GestureDetector(
                child: TaskTimeTile(
                  title: 'Date',
                  icon: CupertinoIcons.calendar,
                  value: DateFormat.yMMMMd('en_US').format(widgetManager.selectedDate),
                ),
                onTap: () => showDatePicker(
                  context: context,
                  initialDate: widgetManager.selectedDate,
                  firstDate: DateTime(2021),
                  lastDate: DateTime(2050),
                ).then((newDate) {
                  if (newDate != null) {
                    setState(() {
                      widgetManager.updateSelectedDate(newDate);
                    });
                  }
                }),
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
