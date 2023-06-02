import 'package:flutter/material.dart';
import 'package:today/models/my_task.dart';
import 'package:today/screens/tasks_screen/tasks_screen_manager.dart';
import 'package:today/services/service_locator.dart';
import 'package:today/style/style_constants.dart';
import 'package:today/widgets/time_card.dart';

class TaskCard extends StatelessWidget {
  final double elevation;
  final MyTask task;
  const TaskCard({
    required this.task,
    super.key,
    this.elevation = 0,
  });

  @override
  Widget build(BuildContext context) {
    final tasksScreenManager = getIt<TasksScreenManager>();
    return Card(
      elevation: elevation,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(cardRadius)),
      child: Row(
        children: [
          TimeCard(
            taskStartTime: task.startTime,
            taskEndTime: task.endTime,
          ),
          Expanded(
            child: Container(
              color: task.completed ? Colors.black12 : null,
              height: 68,
              child: Stack(children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(cardRadius, cardRadius, 36, cardRadius),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      task.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: taskCardTitleTextStyle.copyWith(
                        color: task.completed ? Colors.black54 : null,
                        decoration: task.completed ? TextDecoration.lineThrough : null,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Checkbox(
                    value: task.completed,
                    onChanged: (newValue) {
                      tasksScreenManager.toggleTaskCompleted(task);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(cardRadius),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    // This is where the listTitle will go.
                    // E.g. #Family, #Health, #Project
                    // child: Text(
                    //   task.listTitle ?? '',
                    // ),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
