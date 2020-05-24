import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';

import '../../globals/constants.dart';
import './menu_card.dart';
import '../../globals/utils.dart' as utils;
import './date_range_picker.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key key}) : super(key: key);

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final _todayOffset = (PAGEVIEW_LIMIT_DAYS / 2);
  final _today = utils.dateTimeToDate(DateTime.now());
  final _itemExtent = MenuCard.extent;

  DateTime _day;
  ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = new ScrollController(
      initialScrollOffset: _todayOffset * _itemExtent,
      keepScrollOffset: true,
    );

    //_scrollController.addListener(
    //    () => _onPageChanged(_scrollController.offset ~/ _itemExtent));

    _day = _today;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(context),
        floatingActionButton: FloatingActionButton(
          onPressed: _showDateRangePicker,
          child: Icon(Icons.lightbulb_outline),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: ListView.builder(
          itemExtent: _itemExtent,
          itemBuilder: _buildListItem,
          controller: _scrollController,
          itemCount: PAGEVIEW_LIMIT_DAYS,
        ));
  }

  Widget _buildListItem(BuildContext context, int index) {
    return MenuCard(utils.dateTimeToDate(
        _today.add(Duration(days: index - _todayOffset.toInt()))));
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text("Weekly Menu"),
      centerTitle: true,
      bottom: AppBar(
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

  void _openDatePicker(BuildContext ctx) {
    showDatePicker(
      context: ctx,
      initialDate: _day,
      firstDate: DateTime.now()
          .subtract(Duration(days: (PAGEVIEW_LIMIT_DAYS / 2).truncate())),
      lastDate: DateTime.now()
          .add((Duration(days: (PAGEVIEW_LIMIT_DAYS / 2).truncate()))),
    ).then(_setNewDate);
  }

  void _onPageChanged(int newPageIndex) {
    print("page changed to $newPageIndex");
    setState(() {
      var now = DateTime.now();
      _day = DateTime(now.year, now.month, now.day).add(
          Duration(days: newPageIndex - (PAGEVIEW_LIMIT_DAYS / 2).truncate()));
    });
  }

  void _setNewDate(DateTime selectedDate) {
    setState(() {
      var oldPageIndex = _scrollController.offset ~/ _itemExtent;
      if (selectedDate.compareTo(_day) != 0) {
        print(
            "jump length: ${selectedDate.difference(_day).inDays}, from page: ${oldPageIndex} (${_day} to ${selectedDate})");
        var newPageIndex = oldPageIndex + selectedDate.difference(_day).inDays;
        print("jumping to page: $newPageIndex");
        _scrollController.jumpTo(newPageIndex.toDouble() * _itemExtent);
      }
      _day = selectedDate;
    });
  }

  void _showDateRangePicker() {
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
                selectedPeriod: DatePeriod(DateTime.now(), DateTime.now()),
                onChanged: (dp) {
                  print("${dp.start} - ${dp.end}");
                },
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(Duration(days: 30)),
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

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
