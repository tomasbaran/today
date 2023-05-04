import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:today/widgets/sliver_app_bar_widget.dart';
import 'package:today/services/service_locator.dart';
import 'package:today/style/style_constants.dart';
import 'package:today/widgets/sliver_app_bar_widget.dart';

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
                // flexibleSpace: Container(height: 300, color: Colors.pink),
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
  DemoTab({required this.parentController});

  final ScrollController parentController;

  DemoTabState createState() => DemoTabState();
}

class DemoTabState extends State<DemoTab> {
  ScrollController childController = ScrollController();

  ScrollPhysics? physics;

  bool revealCalendar = false;

  @override
  void initState() {
    super.initState();

    widget.parentController.addListener(() {
      double parentPosition = widget.parentController.offset;
      print('parentPosition: $parentPosition');
      // if (isCalendarRevealed) {
      //   setState(() {
      //     log('setState: false;');
      //     isCalendarRevealed = false;
      //   });
      // }

      print('scrollDirection: ${widget.parentController.position.userScrollDirection}');

      if (widget.parentController.position.userScrollDirection == ScrollDirection.reverse && parentPosition == 324) {
        setState(() {
          log('revealCalendar: false;');
          revealCalendar = false;
        });
      }
    });

    childController.addListener(() {
      // double maxParentScroll = widget.parentController.position.maxScrollExtent;
      // double parentPosition = widget.parentController.offset;

      double childPosition = childController.offset;
      log('childPosition: $childPosition');
      if (childPosition <= 0) {
        if (!revealCalendar) {
          setState(() {
            log('revealCalendar: true;');
            revealCalendar = true;
          });
        }
      }

      // if (childController.position. .userScrollDirection == ScrollDirection.reverse) {
      //   log('forward');
      //   if (revealingCalendar) {
      //     setState(() {
      //       revealingCalendar = false;
      //     });
      //   }
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: kToolbarHeight + 3),
      child: ListView.builder(
        physics: revealCalendar ? NeverScrollableScrollPhysics() : BouncingScrollPhysics(),
        key: UniqueKey(),
        controller: childController,
        itemBuilder: (b, i) {
          return Container(
            height: 50,
            color: Colors.green,
            margin: EdgeInsets.only(bottom: 3),
            child: Text(
              i.toString(),
            ),
          );
        },
        itemCount: 30,
      ),
    );
  }
}
