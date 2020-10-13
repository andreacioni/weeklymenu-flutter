import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../globals/constants.dart' as consts;

class MenuAppBar extends StatefulWidget implements PreferredSizeWidget {
  final ScrollController _scrollController;
  final double _itemExtent;
  final DateTime _day;

  MenuAppBar(this._day, this._scrollController, this._itemExtent);

  @override
  _MenuAppBarState createState() => _MenuAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(56);
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
              Text(DateFormat.MMMEd().format(widget._day)),
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

  void _onPageChanged(int newPageIndex) {
    print("page changed to $newPageIndex");
    setState(() {
      var now = DateTime.now();
      _day = DateTime(now.year, now.month, now.day).add(Duration(
          days: newPageIndex - (consts.pageViewLimitDays / 2).truncate()));
    });
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
      if (selectedDate.compareTo(widget._day) != 0) {
        print(
            "jump length: ${selectedDate.difference(widget._day).inDays}, from page: $oldPageIndex (${widget._day} to $selectedDate)");
        var newPageIndex =
            oldPageIndex + selectedDate.difference(widget._day).inDays;
        print("jumping to page: $newPageIndex");
        widget._scrollController
            .jumpTo(newPageIndex.toDouble() * widget._itemExtent);
      }
      _day = selectedDate;
    });
  }

  void _onScrollEvent() =>
      _onPageChanged(widget._scrollController.offset ~/ widget._itemExtent);

  @override
  void dispose() {
    widget._scrollController.removeListener(_onScrollEvent);
    super.dispose();
  }
}
