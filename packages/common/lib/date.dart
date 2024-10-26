import 'package:intl/intl.dart';

class Date {
  final DateTime _dateTime;

  Date(DateTime dateTime)
      : _dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day);

  factory Date.now() => Date(DateTime.now());

  factory Date.parse(DateFormat parser, String date) =>
      Date(parser.parse(date));

  String format(DateFormat formatter) => formatter.format(_dateTime);

  Date subtract(Duration duration) => Date(_dateTime.subtract(duration));

  Date add(Duration duration) => Date(_dateTime.add(duration));

  Duration difference(Date date) => _dateTime.difference(date.toDateTime);

  bool get isToday => Date.now() == this;

  bool get isPast => _dateTime.add(Duration(days: 1)).isBefore(DateTime.now());

  DateTime get toDateTime => _dateTime;

  @override
  bool operator ==(o) => o is Date && o._dateTime == this._dateTime;

  @override
  int get hashCode => _dateTime.hashCode;

  @override
  String toString() => _dateTime.toString();

  static Date toDate(DateTime dt) => Date(dt);
}

class DateRange {
  final Date start;
  final Date end;

  DateRange(this.start, this.end);

  @override
  String toString() => "($start - $end)";

  @override
  bool operator ==(o) =>
      o is DateRange && o.start == this.start && o.end == this.end;

  @override
  int get hashCode => start.hashCode ^ end.hashCode;
}
