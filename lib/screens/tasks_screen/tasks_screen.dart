import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:today/screens/tasks_screen/tasks_screen_manager.dart';
import 'package:today/services/service_locator.dart';
import 'package:today/style/style_constants.dart';
import 'package:today/widgets/floating_container.dart';
import 'package:today/widgets/tasks_container.dart';
import 'package:today/widgets/add_new_task_sheet.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final widgetManager = getIt<TasksScreenManager>();
  @override
  void initState() {
    super.initState();
    widgetManager.getDateList();
  }

  ScrollController parentScrollController = ScrollController(initialScrollOffset: expandedAppBarHeight - kToolbarHeight);
  @override
  Widget build(BuildContext context) {
    widgetManager.getScreenMeasurments(context);
    return GestureDetector(
      onTap: () => widgetManager.updateNavBarSelection(NavBarSelection.unselected),
      child: Scaffold(
        appBar: AppBar(
          shadowColor: Colors.transparent,
          title: ValueListenableBuilder(
            valueListenable: widgetManager.selectedList,
            builder: ((_, selectedList, __) => Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      selectedList.title ?? '...',
                      style: collapsedAppBarTitleTextStyle,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      selectedList.date == null ? '?' : DateFormat.MMMMd('en_US').format(selectedList.date!),
                      style: collapsedAppBarSubtitleTextStyle,
                    ),
                  ],
                )),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingContainer(),
        body: TasksContainer(),
      ),
    );
  }
}
