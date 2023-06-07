import 'package:flutter/material.dart';
import 'package:today/widgets/nav_bar.dart';

class FloatingContainer extends StatelessWidget {
  FloatingContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 28),
        child: Material(
          borderRadius: BorderRadius.all(Radius.circular(60)),
          elevation: 10,
          child: NavBar(),
        ),
      ),
    );
  }
}
