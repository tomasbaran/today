import 'package:flutter/cupertino.dart';

class DateTimeService {
  String formatTime(DateTime dateTime) => '${dateTime.hour} : ${formatMinutes(dateTime)}';
  String formatMinutes(DateTime dateTime) => dateTime.minute.toString().padLeft(2, '0');

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
