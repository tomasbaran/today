import 'dart:math';

import 'package:flutter/material.dart';
import 'package:today/models/my_task.dart';

class TaskCard extends StatelessWidget {
  final String? listTitle;
  final double elevation;
  final MyTask task;
  const TaskCard({
    required this.task,
    super.key,
    this.listTitle,
    this.elevation = 0,
    // required this.position,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        color: task.completed ? Colors.black12 : null,
        height: 68,
        child: Stack(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 36, 12),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                task.title,
                style: TextStyle(
                  fontSize: 16,
                  color: task.completed ? Colors.black54 : null,
                  decoration: task.completed ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              // color: Colors.pink,
              child: Checkbox(
                value: task.completed,
                onChanged: null,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Text(
                listTitle ?? '',
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
