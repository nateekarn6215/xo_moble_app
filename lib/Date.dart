class Date {
  int year;
  int month;
  int dayOfMonth;
  int hourOfDay;
  int minute;
  int second;

  Date({
    required this.year,
    required this.month,
    required this.dayOfMonth,
    required this.hourOfDay,
    required this.minute,
    required this.second,
  });

  factory Date.fromJson(Map<String, dynamic> json) => Date(
        year: json["year"],
        month: json["month"],
        dayOfMonth: json["dayOfMonth"],
        hourOfDay: json["hourOfDay"],
        minute: json["minute"],
        second: json["second"],
      );

  Map<String, dynamic> toJson() => {
        "year": year,
        "month": month,
        "dayOfMonth": dayOfMonth,
        "hourOfDay": hourOfDay,
        "minute": minute,
        "second": second,
      };

  DateTime toDateTime() {
    return DateTime(year, month + 1, dayOfMonth, hourOfDay, minute, second);
  }

  factory Date.toDate(DateTime dateTime) {
    return Date(
        year: dateTime.year,
        month: dateTime.month - 1,
        dayOfMonth: dateTime.day,
        hourOfDay: dateTime.hour,
        minute: dateTime.minute,
        second: dateTime.second);
  }
  @override
  String toString() {
    return 'Date(year: $year, month: $month, dayOfMonth: $dayOfMonth, hourOfDay: $hourOfDay, minute: $minute, second: $second)';
  }
}
