import 'package:flutter/material.dart';
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
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = new ScrollController();

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
    final appBar = MenuAppBar(day);

    return Scaffold(
      appBar: appBar,
      floatingActionButton: MenuFloatingActionButton(day),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: CustomScrollView(
        slivers: [
          SliverList(
              delegate: SliverChildBuilderDelegate(
            (context, index) => _buildListItem(context, index),
            childCount: pageViewLimitDays,
          ))
        ],
        controller: _scrollController,
      ),
    );
  }

  Widget _buildListItem(BuildContext context, int index) {
    final day = Date.now().add(Duration(days: index - pageViewLimitDays ~/ 2));

    final theme = Theme.of(context);

    return DailyMenuFutureWrapper(day);
    /* return SliverAppBar(
      toolbarHeight: 50,
      title: Padding(
        padding: const EdgeInsets.only(left: 3),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: TextSpan(
                text: day.format(_appBarDateParser) + ' ',
                style: theme.textTheme.subtitle1!.copyWith(color: Colors.black),
                children: <TextSpan>[
                  TextSpan(
                    text: day.format(_appBarMonthParser),
                    style: theme.textTheme.subtitle1!
                        .copyWith(color: Colors.black38),
                  ),
                ],
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Container(
                height: 3,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: theme.primaryColor.withOpacity(0.8)),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      centerTitle: false,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Icon(Icons.add),
        )
      ],
    ); */
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
  static final _httpParamDateParser = DateFormat('y-MM-dd');

  final Date _day;

  DailyMenuFutureWrapper(this._day);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FlutterDataStateBuilder<List<Menu>>(
      state: ref.menus.watchAll(
        params: {'day': _day.format(_httpParamDateParser)},
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
    return MenuCard(
      dailyMenu,
      onTap: () {
        /*  ref
            .read(homePageModalBottomSheetDailyMenuNotifierProvider.notifier)
            .state = dailyMenuNotifier;
        ref.read(homePagePanelControllerProvider).open(); */
      },
    );
  }
}
