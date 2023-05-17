// Home page screen

import 'package:flutter/material.dart';
import 'package:today/models/my_list.dart';
import 'package:today/screens/tasks_screen/tasks_screen_manager.dart';
import 'package:today/services/service_locator.dart';
import 'package:today/services/task_service.dart';
import 'package:today/constants.dart';
import 'package:today/style/style_constants.dart';
import 'package:today/widgets/sliver_app_bar_widget.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';

import 'package:today/widgets/task_card.dart';

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
    var parentScrollController = ScrollController(initialScrollOffset: expandedAppBarHeight - kToolbarHeight);
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          TaskService().addTask(date: widgetManager.selectedDate.value);
        },
        label: Text('+ Add task'),
      ),
      body: NestedScrollView(
        controller: parentScrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverAppBar(
                backgroundColor: kBackgroundColor,
                pinned: true,
                snap: false,
                floating: false,
                expandedHeight: expandedAppBarHeight,
                // DEV-MODE:
                // flexibleSpace: Container(height: expandedAppBarHeight + kToolbarHeight, color: Colors.pink),
                flexibleSpace: SliverAppBarWidget(),
              ),
            ),
          ];
        },
        body: TaskList(parentController: parentScrollController),
      ),
    );
  }
}

class TaskList extends StatefulWidget {
  ScrollController parentController;
  TaskList({required this.parentController});

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  lockParentController() {
    double defaultParentHiddenPosition = widget.parentController.position.maxScrollExtent;

    // print('activity: ${widget.parentController.position.activity!.isScrolling}');
    // -BUG: https://github.com/flutter/flutter/issues/126336
    // widget.parentController.jumpTo(defaultParentHiddenPosition);
    // -WORKAROUND: below
    widget.parentController.animateTo(
      defaultParentHiddenPosition,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeIn,
    );
  }

  @override
  void initState() {
    widget.parentController.addListener(() async {
      double parentPosition = widget.parentController.offset;

      if (parentPosition == 0) {
        lockHeader = false;
      }

      if (lockHeader) {
        lockParentController();
        lockHeader = false;
      }
    });

    super.initState();
  }

  bool lockHeader = false;
  bool? isScrollingUp;

  final pageController = PageController(
    initialPage: todayIndex,
    // viewportFraction: 0.95,
  );

  final widgetManager = getIt<TodayScreenManager>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: kToolbarHeight + 3),
        child: NotificationListener<ScrollUpdateNotification>(
          onNotification: (notification) {
            // print('activity: ${notification.dragDetails.}');
            if (notification is ScrollEndNotification) {
              print('end');
            }
            if (notification.dragDetails != null) {
              if (notification.dragDetails!.primaryDelta != null) {
                if (notification.dragDetails!.primaryDelta! > 0) {
                  print('direction: up');
                  print('direction delta: ${notification.dragDetails!.delta}');
                  print('direction globalPosition: ${notification.dragDetails!.globalPosition}');
                  print('direction sourceTimeStamp: ${notification.dragDetails!.sourceTimeStamp}');
                  print('direction2 pixels: ${notification.metrics.pixels}');
                  isScrollingUp = true;
                } else {
                  print('direction: down');
                  isScrollingUp = false;
                }
              }
            }

            // This locks/hides the header when it passes through a threshold atEdge
            if (isScrollingUp != null) {
              if (isScrollingUp! && notification.metrics.atEdge) {
                if (lockHeader) {
                  lockParentController();
                }
                lockHeader = true;
              }
            }

            return false;
          },

          // DEV-MODE: alt1
          // child: ListView.builder(
          //   // shrinkWrap: true,
          //   // controller: ScrollController(),
          //   itemBuilder: (_, index) => ListTile(
          //     title: Text("index: ${index}"),
          //   ),
          // ),
          // DEV-MODE: alt2
          child: ValueListenableBuilder<MyList>(
              valueListenable: widgetManager.selectedList,
              builder: (context, selectedList, child) {
                return ListView.builder(
                  padding: EdgeInsets.fromLTRB(0, 52, 0, 40),
                  itemCount: selectedList.items.length,
                  itemBuilder: ((context, index) {
                    return ListTile(
                      title: Text("index: ${index}"),
                    );

                    return TaskCard(
                      key: Key(selectedList.items[index].dateIndex.toString()),
                      title: selectedList.items[index].title,
                      completed: selectedList.items[index].completed ?? false,
                      listTitle: selectedList.items[index].listId ?? 'null listId',
                    );
                  }),
                );
              }),
          // RELEASE-MODE:
          // child: PageView.builder(
          //   onPageChanged: (newPage) => widgetManager.changePage(pageController.page, newPage),
          //   // controller: pageController,
          //   itemBuilder: (context, index) {
          //     return ValueListenableBuilder<MyList>(
          //         valueListenable: widgetManager.selectedList,
          //         builder: (context, selectedList, child) {
          //           return ListView.builder(
          //             padding: EdgeInsets.fromLTRB(0, 52, 0, 40),
          //             itemCount: selectedList.items.length,
          //             itemBuilder: ((context, index) {
          //               return TaskCard(
          //                 key: Key(selectedList.items[index].dateIndex.toString()),
          //                 title: selectedList.items[index].title,
          //                 completed: selectedList.items[index].completed ?? false,
          //                 listTitle: selectedList.items[index].listId ?? 'null listId',
          //               );
          //             }),
          //           );
          //         });
          //   },
          // ),
        ),
      ),
    );
  }
}
