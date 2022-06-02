import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:weekly_menu_app/models/date.dart';

import '../../globals/constants.dart' as consts;
import './date_range_picker.dart';

class MenuAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Date _day;
  final List<void Function(Date)> _listeners = [];

  MenuAppBar(this._day);

  @override
  _MenuAppBarState createState() => _MenuAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(56);

  void addListener(void Function(Date) listener) => _listeners.add(listener);
  void removeListener(void Function(Date) listener) =>
      _listeners.remove(listener);
}

class _MenuAppBarState extends State<MenuAppBar> {
  late Date _day;

  @override
  void initState() {
    _day = widget._day;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text("Weekly Menu"),
      centerTitle: true,
      /* actions: [
        InkWell(
          overlayColor: MaterialStateProperty.all(Colors.red),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.calendar_today),
              SizedBox(
                width: 5,
              ),
              Text(_day.format(DateFormat.MMMEd())),
            ],
          ),
          onTap: () => _openDatePicker(context),
        ),
      ], */
      leading: IconButton(
        icon: Icon(
          Icons.menu,
          size: 30.0,
          color: Colors.black,
        ),
        onPressed: () {
          /*
          * We need the root Scaffold so we need the above context. If we don't
          * do this the  InherithedWidget will look into first parent Scaffold 
          * that does not contains any Drawer.
          */
          Scaffold.of(Scaffold.of(context).context).openDrawer();
        },
      ),
    );
  }
}
