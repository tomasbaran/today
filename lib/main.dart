import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  var parentScrollController = ScrollController(initialScrollOffset: expandedAppBarHeight - collapsedAppBarHeight);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        controller: parentScrollController,
        physics: ScrollPhysics(parent: PageScrollPhysics()),
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
  @override
  void initState() {
    super.initState();

    childController.addListener(() {
      var childPosition = childController.offset;
      var maxParentScroll = widget.parentController.position.maxScrollExtent;
      var parentPosition = widget.parentController.position.pixels;

      if (childPosition >= 0 && parentPosition < maxParentScroll) {
        widget.parentController.position.jumpTo(childPosition + parentPosition);
      } else {
        var currenParentPos = childPosition + parentPosition;
        widget.parentController.position.jumpTo(currenParentPos);
      }
    });

    widget.parentController.addListener(() {
      var currentOutPos = widget.parentController.position.pixels;
      if (currentOutPos <= 0) {
        childController.position.jumpTo(0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 115 - 56),
      child: ListView.builder(
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
