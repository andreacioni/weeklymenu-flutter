import 'package:flutter/material.dart';
import 'package:weekly_menu_app/globals/date.dart';
import 'package:weekly_menu_app/widgets/menu_page/daily_menu_future_wrapper.dart';

import 'menu_app_bar.dart';
import 'menu_fab.dart';
import '../../globals/constants.dart';
import './menu_card.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key key}) : super(key: key);

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final _todayOffset = (pageViewLimitDays / 2);
  final _itemExtent = MenuCard.extent;

  ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = new ScrollController(
      initialScrollOffset: _todayOffset * _itemExtent,
      keepScrollOffset: true,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /*
    * NOTE: we must avoid using setState in this widget to increase render 
    * performances. The AppBar and the FAB are taking to each other directly 
    * (via listeners) to avoid that.
    */
    final day = Date.now();
    final appBar = MenuAppBar(
      day,
      _scrollController,
      _itemExtent,
    );
    return Scaffold(
      appBar: appBar,
      floatingActionButton: MenuFloatingActionButton(
        day,
        appBar,
        _scrollController,
        _itemExtent,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: ListView.builder(
        itemExtent: _itemExtent,
        itemBuilder: _buildListItem,
        controller: _scrollController,
        itemCount: pageViewLimitDays,
      ),
    );
  }

  Widget _buildListItem(BuildContext context, int index) {
    final day = Date.now().add(Duration(
      days: index - _todayOffset.toInt(),
    ));

    return DailyMenuFutureWrapper(day);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
