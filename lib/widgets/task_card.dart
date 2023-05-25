import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:today/models/my_task.dart';
import 'package:today/style/style_constants.dart';
import 'package:intl/intl.dart';

class TaskCard extends StatelessWidget {
  final double elevation;
  final MyTask task;
  const TaskCard({
    required this.task,
    super.key,
    this.elevation = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(cardRadius)),
      child: Row(
        children: [
          TimeCard(
            startTime: task.startTime,
            finishTime: task.finishTime,
            date: task.date,
          ),
          Expanded(
            child: Container(
              color: task.completed ? Colors.black12 : null,
              height: 68,
              child: Stack(children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(cardRadius, cardRadius, 36, cardRadius),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      task.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: task.completed ? Colors.black54 : null,
                        decoration: task.completed ? TextDecoration.lineThrough : null,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Checkbox(
                    value: task.completed,
                    onChanged: null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(cardRadius),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    // This is where the listTitle will go.
                    // E.g. #Family, #Health, #Project
                    // child: Text(
                    //   task.listTitle ?? '',
                    // ),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class TimeCard extends StatelessWidget {
  final DateTime? startTime;
  final DateTime? finishTime;
  final DateTime? date;
  const TimeCard({
    super.key,
    this.date,
    this.finishTime,
    this.startTime,
  });

  @override
  Widget build(BuildContext context) {
    log('startTime: $startTime');
    String startTimeString = startTime == null ? '' : '${startTime!.hour}:${startTime!.minute.toString().padLeft(2, '0')}';
    String finishTimeString = finishTime == null ? '' : '${finishTime!.hour}:${finishTime!.minute.toString().padLeft(2, '0')}';
    String dateString = date == null ? '' : '${date!.day} ${DateFormat('MMM').format(date!)}';

    return Visibility(
      visible: startTime != null,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.horizontal(left: Radius.circular(cardRadius)),
          color: kDefaultHighlightColor,
        ),
        height: 68,
        width: 68,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(startTimeString, style: timeCardTextStyle),
              Text(dateString, style: timeCardTextStyle.copyWith(fontWeight: FontWeight.w800)),
              Text(finishTimeString, style: timeCardTextStyle),
            ],
          ),
        ),
      ),
    );
  }
}
