import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:today/widgets/sliver_app_bar_widget.dart';
import 'package:today/services/service_locator.dart';
import 'package:today/style/style_constants.dart';
import 'package:today/widgets/sliver_app_bar_widget.dart';
import 'my_globals.dart';

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
    PageStorageKey? pageKeyParent;
    pageKeyParent = PageStorageKey('parent');
    return Scaffold(
      body: NestedScrollView(
        controller: parentScrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverOverlapAbsorber(
              key: pageKeyParent,
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
  ScrollPhysics? _scrollPhysics;

  bool isScrollEnabled = true;

  PageStorageKey? pageKeyChild;

  @override
  void initState() {
    super.initState();

    pageKeyChild = PageStorageKey('child');
    _scrollPhysics = AlwaysScrollableScrollPhysics();
    log('scrollPhysics: ${_scrollPhysics!.allowImplicitScrolling}');

    widget.parentController.addListener(() {
      double parentPosition = widget.parentController.offset;
      double defaultHiddenParentPosition = widget.parentController.position.maxScrollExtent;
      log('parentPosition: $parentPosition');
    });

    childController.addListener(() async {
      log('pageStorageChildKey: ${pageKeyChild!.value}');
      double defaultHiddenParentPosition = widget.parentController.position.maxScrollExtent;
      // double parentPosition = widget.parentController.offset;
      // _scrollPhysics!.allowImplicitScrolling = false;

      double childPosition = childController.offset;

      if (childPosition < 0) {
        setState(() {
          print('-------------------------');
          isScrollEnabled = false;
          // _scrollPhysics = NeverScrollableScrollPhysics();
        });

        widget.parentController.jumpTo(defaultHiddenParentPosition + childPosition);
        // childController.position.setPixels(0);
        print('childPosition: $childPosition');

        // childController.position.setPixels(childPosition);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: kToolbarHeight + 3),
      child: Stack(
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemBuilder: (_, index) => ListTile(
              title: Text("index: $index"),
            ),
          ),
          if (!isScrollEnabled)
            Container(
              color: Colors.black,
            ),
        ],
      ),
      // child: ListView.builder(
      //   physics: _scrollPhysics,
      //   // key: myGlobals.scaffoldKey,
      //   key: pageKeyChild,
      //   controller: childController,
      //   itemBuilder: (b, i) {
      //     return Container(
      //       height: 50,
      //       color: Colors.green,
      //       margin: EdgeInsets.only(bottom: 3),
      //       child: Text(
      //         i.toString(),
      //       ),
      //     );
      //   },
      //   itemCount: 30,
      // ),
    );
  }
}

class MySampleWidget extends StatefulWidget {
  @override
  State<MySampleWidget> createState() => _MySampleWidgetState();
}

class _MySampleWidgetState extends State<MySampleWidget> {
  bool scrollEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  scrollEnabled = !scrollEnabled;
                });
              },
              child: Text("Update"),
            ),
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemBuilder: (_, index) => ListTile(
                  title: Text("index: $index"),
                ),
              ),
              if (!scrollEnabled)
                Container(
                  color: Colors.transparent,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
