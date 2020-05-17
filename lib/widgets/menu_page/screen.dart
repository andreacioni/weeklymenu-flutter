import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';

import '../../globals/constants.dart';
import '../app_bar.dart';
import './page.dart';
import './date_range_picker.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key key}) : super(key: key);

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  PageController _pageController;
  DateTime _day;

  @override
  void initState() {
    var pageIndex = (PAGEVIEW_LIMIT_DAYS / 2).truncate();
    _pageController = new PageController(initialPage: pageIndex);

    var now = DateTime.now();
    _day = DateTime(now.year, now.month, now.day);

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
      body: Container(
        padding: EdgeInsets.all(10),
        child: PageView.builder(
          itemBuilder: (ctx, index) => MenuPage(_day),
          controller: _pageController,
          onPageChanged: _onPageChanged,
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return BaseAppBar(
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FlatButton(
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
        ],
      ),
      leading: IconButton(
        icon: Icon(
          Icons.menu,
          size: 30.0,
          color: Colors.black,
        ),
        onPressed: () => Scaffold.of(context).openDrawer(),
      ),
      actions: <Widget>[/* 
        IconButton(
          icon: Icon(
            Icons.refresh,
            size: 30.0,
            color: Colors.black,
          ),
          onPressed: () => () {},
        ), */
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
      int oldPageIndex = _pageController.page.truncate();
      if (selectedDate.compareTo(_day) != 0) {
        print(
            "jump length: ${selectedDate.difference(_day).inDays}, from page: ${oldPageIndex} (${_day} to ${selectedDate})");
        int newPageIndex = oldPageIndex + selectedDate.difference(_day).inDays;
        print("jumping to page: $newPageIndex");
        _pageController.jumpToPage(newPageIndex);
      }
      _day = selectedDate;
    });
  }

  void _openAddRecipeModal() async {
    /* showModalBottomSheet(
      context: ctx,
      builder: (_) => Padding(
        padding: EdgeInsets.all(15),
        child: AddRecipeToMenuModal(
          onSelectionEnd: (_) {},
        ),
      ),
    ); */

    /* showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        contentPadding: EdgeInsets.all(0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            InkWell(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                topLeft: Radius.circular(10),
              ),
              splashColor: Theme.of(context).primaryColor,
              child: ListTile(
                leading: Icon(
                  Icons.calendar_today,
                  size: 40,
                ),
                title: Text(
                  'Single Day',
                ),
                subtitle: Text(
                  'Generate menu automatically for current day',
                ),
              ),
              onTap: () {},
            ),
            InkWell(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
              splashColor: Theme.of(context).primaryColor,
              child: ListTile(
                leading: Icon(
                  Icons.date_range,
                  size: 45,
                ),
                title: Text(
                  'Multiple Days',
                ),
                subtitle: Text(
                  'Generate menu automatically for multiple days',
                ),
              ),
              onTap: () {
                Navigator.of(ctx).pop();
                _showDateRangePicker();
              },
            ),
          ],
        ),
      ),
    ); */
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
                onChanged: (dp) {print("${dp.start} - ${dp.end}");},
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
}
