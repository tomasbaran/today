import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:today/globals/constants.dart';
import 'package:today/screens/tasks_screen/tasks_screen_manager.dart';
import 'package:today/services/service_locator.dart';
import 'package:today/style/style_constants.dart';
import 'package:today/widgets/add_new_task_sheet.dart';

class NavBar extends StatelessWidget {
  NavBar({
    super.key,
  });

  final widgetManager = getIt<TasksScreenManager>();

  @override
  Widget build(BuildContext context) {
    final pageController = widgetManager.pageController;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => pageController.animateToPage(todayIndex, duration: Duration(milliseconds: 300), curve: Curves.easeIn),
          child: Icon(
            CupertinoIcons.today_fill,
            // Icons.today,
            size: 26,
            color: kIconColor,
          ),
        ),
        GestureDetector(
          onTap: () => null,
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
          onTap: () => null,
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
          onTap: () => widgetManager.updateNavBarSelection(NavBarSelection.list),
          child: Text(
            '#',
            style: bottomToolbarIconTextStyle,
          ),
        ),
      ],
    );
  }
}
