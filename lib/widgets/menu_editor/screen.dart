import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../globals/utils.dart' as utils;
import '../../globals/constants.dart' as constants;
import '../../models/menu.dart';
import './scroll_view.dart';

class MenuEditorScreen extends StatefulWidget {
  MenuEditorScreen();

  @override
  _MenuEditorScreenState createState() => _MenuEditorScreenState();
}

class _MenuEditorScreenState extends State<MenuEditorScreen> {
  static final _dateParser = DateFormat('EEEE, MMMM dd');

  @override
  Widget build(BuildContext context) {
    final dailyMenu = Provider.of<DailyMenu>(context);

    final isToday = (utils.dateTimeToDate(DateTime.now()) == dailyMenu.day);
    final pastDay = (utils
        .dateTimeToDate(dailyMenu.day)
        .add(Duration(days: 1))
        .isBefore(DateTime.now()));

    final primaryColor = pastDay
        ? constants.pastColor
        : (isToday ? constants.todayColor : Theme.of(context).primaryColor);

    final theme = Theme.of(context).copyWith(
      primaryColor: primaryColor,
      appBarTheme: AppBarTheme(
        color: primaryColor,
      ),
    );
    return Theme(
      data: theme,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_dateParser.format(dailyMenu.day).toString()),
          actions: <Widget>[
            if (pastDay)
              IconButton(
                icon: Icon(Icons.archive),
                onPressed: () {},
              ),
          ],
        ),
        body: Container(
          child: MenuEditorScrollView(dailyMenu),
        ),
      ),
    );
  }
}
