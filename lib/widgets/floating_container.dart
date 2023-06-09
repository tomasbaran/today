import 'package:flutter/material.dart';
import 'package:today/screens/tasks_screen/tasks_screen_manager.dart';
import 'package:today/services/service_locator.dart';
import 'package:today/style/style_constants.dart';
import 'package:today/widgets/calendar_view.dart';
import 'package:today/widgets/nav_bar.dart';
import 'package:today/widgets/floating_list_view.dart';

class FloatingContainer extends StatelessWidget {
  FloatingContainer({
    super.key,
  });

  final widgetManager = getIt<TasksScreenManager>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widgetManager.updateNavBarSelection(NavBarSelection.unselected),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(floatingBarRadius)),
        elevation: 10,
        child: Container(
          // height: 400,
          width: floatingContainerWidth,
          decoration: BoxDecoration(
            color: kThemeColor11,
            borderRadius: BorderRadius.all(Radius.circular(floatingBarRadius)),
          ),
          child: ValueListenableBuilder(
            valueListenable: widgetManager.navBar,
            builder: (context, navBarSelection, child) {
              switch (navBarSelection) {
                case NavBarSelection.list:
                  return FloatingListView();
                case NavBarSelection.calendar:
                  return CalendarView();
                default:
                  return NavBar();
              }
            },
          ),
        ),
      ),
    );
  }
}
