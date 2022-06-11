import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../homepage.dart';
import '../../models/date.dart';
import '../../main.data.dart';
import '../../models/date.dart';
import '../../models/menu.dart';
import '../../widgets/flutter_data_state_builder.dart';
import 'daily_menu_section.dart';
import 'menu_app_bar.dart';
import 'menu_fab.dart';
import '../../globals/constants.dart';

final isDraggingMenuStateProvider = StateProvider<bool>((_) => false);

class MenuScreen extends HookConsumerWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /*
    * NOTE: we must avoid using setState in this widget to increase render 
    * performances. The AppBar and the FAB are taking to each other directly 
    * (via listeners) to avoid that.
    */
    final day = Date.now();
    final appBar = MenuAppBar(day);

    final scrollController = useScrollController();
    final screenHeight = MediaQuery.of(context).size.height;
    final isDraggingMenu = ref.watch(isDraggingMenuStateProvider);

    final todayKey = GlobalKey();

    void onPointerMove(PointerMoveEvent ev) {
      if (isDraggingMenu && !scrollController.position.outOfRange) {
        final offset = screenHeight ~/ 4;
        //final moveDistance = 3;
        if (ev.position.dy > screenHeight - offset) {
          final moveDistance = 3 + (7 * (ev.position.dy / screenHeight));
          scrollController.jumpTo(scrollController.offset + moveDistance);
        } else if (ev.position.dy < offset) {
          final moveDistance = 3 + (7 * (ev.position.dy / offset));

          scrollController.jumpTo(scrollController.offset - moveDistance);
        }
      }
    }

    Widget _buildListItem(BuildContext context, int index) {
      final day =
          Date.now().add(Duration(days: index - (pageViewLimitDays ~/ 2)));

      return DailyMenuFutureWrapper(day, key: day.isToday ? todayKey : null);
    }

    return Scaffold(
      appBar: appBar,
      floatingActionButton: MenuFloatingActionButton(todayKey),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Listener(
        onPointerMove: onPointerMove,
        //onPointerUp: (_) =>
        //    ref.read(isDraggingMenuStateProvider.state).state = false,
        child: CustomScrollView(
          slivers: [
            SliverList(
                delegate: SliverChildBuilderDelegate(
              (context, index) => _buildListItem(context, index),
              childCount: pageViewLimitDays,
            ))
          ],
          controller: scrollController,
        ),
      ),
    );
  }
}

/*
* Added this class to prevent FutureBuilder to fire every time a setState in 
* the parent widget is called. See: https://stackoverflow.com/questions/52249578/how-to-deal-with-unwanted-widget-build
* for more details.
*/

class DailyMenuFutureWrapper extends HookConsumerWidget {
  static final _httpParamDateParser = DateFormat('y-MM-dd');

  final Date day;

  DailyMenuFutureWrapper(this.day, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FlutterDataStateBuilder<List<Menu>>(
      state: ref.menus.watchAll(
        params: {'day': day.format(_httpParamDateParser)},
      ),
      builder: (context, model) {
        final filtered = model.where((m) => m.date == day).toList();
        final dailyMenu = DailyMenu(day: day, menus: filtered);

        return _buildMenuCard(context, ref, day, dailyMenu);
      },
    );
  }

  Widget _buildMenuCard(
      BuildContext context, WidgetRef ref, Date day, DailyMenu dailyMenu) {
    return DailyMenuSection(
      DailyMenuNotifier(dailyMenu),
      onTap: () {
        /*  ref
            .read(homePageModalBottomSheetDailyMenuNotifierProvider.notifier)
            .state = dailyMenuNotifier;
        ref.read(homePagePanelControllerProvider).open(); */
      },
    );
  }
}
