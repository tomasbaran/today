import 'package:flutter/material.dart';
import 'package:today/widgets/collapsed_app_bar.dart';
import 'package:today/widgets/expanded_app_bar.dart';
import 'dart:math' as math;

class SliverAppBarWidget extends StatelessWidget {
  const SliverAppBarWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, boxConstraints) {
        double opacity = 0;
        final settings = context.dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
        if (settings != null) {
          final deltaExtent = settings.maxExtent - settings.minExtent;
          final t = (1.0 - (settings.currentExtent - settings.minExtent) / deltaExtent).clamp(0.0, 1.0) as double;
          final fadeStart = math.max(0.0, 1.0 - kToolbarHeight / deltaExtent);
          const fadeEnd = 1.0;
          opacity = 1.0 - Interval(fadeStart, fadeEnd).transform(t);
        }
        // print('settings.currentExtent: ${settings!.currentExtent}');

        return Stack(
          children: [
            Opacity(
              opacity: (1 - opacity * 5) <= 0 ? 0 : (1 - opacity * 5),
              child: CollapsedAppBar(),
            ),
            Opacity(
              opacity: opacity,
              child: ExpandedAppBar(),
            ),
          ],
        );
      },
    );
  }
}
