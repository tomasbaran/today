import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:today/globals/constants.dart';
import 'package:today/screens/tasks_screen/tasks_screen_manager.dart';
import 'package:today/services/service_locator.dart';
import 'package:today/style/style_constants.dart';
import 'package:today/widgets/add_new_task_sheet.dart';

class FloatingBar extends StatelessWidget {
  final PageController pageController;
  final ScrollController calendarScrollController;
  FloatingBar({
    super.key,
    required this.pageController,
    required this.calendarScrollController,
  });

  final widgetManager = getIt<TasksScreenManager>();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Material(
              borderRadius: BorderRadius.all(Radius.circular(60)),
              elevation: 10,
              child: Container(
                height: 68,
                width: 340,
                // decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: kThemeColor2, width: 1))),
                decoration: BoxDecoration(
                  color: kThemeColor12,
                  borderRadius: BorderRadius.all(Radius.circular(60)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        pageController.animateToPage(todayIndex, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                      },
                      child: Icon(
                        CupertinoIcons.today_fill,
                        // Icons.today,
                        size: 26,
                        color: kIconColor,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => calendarScrollController.animateTo(
                        // if the calendar is hidden (calendarScrollController.position.maxScrollExtent) -> reveal it (0); if not, hide it (calendarScrollController.position.maxScrollExtent)
                        calendarScrollController.offset == calendarScrollController.position.maxScrollExtent
                            ? 0
                            : calendarScrollController.position.maxScrollExtent,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeIn,
                      ),
                      child: Icon(
                        CupertinoIcons.calendar,
                        // Icons.calendar_month_rounded,
                        color: kIconColor,
                        size: 26,
                      ),
                    ),
                    // Icon(
                    //   CupertinoIcons.calendar,
                    //   color: kThemeColor7,
                    //   size: 30,
                    // ),
                    GestureDetector(
                      onTap: () => showCupertinoModalBottomSheet(
                        context: context,
                        builder: (context) => const Scaffold(
                          body: AddNewTaskSheet(),
                        ),
                      ),
                      child: Container(
                        height: 32,
                        width: 32,
                        decoration: BoxDecoration(
                          color: kIconColor,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.add_rounded,
                            size: 24,
                            color: kThemeColor12,
                          ),
                        ),
                      ),
                    ),

                    // Hamburger icon
                    GestureDetector(
                      onTap: () {
                        widgetManager.updateSelectedDate(DateTime.now());
                      },
                      // child: Icon(
                      //   CupertinoIcons.line_horizontal_3_decrease,
                      //   size: 26,
                      //   color: kThemeColor7,
                      // ),
                      child: Text(
                        '&',
                        style: bottomToolbarIconTextStyle,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        widgetManager.updateSelectedDate(DateTime.now());
                      },
                      // child: Icon(
                      //   CupertinoIcons.line_horizontal_3_decrease,
                      //   size: 26,
                      //   color: kThemeColor7,
                      // ),
                      child: Text(
                        '#',
                        style: bottomToolbarIconTextStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
