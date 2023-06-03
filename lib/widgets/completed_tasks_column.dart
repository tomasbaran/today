import 'package:flutter/material.dart';
import 'package:today/screens/tasks_screen/tasks_screen_manager.dart';
import 'package:today/services/service_locator.dart';
import 'package:today/style/style_constants.dart';
import 'package:today/widgets/task_card.dart';

class CompletedTasksColumn extends StatelessWidget {
  final widgetManager = getIt<TasksScreenManager>();
  final double fillInHeight;
  CompletedTasksColumn({
    super.key,
    required this.fillInHeight,
  });

  List<Widget> children() {
    List<Widget> output = [];
    output.add(
      Padding(
        padding: EdgeInsets.only(top: fillInHeight < defaultFillInHeight ? defaultFillInHeight : fillInHeight, left: 12, bottom: 20),
        child: Text('COMPLETED: ${widgetManager.selectedList.value.completedTasks.length}'),
      ),
    );
    for (var completedTask in widgetManager.selectedList.value.completedTasks) {
      output.add(TaskCard(
        task: completedTask,
      ));
    }
    return output;
  }

  @override
  Widget build(BuildContext context) {
    // onLongPress: ()=>{} makes it NOT reorderable
    return GestureDetector(
      onLongPress: () => {
        // print('holdme')
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children(),
      ),
    );
  }
}
