import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:today/constants.dart';
import 'package:today/models/my_list.dart';
import 'package:today/screens/tasks_screen/tasks_screen_manager.dart';
import 'package:today/services/service_locator.dart';
import 'package:today/widgets/task_card.dart';

class TaskListContainer extends StatelessWidget {
  final ScrollController parentController;
  TaskListContainer({required this.parentController});

  final widgetManager = getIt<TodayScreenManager>();

  final pageController = PageController(initialPage: todayIndex, viewportFraction: 0.95);

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
    return Scaffold(
      body: Padding(
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
              if (scrollDirection == ScrollDirection.forward && notification2.metrics.atEdge && parentController.offset > parentHiddenPosition / 2) {
                hideCalendar();
              }
              return false;
            },
            child: PageView.builder(
              onPageChanged: (newPage) => widgetManager.changePage(pageController.page, newPage),
              controller: pageController,
              itemBuilder: (context, index) {
                return ValueListenableBuilder<MyList>(
                    valueListenable: widgetManager.selectedList,
                    builder: (context, selectedList, child) {
                      return ListView.builder(
                        padding: const EdgeInsets.fromLTRB(0, 52, 0, 40),
                        itemCount: selectedList.items.length,
                        itemBuilder: ((context, index) {
                          return TaskCard(
                            key: Key(selectedList.items[index].dateIndex.toString()),
                            title: selectedList.items[index].title,
                            completed: selectedList.items[index].completed ?? false,
                            listTitle: selectedList.items[index].listId ?? 'null listId',
                          );
                        }),
                      );
                    });
              },
            ),
          ),
        ),
      ),
    );
  }
}
