import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../globals/utils.dart' as utils;
import '../../globals/constants.dart' as constants;
import '../../models/enums/meals.dart';

class MenuEditorScreen extends StatefulWidget {
  final DateTime _day;
  final Map<Meal, List<String>> _menuByMeal;

  MenuEditorScreen(this._day, this._menuByMeal);

  @override
  _MenuEditorScreenState createState() => _MenuEditorScreenState();
}

class _MenuEditorScreenState extends State<MenuEditorScreen> {
  static final _dateParser = DateFormat('EEEE, MMMM dd');

  bool isToday;
  bool pastDay;
  Color primaryColor;
  Color accentColor;
  bool initialized;

  @override
  void initState() {
    isToday = (utils.dateTimeToDate(DateTime.now()) == widget._day);
    pastDay = (utils
        .dateTimeToDate(widget._day)
        .add(Duration(days: 1))
        .isBefore(DateTime.now()));

    initialized = false;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!initialized) {
      primaryColor = pastDay
          ? constants.pastColor
          : (isToday ? constants.todayColor : Theme.of(context).primaryColor);

      primaryColor = primaryColor.withOpacity(0.6);
      accentColor = primaryColor.withOpacity(0.1);
      initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_dateParser.format(widget._day).toString()),
        backgroundColor: primaryColor,
        actions: <Widget>[
          if (pastDay)
            IconButton(
              icon: Icon(Icons.lock),
              onPressed: () {},
              highlightColor: accentColor,
              splashColor: accentColor,
            ),
        ],
      ),
      body: Container(color: accentColor),
    );
  }
}
