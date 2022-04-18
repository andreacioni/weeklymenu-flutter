import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:weekly_menu_app/models/date.dart';

import '../../globals/constants.dart' as consts;
import './date_range_picker.dart';

class MenuAppBar extends StatefulWidget implements PreferredSizeWidget {
  final ScrollController _scrollController;
  final double _itemExtent;
  final Date _day;
  final void Function(Date)? onDayChanged;
  final List<void Function(Date)> _listeners = [];

  MenuAppBar(
    this._day,
    this._scrollController,
    this._itemExtent, {
    this.onDayChanged,
  });

  @override
  _MenuAppBarState createState() => _MenuAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(56 * 2.0);

  void addListener(void Function(Date) listener) => _listeners.add(listener);
  void removeListener(void Function(Date) listener) =>
      _listeners.remove(listener);
}

class _MenuAppBarState extends State<MenuAppBar> {
  late Date _day;

  @override
  void initState() {
    _day = widget._day;

    widget._scrollController.addListener(_onScrollEvent);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text("Weekly Menu"),
      centerTitle: true,
      bottom: AppBar(
        automaticallyImplyLeading: false,
        title: FlatButton(
          color: Colors.white.withOpacity(0.5),
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
          onPressed: () => _openDatePicker(context),
        ),
      ),
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

  void _onScrollEvent() =>
      _onOffsetChanged(widget._scrollController.offset ~/ widget._itemExtent);

  void _onOffsetChanged(int newPageIndex) {
    //print("page changed to $newPageIndex");
    final newDay = Date.now().add(Duration(
        days: newPageIndex - (consts.pageViewLimitDays / 2).truncate()));

    /*
    * This check aims to limit the number of times setState is called. Could be
    * improved...
    */
    if (newDay != _day) {
      setState(() => _day = newDay);
      widget.onDayChanged?.call(newDay);
      for (final listener in widget._listeners) {
        listener(newDay);
      }
    }
  }

  void _openDatePicker(BuildContext ctx) async {
    final ret = await showDatePicker(
      context: ctx,
      initialDate: _day.toDateTime,
      firstDate: Date.now()
          .subtract(Duration(days: (consts.pageViewLimitDays / 2).truncate()))
          .toDateTime,
      lastDate: Date.now()
          .add((Duration(days: (consts.pageViewLimitDays / 2).truncate())))
          .toDateTime,
    );

    if (ret != null) {
      _setNewDate(Date(ret));
    }
  }

  void _setNewDate(Date selectedDate) {
    setState(() {
      var oldPageIndex = widget._scrollController.offset ~/ widget._itemExtent;
      if (selectedDate != _day) {
        //print(
        //    "jump length: ${selectedDate.difference(_day).inDays}, from page: $oldPageIndex (${_day} to $selectedDate)");
        var newPageIndex = oldPageIndex + selectedDate.difference(_day).inDays;
        //print("jumping to page: $newPageIndex");
        widget._scrollController
            .jumpTo(newPageIndex.toDouble() * widget._itemExtent);
      }
      _day = selectedDate;
    });
  }

  @override
  void dispose() {
    widget._scrollController.removeListener(_onScrollEvent);
    super.dispose();
  }
}
