import 'package:flutter/material.dart';

import 'package:flutter_date_pickers/flutter_date_pickers.dart';

class DateRangePicker extends StatefulWidget {
  final DatePeriod selectedPeriod;
  final Function(DatePeriod) onChanged;
  final DatePickerRangeStyles datePickerStyles;
  final DateTime firstDate;
  final DateTime lastDate;

  DateRangePicker({
    this.datePickerStyles,
    this.selectedPeriod,
    this.onChanged,
    this.firstDate,
    this.lastDate,
  });

  @override
  _DateRangePickerState createState() => _DateRangePickerState();
}

class _DateRangePickerState extends State<DateRangePicker> {
  DatePeriod selectedPeriod;

  @override
  void initState() {
    selectedPeriod = widget.selectedPeriod;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RangePicker(
      selectedPeriod: _dateTimePeriodToDatePeriod(selectedPeriod),
      onChanged: (dp) {
        dp = _dateTimePeriodToDatePeriod(dp);
        setState(() {
          selectedPeriod = dp;
        });
        widget.onChanged(dp);
      },
      firstDate: _dateTimeToDate(widget.firstDate),
      lastDate: _dateTimeToDate(widget.lastDate),
      datePickerStyles: widget.datePickerStyles,
    );
  }

  DateTime _dateTimeToDate(DateTime dt) {
    return DateTime(dt.year, dt.month, dt.day);
  }

  DatePeriod _dateTimePeriodToDatePeriod(DatePeriod dp) {
    return DatePeriod(_dateTimeToDate(dp.start), _dateTimeToDate(dp.end));
  }
}
