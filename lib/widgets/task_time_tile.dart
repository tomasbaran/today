import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:today/style/style_constants.dart';

class TaskTimeTile extends StatelessWidget {
  const TaskTimeTile({
    super.key,
    required this.title,
    required this.icon,
    required this.value,
  });
  final String title;
  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return CupertinoListTile.notched(
      leadingToTitle: cupertinoListTileLeadingToTitle,
      leadingSize: cupertinoListTileLeadingSize,
      leading: Align(
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(
              width: 8,
            ),
            Text(
              title,
              style: addNewTaskSheetFieldTitleTextStyle,
            ),
          ],
        ),
      ),
      title: Text(
        value,
        style: addNewTaskSheetFieldHintTitleTextStyle.copyWith(color: title == 'Date' ? Colors.black : null),
      ),
    );
  }
}
