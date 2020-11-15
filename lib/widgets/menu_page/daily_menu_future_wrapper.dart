import 'package:flutter/material.dart';
import 'package:flutter_data/flutter_data.dart';
import 'package:flutter_data_state/flutter_data_state.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:weekly_menu_app/globals/date.dart';
import 'package:weekly_menu_app/models/menu.dart';
import 'package:weekly_menu_app/widgets/menu_editor/screen.dart';
import 'package:weekly_menu_app/widgets/menu_page/menu_card.dart';

/*
* Added this class to prevent FutureBuilder to fire every time a setState in 
* the parent widget is called. See: https://stackoverflow.com/questions/52249578/how-to-deal-with-unwanted-widget-build
* for more details.
*/
class DailyMenuFutureWrapper extends StatelessWidget {
  static final _dateParser = DateFormat('y-MM-dd');

  final Date _day;

  DailyMenuFutureWrapper(this._day);

  @override
  Widget build(BuildContext context) {
    final repository = context.watch<Repository<Menu>>();
/*     return FutureBuilder<List<Menu>>(
      future: repository.findAll(),
      initialData: [],
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Container(child: Text("Error occurred"));
        }

        if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        } else {
          final dailyMenu = DailyMenu(
            _day,
            snapshot.data.map((menu) => MenuOriginator(menu)).toList(),
          ); //TODO to be reviewed
          return _buildMenuCard(context, _day, dailyMenu);
        }
      },
    ); */
    return DataStateBuilder<List<Menu>>(
      notifier: () => repository.watchAll(
        params: {'day': _day.format(_dateParser)},
      ),
      builder: (context, state, notifier, _) {
        if (state.hasException && !state.hasModel) {
          return Container(child: Text("Error occurred"));
        }

        if (state.isLoading && !state.hasModel) {
          return Center(child: CircularProgressIndicator());
        }

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
