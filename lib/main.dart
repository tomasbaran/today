import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:today/widgets/sliver_app_bar_widget.dart';
import 'package:today/services/service_locator.dart';
import 'package:today/style/style_constants.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupGetIt();
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  var parentScrollController = ScrollController(initialScrollOffset: expandedAppBarHeight - kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        body: DemoTab(parentController: parentScrollController),
      ),
    );
  }
}

class DemoTab extends StatefulWidget {
  ScrollController parentController;
  DemoTab({required this.parentController});

  @override
  State<DemoTab> createState() => _DemoTabState();
}

class _DemoTabState extends State<DemoTab> {
  lockParentController() {
    double defaultParentHiddenPosition = widget.parentController.position.maxScrollExtent;

    // print('activity: ${widget.parentController.position.activity!.isScrolling}');
    // -BUG: https://github.com/flutter/flutter/issues/126336
    // widget.parentController.jumpTo(defaultParentHiddenPosition);
    // -WORKAROUND: below
    widget.parentController.animateTo(
      defaultParentHiddenPosition,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeIn,
    );
  }

  @override
  void initState() {
    widget.parentController.addListener(() async {
      double parentPosition = widget.parentController.offset;

      if (parentPosition == 0) {
        lockHeader = false;
      }

      if (lockHeader) {
        lockParentController();
        lockHeader = false;
      }
    });

    super.initState();
  }

  bool lockHeader = false;
  bool? isScrollingUp;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: kToolbarHeight + 3),
        child: NotificationListener<ScrollUpdateNotification>(
          onNotification: (notification) {
            // print('activity: ${notification.dragDetails.}');
            if (notification is ScrollEndNotification) {
              print('end');
            }
            if (notification.dragDetails != null) {
              if (notification.dragDetails!.primaryDelta != null) {
                if (notification.dragDetails!.primaryDelta! > 0) {
                  print('direction: up');
                  isScrollingUp = true;
                } else {
                  print('direction: down');
                  isScrollingUp = false;
                }
              }
            }

            if (isScrollingUp != null) {
              if (isScrollingUp! && notification.metrics.atEdge) {
                if (lockHeader) {
                  lockParentController();
                }
                lockHeader = true;
              }
            }

            return false;
          },
          child: ListView.builder(
            // shrinkWrap: true,
            // controller: ScrollController(),
            itemBuilder: (_, index) => ListTile(
              title: Text("index: ${index}"),
            ),
          ),
        ),
      ),
    );
  }
}
