import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  static String formatFullDate(DateTime dateTime) {
    return DateFormat('EEEE, d MMMM yyyy').format(dateTime);
  }

  static String formatTime(DateTime dateTime) {
    return DateFormat('h:mm a').format(dateTime);
  }

  static String formatShortDay(DateTime dateTime) {
    return DateFormat('EEE').format(dateTime);
  }

  static String formatDayAndDate(DateTime dateTime) {
    return DateFormat('EEE, MMM d').format(dateTime);
  }

  static String formatHourly(DateTime dateTime) {
    return DateFormat('ha').format(dateTime).toLowerCase();
  }

  static String formatSunTime(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000, isUtc: true).toLocal();
    return DateFormat('h:mm a').format(date);
  }
}
