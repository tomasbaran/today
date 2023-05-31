class DateTimeService {
  String formatTime(DateTime dateTime) => '${dateTime.hour} : ${formatMinutes(dateTime)}';
  String formatMinutes(DateTime dateTime) => dateTime.minute.toString().padLeft(2, '0');
}
