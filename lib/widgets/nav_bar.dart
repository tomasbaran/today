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
            // Icons.blur_circular,
            // Icons.radio_button_on_rounded,
            // Icons.view_timeline_outlined,
            // Icons.format_list_bulleted,
            // CupertinoIcons.line_horizontal_3_decrease,
            // Icons.center_focus_strong_outlined,
            // Icons.picture_in_picture,
            Icons.public_sharp,
            // Icons.spa_outlined,
            // Icons.push_pin_outlined,
            // Icons.notes_rounded,
            // CupertinoIcons.doc_plaintext,
            // Icons.note_outlined,
            // Icons.fullscreen_rounded,
            // Icons.wb_sunny_outlined,
            // CupertinoIcons.house,
            size: 28,
            color: kIconColor,
          ),
        ),
        GestureDetector(
          onTap: () => null,
          child: Icon(
            // CupertinoIcons.calendar,
            Icons.calendar_month_outlined,
            color: kIconColor,
            size: 28,
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
          onTap: () => widgetManager.updateNavBarSelection(NavBarSelection.list),
          // child: Text(
          //   '&',
          //   style: bottomToolbarIconTextStyle,
          // ),
          child: Icon(
            // Icons.flash_auto,
            CupertinoIcons.line_horizontal_3_decrease,
            // Icons.notes_rounded,
            color: kIconColor,
            size: 28,
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
