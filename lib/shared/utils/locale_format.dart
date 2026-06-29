import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String localeTag(BuildContext context) {
  return Localizations.localeOf(context).toLanguageTag();
}

String formatShortDate(BuildContext context, DateTime date) {
  return DateFormat('d MMM yyyy', localeTag(context)).format(date);
}

String formatFullDate(BuildContext context, DateTime date) {
  return DateFormat('EEEE d MMMM yyyy', localeTag(context)).format(date);
}

String formatWeekday(BuildContext context, DateTime date) {
  return DateFormat('EEEE', localeTag(context)).format(date).toUpperCase();
}
