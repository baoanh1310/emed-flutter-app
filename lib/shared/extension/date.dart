import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

extension DateTimeExtension on DateTime {
  String formatDate({String format = 'dd/MM/yyyy', String locale = 'vi'}) {
    initializeDateFormatting(locale);
    return DateFormat(format, locale).format(this);
  }

  String toFirestoreCollectionNameFormat() {
    return DateFormat('dd_MM_yyyy').format(this);
  }

  bool isBetween(DateTime start, DateTime end) {
    final thisDay = DateTime(year, month, day);
    final startDate = DateTime(start.year, start.month, start.day);
    final endDate = DateTime(end.year, end.month, end.day);
    return thisDay.millisecondsSinceEpoch >= startDate.millisecondsSinceEpoch &&
        thisDay.millisecondsSinceEpoch <= endDate.millisecondsSinceEpoch;
  }

  int dayDifference(DateTime other) {
    final startDate = DateTime(year, month, day);
    final endDate = DateTime(other.year, other.month, other.day);

    return startDate.difference(endDate).inDays.abs() + 1;
  }

  bool isDayInFuture() {
    final now = DateTime.now();
    final consideredDay = DateTime(year, month, day);
    final currentDay = DateTime(now.year, now.month, now.day);
    return consideredDay.isAfter(currentDay);
  }

  bool isToday() {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }
}
