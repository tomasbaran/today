import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:today/style/style_constants.dart';

class ExpandedAppBar extends StatelessWidget {
  const ExpandedAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Padding(
        padding: EdgeInsets.only(left: 28, right: 28, top: 36, bottom: 28),
        child: Wrap(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: DateTime.now(),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: TextStyle(color: const Color(0xFF4F4F4F), fontWeight: FontWeight.w700),
                weekendStyle: TextStyle(color: const Color(0xFF6A6A6A), fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
