import 'package:flutter/material.dart';
import 'package:today/screens/tasks_screen/tasks_screen_manager.dart';
import 'package:today/services/service_locator.dart';
import 'package:today/style/style_constants.dart';
import 'package:today/widgets/nav_bar.dart';
import 'package:today/widgets/floating_list_container.dart';

class FloatingContainer extends StatelessWidget {
  FloatingContainer({
    super.key,
  });

  final widgetManager = getIt<TasksScreenManager>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widgetManager.updateNavBarSelection(NavBarSelection.unselected),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Material(
          borderRadius: BorderRadius.all(Radius.circular(60)),
          elevation: 10,
          child: Container(
            width: floatingContainerWidth,
            decoration: BoxDecoration(
              color: kThemeColor12,
              borderRadius: BorderRadius.all(Radius.circular(31)),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ValueListenableBuilder(
              valueListenable: widgetManager.navBar,
              builder: (context, navBarSelection, child) {
                switch (navBarSelection) {
                  case NavBarSelection.list:
                    return FloatingListContainer();
                  default:
                    return NavBar();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
