import 'package:flutter/material.dart';
import 'package:today/screens/tasks_screen/tasks_screen_manager.dart';
import 'package:today/services/service_locator.dart';
import 'package:today/style/style_constants.dart';
import 'package:today/widgets/sliver_app_bar_widget.dart';
import 'package:today/widgets/tasks_container.dart';

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
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => widgetManager.addTaskToDateList(),
        label: const Text('+ Add task'),
      ),
      body: NestedScrollView(
        controller: parentScrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: const SliverAppBar(
                backgroundColor: kBackgroundColor,
                pinned: true,
                expandedHeight: expandedAppBarHeight,
                flexibleSpace: SliverAppBarWidget(),
              ),
            ),
          ];
        },
        body: TasksContainer(parentController: parentScrollController),
      ),
    );
  }
}
