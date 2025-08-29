import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';

String getHijriDateFormatted() {
  // Set locale to Arabic for month names
  HijriCalendar.setLocal("ar");

  // Get today's Hijri date
  final today = HijriCalendar.now();

  // Format numbers into Arabic numerals
  final day = NumberFormat('##', 'ar').format(today.hDay);
  final year = NumberFormat('####', 'ar').format(today.hYear);
  final month = today.getLongMonthName(); // Arabic month name
final yearly = "هـ$year";
final manthly = "$day$month";
  return "$yearly $manthly";
}
