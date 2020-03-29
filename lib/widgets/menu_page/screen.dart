import 'package:flutter/material.dart';

import '../../globals/constants.dart';
import './page.dart';

class MenuScreen extends StatefulWidget {
  final Function(DateTime) onDateChanged;

  const MenuScreen({this.onDateChanged});

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
    return Stack(
      children: <Widget>[
        Container(
          color: Colors.white,
          height: double.infinity,
          width: double.infinity,
        ),
        Container(
          padding: EdgeInsets.all(10),
          child: PageView.builder(
            itemBuilder: (ctx, index) => MenuPage(_day),
            onPageChanged: _onPageChanged,
            controller: _pageController,
          ),
        )
      ],
    );
  }

  void _onPageChanged(int newPageIndex) {
    print("page changed to $newPageIndex");
    setState(() {
      var now = DateTime.now();
      _day = DateTime(now.year, now.month, now.day).add(
          Duration(days: newPageIndex - (PAGEVIEW_LIMIT_DAYS / 2).truncate()));
    });

    widget.onDateChanged(_day);
  }

  void setNewDate(DateTime selectedDate) {
    //setState(() {
    int oldPageIndex = _pageController.page.truncate();
    if (selectedDate.compareTo(_day) != 0) {
      print(
          "jump length: ${selectedDate.difference(_day).inDays}, from page: ${oldPageIndex} (${_day} to ${selectedDate})");
      int newPageIndex = oldPageIndex + selectedDate.difference(_day).inDays;
      print("jumping to page: $newPageIndex");
      _pageController.jumpToPage(newPageIndex);
    }
    //});
  }
}
