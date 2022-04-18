import 'package:flutter/material.dart';
import 'package:flutter_data/flutter_data.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:weekly_menu_app/main.data.dart';
import '../../models/date.dart';
import '../../models/menu.dart';
import '../../widgets/flutter_data_state_builder.dart';
import '../../widgets/menu_editor/screen.dart';
import '../../widgets/menu_page/menu_card.dart';

/*
* Added this class to prevent FutureBuilder to fire every time a setState in 
* the parent widget is called. See: https://stackoverflow.com/questions/52249578/how-to-deal-with-unwanted-widget-build
* for more details.
*/
class DailyMenuFutureWrapper extends HookConsumerWidget {
  static final _dateParser = DateFormat('y-MM-dd');

  final Date _day;

  DailyMenuFutureWrapper(this._day);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FlutterDataStateBuilder<List<Menu>>(
      state: ref.menus.watchAll(
        params: {'day': _day.format(_dateParser)},
      ),
      builder: (context, model) {
        final filtered = model.where((m) => m.date == _day).toList();
        final dailyMenu = DailyMenu(day: _day, menus: filtered);
        return _buildMenuCard(context, _day, dailyMenu);
      },
    );
  }

  Widget _buildMenuCard(BuildContext context, Date day, DailyMenu dailyMenu) {
    return MenuCard(
      dailyMenu,
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => MenuEditorScreen(DailyMenuNotifier(dailyMenu)),
          ),
        );
      },
    );
  }
}
