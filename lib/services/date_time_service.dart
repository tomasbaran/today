import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

enum MyDate {
  isToday,
  isTomorrow,
  isYesterday,
  isAnotherDay,
}

class DateTimeService {
  String formatTime(DateTime dateTime) => '${dateTime.hour} : ${formatMinutes(dateTime)}';
  String formatMinutes(DateTime dateTime) => dateTime.minute.toString().padLeft(2, '0');

  MyDate isSpecialDay(DateTime dateTime) {
    DateTime now = DateTime.now();
    const Duration oneDay = Duration(hours: 24);
    if (dateTime.day == now.day && dateTime.month == now.month && dateTime.year == now.year) {
      return MyDate.isToday;
    } else if (dateTime.day == now.add(oneDay).day && dateTime.month == now.add(oneDay).month && dateTime.year == now.add(oneDay).year) {
      return MyDate.isTomorrow;
    } else if (dateTime.day == now.subtract(oneDay).day &&
        dateTime.month == now.subtract(oneDay).month &&
        dateTime.year == now.subtract(oneDay).year) {
      return MyDate.isYesterday;
    } else {
      return MyDate.isAnotherDay;
    }
  }

  String niceDateTimeString(DateTime dateTime) {
    switch (isSpecialDay(dateTime)) {
      case MyDate.isToday:
        return 'Today';
      case MyDate.isYesterday:
        return 'Yesterday';
      case MyDate.isTomorrow:
        return 'Tomorrow';
      default:
        return DateFormat('EEEE').format(dateTime);
    }
  }

  DateTime resetTimeToZero(DateTime dateTime) => dateTime.subtract(Duration(
        hours: dateTime.hour,
        minutes: dateTime.minute,
        seconds: dateTime.second,
        microseconds: dateTime.microsecond,
        milliseconds: dateTime.millisecond,
      ));

  DateTime? mixDateAndTime(DateTime useDate, DateTime? useTime) {
    // Reset hours,minutes,seconds to 00:00:00
    DateTime resetTime = resetTimeToZero(useDate);
    if (useTime == null) {
      return null;
    } else {
      return resetTime.add(Duration(hours: useTime.hour, minutes: useTime.minute));
    }
  }

// This function displays a CupertinoModalPopup with a reasonable fixed height
// which hosts CupertinoDatePicker.
  void showCupertinoTimePicker({required BuildContext context, required Function(DateTime) onDateTimeChanged}) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        // The Bottom margin is provided to align the popup above the system
        // navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(
          top: false,
          child: CupertinoDatePicker(
            minuteInterval: 5,
            // .subtract(Duration(minutes: DateTime.now().minute % 5)) is bugfixing cases when DateTime.now() is not divisible by 5
            initialDateTime: DateTime.now().subtract(Duration(minutes: DateTime.now().minute % 5)),
            mode: CupertinoDatePickerMode.time,
            use24hFormat: true,
            onDateTimeChanged: (DateTime newTime) => onDateTimeChanged(newTime),
          ),
        ),
      ),
    );
  }
}
