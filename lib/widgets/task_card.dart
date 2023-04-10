import 'dart:math';

import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final String position;
  final bool completed;
  final String listTitle;
  const TaskCard({
    super.key,
    required this.title,
    required this.completed,
    required this.listTitle,
    required this.position,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      key: Key(position),
      child: Container(
        color: completed ? Colors.black12 : null,
        height: 68,
        child: Stack(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 36, 12),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: completed ? Colors.black54 : null,
                  decoration: completed ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              // color: Colors.pink,
              child: Checkbox(
                value: completed,
                onChanged: null,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Text(
                listTitle,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
