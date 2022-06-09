import 'package:flutter/material.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:weekly_menu_app/models/date.dart';
import 'package:weekly_menu_app/widgets/menu_page/menu_app_bar.dart';

import './date_range_picker.dart';

class MenuFloatingActionButton extends StatelessWidget {
  final GlobalKey todayChildGlobalKey;

  const MenuFloatingActionButton(
    this.todayChildGlobalKey, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        if (todayChildGlobalKey.currentContext != null)
          Scrollable.ensureVisible(todayChildGlobalKey.currentContext!);
      },
      child: //day.isToday
          //? Icon(Icons.lightbulb_outline) :
          Icon(Icons.today_outlined),
    );
  }

  void _showDateRangePicker(BuildContext context) {
    DatePickerRangeStyles styles = DatePickerRangeStyles(
      selectedPeriodLastDecoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(10.0),
              bottomRight: Radius.circular(10.0))),
      selectedPeriodStartDecoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0), bottomLeft: Radius.circular(10.0)),
      ),
      selectedPeriodMiddleDecoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.3),
          shape: BoxShape.rectangle),
    );

    showDialog(
      context: context,
      builder: (ctx) => Padding(
        padding: EdgeInsets.all(15),
        child: AlertDialog(
          title: Text('Choose a single date or a range'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              DateRangePicker(
                selectedPeriod:
                    DatePeriod(Date.now().toDateTime, Date.now().toDateTime),
                onChanged: (dp) {
                  print("${dp.start} - ${dp.end}");
                },
                firstDate: Date.now(),
                lastDate: Date.now().add(Duration(days: 30)),
                datePickerStyles: styles,
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(
                'CANCEL',
                style: TextStyle(color: Theme.of(ctx).primaryColor),
              ),
            ),
            FlatButton(
              onPressed: () {},
              child: Text(
                'CONTINUE',
                style: TextStyle(color: Theme.of(ctx).primaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
