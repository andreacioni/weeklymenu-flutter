import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../globals/utils.dart' as utils;
import '../../globals/constants.dart' as constants;
import '../../models/enums/meals.dart';
import './scroll_view.dart';

class MenuEditorScreen extends StatefulWidget {
  final DateTime _day;
  final Map<Meal, List<String>> _menuByMeal;

  MenuEditorScreen(this._day, this._menuByMeal);

  @override
  _MenuEditorScreenState createState() => _MenuEditorScreenState();
}

class _MenuEditorScreenState extends State<MenuEditorScreen> {
  static final _dateParser = DateFormat('EEEE, MMMM dd');

  bool _isToday;
  bool _pastDay;

  bool _initialized;

  ThemeData _theme;

  @override
  void initState() {
    _isToday = (utils.dateTimeToDate(DateTime.now()) == widget._day);
    _pastDay = (utils
        .dateTimeToDate(widget._day)
        .add(Duration(days: 1))
        .isBefore(DateTime.now()));

    _initialized = false;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      Color primaryColor = _pastDay
          ? constants.pastColor
          : (_isToday ? constants.todayColor : Theme.of(context).primaryColor);

      _theme = Theme.of(context).copyWith(
        appBarTheme: AppBarTheme(
          color: primaryColor,
        ),
      );

      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _theme,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_dateParser.format(widget._day).toString()),
          actions: <Widget>[
            if (_pastDay)
              IconButton(
                icon: Icon(Icons.lock),
                onPressed: () {},
              ),
          ],
        ),
        body: Container(
          child: MenuEditorScrollView(widget._day),
        ),
      ),
    );
  }
}
