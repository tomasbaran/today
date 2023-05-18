// Home page screen

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:today/models/my_list.dart';
import 'package:today/screens/tasks_screen/tasks_screen_manager.dart';
import 'package:today/services/service_locator.dart';
import 'package:today/services/task_service.dart';
import 'package:today/constants.dart';
import 'package:today/style/style_constants.dart';
import 'package:today/widgets/sliver_app_bar_widget.dart';

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

    print('parentController: ${widget.parentController.position.pixels}');

    // addPostFrameCallback solves the bug that animateTo was ignored in the following case:
    // 1. scroll up
    // 2. scroll down to reveal the header/calendar while still holding the scrolling finger down on the screen
    // 3. animateTo in this case would be ignored. addPostFrameCallback forces animateTo to work

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // BUG: https://github.com/flutter/flutter/issues/126336
      // widget.parentController.jumpTo(defaultParentHiddenPosition);
      // WORKAROUND: below
      widget.parentController.animateTo(
        defaultParentHiddenPosition,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });
  }

  double _previousOffset = 324;
  double delta = 0;

  @override
  void initState() {
    widget.parentController.addListener(() async {
      double parentPosition = widget.parentController.offset;

      delta = parentPosition - _previousOffset;

      // BUG: scrollbug#2: most probably Flutter's bug
      // 1. scroll down to reveal the calendar
      // 2. hold the finger down while performing step A. and step B.
      // 2A. scroll even more down
      // 2B. scroll fast up like 100-200px
      // 3. This should throw the delta error
      // 4. After which will return the Calendar/header back to reveal it which creates a flicker
      if (delta < -100) {
        log('delta: $delta');
        throw 'delta>100';
      }

      _previousOffset = parentPosition;

      if (parentPosition == 0) {
        lockHeader = false;
      }

      if (lockHeader) {
        await lockParentController();
        lockHeader = false;
      }
    });

    super.initState();
  }

  bool lockHeader = false;

  final pageController = PageController(
    initialPage: todayIndex,
    // viewportFraction: 0.95,
  );

  final widgetManager = getIt<TodayScreenManager>();
  ScrollDirection? _scrollDirection;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: kToolbarHeight + 3),
        child: NotificationListener<UserScrollNotification>(
          onNotification: (notification) {
            _scrollDirection = notification.direction;
            print('_scrollDirection: $_scrollDirection');
            return false;
          },
          child: NotificationListener<ScrollUpdateNotification>(
            onNotification: (notification2) {
              // DEV-MODE: to analyze scrollbug#2
              // if (notification2.metrics.pixels > 0) {
              //   log('child.pixels: ${notification2.metrics.pixels}');
              // } else {
              //   print('child.offset: ${notification2.metrics.pixels}');
              // }
              // if (notification2.metrics.atEdge) {
              //   log('NO: atEdge; parent.offset: ${widget.parentController.offset}');
              // }
              double defaultParentHiddenPosition = widget.parentController.position.maxScrollExtent;
              // additional condition `widget.parentController.offset == defaultParentHiddenPosition` fixes a bug:
              // when the calendar was open/unlocked/not hidden and sometimes when scrolling back up, the app would finish the scroll itself — it would force the animation to hide the calendar instead of the manual scroll.
              // It felt as if a user lost control over the app.
              // The additinoal condition `widget.parentController.offset == defaultParentHiddenPosition` makes sure it detects the movement only when the calendar/header is locked.
              // optimizing defaultParentHiddenPosition / 2 since sometimes it wouldn't detect even when the calendar was locked and had widget.parentController.offset something below the thrashold of defaultParentHiddenPosition
              if (_scrollDirection == ScrollDirection.forward &&
                  notification2.metrics.atEdge &&
                  widget.parentController.offset > defaultParentHiddenPosition / 2) {
                log('---LOCK----: ${widget.parentController.offset}');
                print('child.position: ${notification2.metrics.pixels}; $_scrollDirection');
                print('parent.position: ${widget.parentController.offset}');
                lockHeader = true;
                lockParentController();
              }

              return false;
            },
            // DEV-MODE: alt1
            // child: ListView.builder(
            //   itemBuilder: (_, index) => ListTile(
            //     title: Text("index: ${index}"),
            //   ),
            // ),
            // DEV-MODE: alt2
            child: ValueListenableBuilder<MyList>(
                valueListenable: widgetManager.selectedList,
                builder: (context, selectedList, child) {
                  // return ListView.builder(
                  //   itemBuilder: (_, index) => ListTile(
                  //     title: Text("index: ${index}"),
                  //   ),
                  // );
                  return ListView.builder(
                    padding: EdgeInsets.fromLTRB(0, 52, 0, 40),
                    itemCount: selectedList.items.length,
                    itemBuilder: ((context, index) {
                      // return ListTile(
                      //   title: Text("index: ${index}"),
                      // );

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
          ),
        ),
      ),
    );
  }
}
