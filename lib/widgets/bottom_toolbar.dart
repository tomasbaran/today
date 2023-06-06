import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:today/globals/constants.dart';
import 'package:today/screens/tasks_screen/tasks_screen_manager.dart';
import 'package:today/services/service_locator.dart';
import 'package:today/style/style_constants.dart';
import 'package:today/widgets/add_new_task_sheet.dart';

class BottomToolbar extends StatelessWidget {
  final PageController pageController;
  final ScrollController calendarScrollController;
  BottomToolbar({
    super.key,
    required this.pageController,
    required this.calendarScrollController,
  });

  final widgetManager = getIt<TasksScreenManager>();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 50,
            decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: kThemeColor2, width: 1))),
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                    color: kThemeColor7,
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
                    color: kThemeColor7,
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
                    height: 40,
                    width: 60,
                    decoration: BoxDecoration(
                      color: kThemeColor12,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.add_rounded,
                        size: 28,
                        color: Colors.white,
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
                    '@',
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
          Container(
            color: Colors.white,
            width: double.infinity,
            height: MediaQuery.of(context).padding.bottom,
            // height: 30,
          ),
        ],
      ),
    );
  }
}
