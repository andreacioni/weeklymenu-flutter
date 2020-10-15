import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:weekly_menu_app/globals/date.dart';
import 'package:weekly_menu_app/models/menu.dart';
import 'package:weekly_menu_app/providers/menus_provider.dart';
import 'package:weekly_menu_app/widgets/menu_editor/screen.dart';
import 'package:weekly_menu_app/widgets/menu_page/menu_card.dart';

class DailyMenuFutureWrapper extends StatefulWidget {
  final Date _day;

  DailyMenuFutureWrapper(this._day);

  @override
  _DailyMenuFutureWrapperState createState() => _DailyMenuFutureWrapperState();
}

class _DailyMenuFutureWrapperState extends State<DailyMenuFutureWrapper> {
  Future<DailyMenu> _dailyMenu;

  @override
  void initState() {
    _dailyMenu = Provider.of<MenusProvider>(context, listen: false)
        .fetchDailyMenu(widget._day);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DailyMenu>(
      future: _dailyMenu,
      builder: (ctx, snapshot) {
        if (snapshot.hasError) {
          return Container();
        }

        switch (snapshot.connectionState) {
          case ConnectionState.done:
            return _buildMenuCard(widget._day, snapshot.data);
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
}
