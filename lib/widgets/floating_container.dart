import 'package:flutter/material.dart';
import 'package:today/style/style_constants.dart';
import 'package:today/widgets/nav_bar.dart';
import 'package:today/widgets/revealed_floating_container.dart';

class FloatingContainer extends StatelessWidget {
  FloatingContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
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
          child: NavBar(),
          // child: RevealedFloatingContainer(),
        ),
      ),
    );
  }
}
