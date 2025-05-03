extension DateX on DateTime? {
  DateTime get normalizedDate {
    final date = this;
    if (date == null) return DateTime.now().normalizedDate;
    final year = date.year;
    final month = date.month;
    final day = date.day;

    return DateTime(year, month, day);
  }
}
