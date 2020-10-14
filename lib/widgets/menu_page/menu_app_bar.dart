import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';

import '../../globals/constants.dart' as consts;
import './date_range_picker.dart';

class MenuAppBar extends StatefulWidget implements PreferredSizeWidget {
  final ScrollController _scrollController;
  final double _itemExtent;
  final DateTime _day;

  MenuAppBar(
    this._day,
    this._scrollController,
    this._itemExtent,
  );

  @override
  _MenuAppBarState createState() => _MenuAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(56 * 2.0);
}

class _MenuAppBarState extends State<MenuAppBar> {
  DateTime _day;

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
              Text(DateFormat.MMMEd().format(_day)),
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
        onPressed: () => Scaffold.of(context).openDrawer(),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.refresh,
            size: 30.0,
            color: Colors.black,
          ),
          onPressed: () => () {},
        ),
      ],
    );
  }

  void _onScrollEvent() =>
      _onOffsetChanged(widget._scrollController.offset ~/ widget._itemExtent);

  void _onOffsetChanged(int newPageIndex) {
    //print("page changed to $newPageIndex");
    var now = DateTime.now();
    final newDay = DateTime(now.year, now.month, now.day).add(Duration(
        days: newPageIndex - (consts.pageViewLimitDays / 2).truncate()));

    /*
    * This check aims to limit the number of times setState is called. Could be
    * improved...
    */
    if (newDay.day != _day.day) {
      setState(() => _day = newDay);
    }
  }

  void _openDatePicker(BuildContext ctx) async {
    DateTime dt = await showDatePicker(
      context: ctx,
      initialDate: _day,
      firstDate: DateTime.now()
          .subtract(Duration(days: (consts.pageViewLimitDays / 2).truncate())),
      lastDate: DateTime.now()
          .add((Duration(days: (consts.pageViewLimitDays / 2).truncate()))),
    );
    if (dt != null) {
      _setNewDate(dt);
    }
  }

  void _setNewDate(DateTime selectedDate) {
    setState(() {
      var oldPageIndex = widget._scrollController.offset ~/ widget._itemExtent;
      if (selectedDate.compareTo(_day) != 0) {
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
