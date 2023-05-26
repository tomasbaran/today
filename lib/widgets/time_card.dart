import 'package:flutter/material.dart';
import 'package:today/screens/tasks_screen/tasks_screen_manager.dart';
import 'package:today/services/service_locator.dart';
import 'package:today/style/style_constants.dart';
import 'package:intl/intl.dart';

class TimeCard extends StatelessWidget {
  final DateTime? taskStartTime;
  final DateTime? taskFinishTime;
  const TimeCard({
    super.key,
    this.taskFinishTime,
    this.taskStartTime,
  });

  @override
  Widget build(BuildContext context) {
    final tasksScreenManager = getIt<TasksScreenManager>();

    String startTimeString = taskStartTime == null ? '' : '${taskStartTime!.hour}:${taskStartTime!.minute.toString().padLeft(2, '0')}';
    String finishTimeString = taskFinishTime == null ? '' : '${taskFinishTime!.hour}:${taskFinishTime!.minute.toString().padLeft(2, '0')}';
    String dateString = taskStartTime == null ? '' : '${taskStartTime!.day} ${DateFormat('MMM').format(taskStartTime!)}';
    final selectedDate = tasksScreenManager.selectedDate.value;
    bool taskDateEqualsSelectedListDate() =>
        (taskStartTime?.day == selectedDate.day && taskStartTime?.month == selectedDate.month && taskStartTime?.year == selectedDate.year);

    return Visibility(
      visible: taskStartTime != null,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.horizontal(left: Radius.circular(cardRadius)),
          color: kDefaultHighlightColor,
        ),
        height: 68,
        width: 64,
        child: Padding(
          padding: EdgeInsets.all(taskDateEqualsSelectedListDate() ? 6 : 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(startTimeString, style: timeCardTextStyle),
              Text(
                taskDateEqualsSelectedListDate() ? '' : dateString,
                style: timeCardTextStyle,
              ),
              Text(finishTimeString, style: timeCardTextStyle),
            ],
          ),
        ),
      ),
    );
  }
}
