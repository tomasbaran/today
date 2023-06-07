import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:today/models/my_list.dart';
import 'package:today/screens/tasks_screen/tasks_screen_manager.dart';
import 'package:today/services/service_locator.dart';
import 'package:today/style/style_constants.dart';
import 'package:today/widgets/floating_container.dart';
import 'package:today/widgets/completed_tasks_column.dart';
import 'package:today/widgets/task_card.dart';

import '../globals/constants.dart';

class TasksContainer extends StatelessWidget {
  final ScrollController parentController;
  TasksContainer({
    Key? key,
    required this.parentController,
  }) : super(key: key);

  final widgetManager = getIt<TasksScreenManager>();

  hideCalendar() {
    double defaultParentHiddenPosition = parentController.position.maxScrollExtent;
    // addPostFrameCallback solves the bug that animateTo was ignored in the following case:
    // 1. scroll up
    // 2. scroll down to reveal the header/calendar while still holding the scrolling finger down on the screen
    // 3. animateTo in this case would be ignored. addPostFrameCallback forces animateTo to work
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // BUG: https://github.com/flutter/flutter/issues/126336
      // widget.parentController.jumpTo(defaultParentHiddenPosition);
      // WORKAROUND: below
      parentController.animateTo(
        defaultParentHiddenPosition,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });
  }

  // BUG: scrollbug#2: most probably Flutter's bug. Possibly related to: https://github.com/flutter/flutter/issues/125006
  // 1. scroll down to reveal the calendar
  // 2. hold the finger down while performing step A. and step B.
  // 2A. scroll even more down
  // 2B. scroll fast up like 100-200px
  // 3. This should throw the delta error
  // 4. After which will return the Calendar/header back to reveal it which creates a flicker

  // related to scrollbug#2
  // double _previousOffset = 324;
  // double delta = 0;

  // @override
  // void initState() {
  // widget.parentController.addListener(() async {
  // double parentPosition = widget.parentController.offset;
  // delta = parentPosition - _previousOffset;
  // if (delta < -100) {
  //   log('delta: $delta');
  //   throw 'delta>100';
  // }
  // _previousOffset = parentPosition;
  // });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    ScrollDirection? scrollDirection;
    final pageController = widgetManager.pageController;
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            minimum: const EdgeInsets.only(bottom: 68 + 28 + 4),
            child: Padding(
              padding: const EdgeInsets.only(top: kToolbarHeight + 3),
              child: NotificationListener<UserScrollNotification>(
                onNotification: (notification) {
                  scrollDirection = notification.direction;
                  return false;
                },
                child: NotificationListener<ScrollUpdateNotification>(
                  onNotification: (notification2) {
                    double parentHiddenPosition = parentController.position.maxScrollExtent;
                    // additional condition `parentController.offset == parentHiddenPosition` fixes a bug:
                    // when the calendar was open/unlocked/not hidden and sometimes when scrolling back up, the app would finish the scroll itself — it would force the animation to hide the calendar instead of the manual scroll.
                    // It felt as if a user lost control over the app.
                    // The additinoal condition `parentController.offset == parentHiddenPosition` makes sure it detects the movement only when the calendar/header is locked.
                    // optimizing defaultParentHiddenPosition / 2 since sometimes it wouldn't detect even when the calendar was locked and had widget.parentController.offset something below the thrashold of defaultParentHiddenPosition
                    if (scrollDirection == ScrollDirection.forward &&
                        notification2.metrics.atEdge &&
                        parentController.offset > parentHiddenPosition / 2) {
                      hideCalendar();
                    }
                    return false;
                  },
                  child: PageView.builder(
                    onPageChanged: (newPage) => widgetManager.changePage(pageController.page ?? todayIndex.toDouble(), newPage),
                    controller: pageController,
                    itemBuilder: (____, pageIndex) {
                      return ValueListenableBuilder<MyList>(
                          valueListenable: widgetManager.selectedList,
                          builder: (_, pageList, __) {
                            int tasksCount = pageList.tasks.length;
                            int listWidgetsCount = tasksCount + 1; // +1 is the new last item: Column of FillInHeight + COMPLETED:
                            double fillInHeight = widgetManager.countFillInHeight(
                              MediaQuery.of(context).size.height,
                              MediaQuery.of(context).padding.bottom,
                            );

                            return ReorderableListView.builder(
                                itemCount: listWidgetsCount, // +1 is the new last item: Column of FillInHeight + COMPLETED:
                                itemBuilder: ((___, taskIndex) {
                                  // reversedIndex is to show the newest task on top of the list
                                  int reversedIndex = tasksCount - 1 - taskIndex;
                                  // Add CompletedTasksColumn as the last item in the ListView
                                  if (taskIndex == tasksCount) {
                                    return CompletedTasksColumn(
                                      key: const Key('last'),
                                      fillInHeight: fillInHeight,
                                    );
                                  } else {
                                    return TaskCard(
                                      key: Key(reversedIndex.toString()),
                                      task: pageList.tasks[reversedIndex],
                                    );
                                  }
                                }),
                                // possible bugfix of scrollbug#2 by utilizing the below scrollController instead of using PageView's NotificationListener
                                // scrollController: ,
                                proxyDecorator: (_, taskIndex, animation) {
                                  print('taskIndex: $taskIndex; lastIndex: $tasksCount');
                                  // Don't animate lastIndex
                                  if (taskIndex == tasksCount) {
                                    // print('taskIndex: not animating the lastIndex');
                                    return const SizedBox();
                                  } else {
                                    // reversedIndex is to show the newest task on top of the list
                                    int reversedIndex = tasksCount - 1 - taskIndex;
                                    return AnimatedBuilder(
                                      animation: animation,
                                      builder: (_, __) {
                                        final double animValue = Curves.easeOut.transform(animation.value);
                                        final double elevation = lerpDouble(1, 6, animValue)!;
                                        final scale = lerpDouble(1, 1.02, animValue)!;
                                        return Transform.scale(
                                          scale: scale,
                                          child: TaskCard(
                                            elevation: elevation,
                                            task: pageList.tasks[reversedIndex],
                                          ),
                                        );
                                      },
                                      // child: child,
                                    );
                                  }
                                },
                                onReorder: (oldIndex, newIndex) {
                                  print('oldIndex: $oldIndex; lastIndex: $listWidgetsCount');
                                  // order any item except for the last one
                                  if (oldIndex != tasksCount) {
                                    int reversedOldIndex = tasksCount - 1 - oldIndex;
                                    // if you move a TaskCard to the last place put it as the penultimate (instead of the last one): since the last one (COMPLETED) is unmovable
                                    int reversedNewIndex = newIndex == listWidgetsCount ? tasksCount - newIndex : tasksCount - 1 - newIndex;
                                    widgetManager.reorderList(reversedOldIndex, reversedNewIndex);
                                  }
                                });
                          });
                    },
                  ),
                ),
              ),
            ),
          ),
          FloatingContainer(),
        ],
      ),
    );
  }
}
