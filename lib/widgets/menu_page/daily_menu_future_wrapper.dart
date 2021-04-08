import 'package:flutter/material.dart';
import 'package:flutter_data/flutter_data.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:intl/intl.dart';

import 'package:weekly_menu_app/globals/date.dart';
import 'package:weekly_menu_app/models/menu.dart';
import 'package:weekly_menu_app/providers/providers.dart';
import 'package:weekly_menu_app/widgets/flutter_data_state_builder.dart';
import 'package:weekly_menu_app/widgets/menu_editor/screen.dart';
import 'package:weekly_menu_app/widgets/menu_page/menu_card.dart';

/*
* Added this class to prevent FutureBuilder to fire every time a setState in 
* the parent widget is called. See: https://stackoverflow.com/questions/52249578/how-to-deal-with-unwanted-widget-build
* for more details.
*/
class DailyMenuFutureWrapper extends ConsumerWidget {
  static final _dateParser = DateFormat('y-MM-dd');

  final Date _day;

  DailyMenuFutureWrapper(this._day);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final repository = watch(menusRepositoryProvider);

    if (repository == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return FlutterDataStateBuilder<List<Menu>>(
      notifier: () => repository.watchAll(
        params: {'day': _day.format(_dateParser)},
      ),
      builder: (context, state, notifier, _) {
        final dailyMenu = DailyMenu(
          _day,
          state.model
              .where((menu) => menu.date == _day)
              .map((menu) => MenuOriginator(menu))
              .toList(),
        ); //TODO to be reviewed
        return _buildMenuCard(context, _day, dailyMenu);
      },
    );
  }

  Widget _buildMenuCard(BuildContext context, Date day, DailyMenu dailyMenu) {
    return ProviderScope(
      overrides: [dailyMenuScopedProvider.overrideWithValue(dailyMenu)],
      child: MenuCard(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ProviderScope(
                overrides: [
                  dailyMenuScopedProvider.overrideWithValue(dailyMenu)
                ],
                child: MenuEditorScreen(),
              ),
            ),
          );
        },
      ),
    );

    ;
  }
}
