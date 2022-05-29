import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../homepage.dart';
import '../../models/date.dart';
import '../../main.data.dart';
import '../../models/date.dart';
import '../../models/menu.dart';
import '../../widgets/flutter_data_state_builder.dart';
import '../../widgets/menu_editor/screen.dart';
import '../../widgets/menu_page/menu_card.dart';
import 'menu_app_bar.dart';
import 'menu_fab.dart';
import '../../globals/constants.dart';
import './menu_card.dart';

class MenuScreen extends StatefulHookConsumerWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends ConsumerState<MenuScreen> {
  final _todayOffset = (pageViewLimitDays / 2);
  final _itemExtent = MenuCard.extent;

  late ScrollController _scrollController;

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
    final bottomSheetDailyMenu =
        ref.watch(homePageModalBottomSheetDailyMenuNotifierProvider);
    final panelController = ref.watch(homePagePanelControllerProvider);

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
        return _buildMenuCard(context, ref, _day, dailyMenu);
      },
    );
  }

  Widget _buildMenuCard(
      BuildContext context, WidgetRef ref, Date day, DailyMenu dailyMenu) {
    final dailyMenuNotifier = DailyMenuNotifier(dailyMenu);
    return MenuCard(
      dailyMenuNotifier,
      onTap: () {
        ref
            .read(homePageModalBottomSheetDailyMenuNotifierProvider.notifier)
            .state = dailyMenuNotifier;
        ref.read(homePagePanelControllerProvider).open();
      },
    );
  }
}
