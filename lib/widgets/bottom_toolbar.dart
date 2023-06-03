import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:today/screens/tasks_screen/tasks_screen_manager.dart';
import 'package:today/services/service_locator.dart';
import 'package:today/style/style_constants.dart';
import 'package:today/widgets/add_new_task_sheet.dart';

class BottomToolbar extends StatelessWidget {
  BottomToolbar({
    super.key,
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
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    widgetManager.updateSelectedDate(DateTime.now());
                  },
                  child: const Icon(
                    CupertinoIcons.today_fill,
                    size: 30,
                    color: kThemeColor7,
                  ),
                ),
                const Icon(
                  CupertinoIcons.calendar,
                  color: kThemeColor7,
                  size: 30,
                ),
                // Hamburger icon
                // GestureDetector(
                //   onTap: () {
                //     widgetManager.updateSelectedDate(DateTime.now());
                //   },
                //   child: Icon(
                //     CupertinoIcons.line_horizontal_3_decrease,
                //     size: 30,
                //     color: kThemeColor7,
                //   ),
                //   // child: Text(
                //   //   'Today',
                //   //   style: actionBarLinkTextStyle,
                //   // ),
                // ),
                GestureDetector(
                  onTap: () => showCupertinoModalBottomSheet(
                    context: context,
                    builder: (context) => const Scaffold(
                      body: AddNewTaskSheet(),
                    ),
                  ),
                  child: Container(
                    height: 24,
                    width: 24,
                    decoration: const BoxDecoration(
                      color: kThemeColor7,
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.add_rounded,
                        size: 24,
                        color: Colors.white,
                      ),
                    ),
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
