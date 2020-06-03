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
  bool _editingMode;

  @override
  void initState() {
    _editingMode = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dailyMenu = Provider.of<DailyMenu>(context);

    final primaryColor = dailyMenu.isPast
        ? constants.pastColor
        : (dailyMenu.isToday
            ? constants.todayColor
            : Theme.of(context).primaryColor);

    final theme = Theme.of(context).copyWith(
      primaryColor: primaryColor,
      toggleableActiveColor: primaryColor,
      appBarTheme: AppBarTheme(
        color: primaryColor,
      ),
      splashColor: primaryColor.withOpacity(0.4),
    );
    return Theme(
      data: theme,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_dateParser.format(dailyMenu.day).toString()),
          actions: <Widget>[
            if (dailyMenu.isPast)
              IconButton(
                icon: Icon(Icons.archive),
                onPressed: () {},
              ),
            if (!_editingMode)
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {},
              )
            else ...<Widget>[
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.swap_horiz),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.add_box),
                onPressed: () {},
              ),
            ]
          ],
        ),
        body: Container(
          child: MenuEditorScrollView(dailyMenu, editingMode: _editingMode),
        ),
      ),
    );
  }
}
