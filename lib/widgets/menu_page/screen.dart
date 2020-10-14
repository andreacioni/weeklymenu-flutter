import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weekly_menu_app/globals/date.dart';

import 'package:weekly_menu_app/widgets/menu_page/menu_app_bar.dart';
import 'package:weekly_menu_app/widgets/menu_page/menu_fab.dart';

import '../menu_editor/screen.dart';
import '../../providers/menus_provider.dart';
import '../../globals/constants.dart';
import './menu_card.dart';
import '../../models/menu.dart';
import '../../globals/utils.dart' as utils;

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key key}) : super(key: key);

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final _todayOffset = (pageViewLimitDays / 2);
  final _today = Date.now();
  final _itemExtent = MenuCard.extent;

  Date _day;
  ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = new ScrollController(
      initialScrollOffset: _todayOffset * _itemExtent,
      keepScrollOffset: true,
    );

    _day = _today;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MenuAppBar(
        _day,
        _scrollController,
        _itemExtent,
      ),
      floatingActionButton:
          MenuFloatingActinoButton(day: _day, onGoTodayPressed: null),
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
    final day = _today.add(Duration(
      days: index - _todayOffset.toInt(),
    ));

    return FutureBuilder<DailyMenu>(
      future: Provider.of<MenusProvider>(context, listen: false)
          .fetchDailyMenu(day),
      builder: (ctx, snapshot) {
        if (snapshot.hasError) {
          return Container();
        }
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            return _buildMenuCard(day, snapshot.data);
          default:
            return Center(
              child: CircularProgressIndicator(),
            );
        }
      },
    );
  }

  Widget _buildMenuCard(Date day, DailyMenu dailyMenu) {
    return ChangeNotifierProvider.value(
      value: dailyMenu,
      child: MenuCard(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ChangeNotifierProvider.value(
                value: dailyMenu,
                child: MenuEditorScreen(),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
