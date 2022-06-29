import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:weekly_menu_app/globals/hooks.dart';
import 'package:weekly_menu_app/widgets/menu_page/date_range_picker.dart';

import '../../globals/listener_utils.dart';
import '../../homepage.dart';
import '../../models/date.dart';
import '../../main.data.dart';
import '../../models/date.dart';
import '../../models/menu.dart';
import '../../widgets/flutter_data_state_builder.dart';
import 'daily_menu_section.dart';
import 'menu_app_bar.dart';
import '../../globals/constants.dart';

final isDraggingMenuStateProvider = StateProvider<bool>((_) => false);
final isEditingMenuStateProvider =
    StateProvider.autoDispose<bool>((_) => false);
final pointerOverWidgetIndexStateProvider =
    StateProvider.autoDispose<Date?>((_) => null);

const _USE_SLIVER = false;

class MenuScreen extends HookConsumerWidget {
  MenuScreen({Key? key}) : super(key: key);

  double todayOffset = -1;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /*
    * NOTE: we must avoid using setState in this widget to increase render 
    * performances. The AppBar and the FAB are taking to each other directly 
    * (via listeners) to avoid that.
    */
    print('build');
    final day = Date.now();
    final appBar = MenuAppBar(day);

    final scrollController = useScrollController();
    final screenHeight = MediaQuery.of(context).size.height;
    final displayFAB = useState(true);
    final todayKey = GlobalKey();

    void onPointerMove(PointerMoveEvent ev) {
      final isDraggingMenu = ref.read(isDraggingMenuStateProvider);

      //Handle pointer move at the tob/Bottom of the screen and scroll
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

      //Handle pointer over daily menu container
      if (isDraggingMenu) {
        final RenderBox box =
            context.findAncestorRenderObjectOfType<RenderBox>()!;
        final result = BoxHitTestResult();
        Offset local = box.globalToLocal(ev.position);
        if (box.hitTest(result, position: local)) {
          for (final hit in result.path) {
            /// temporary variable so that the [is] allows access of [index]
            final target = hit.target;
            final pointerOverWidgetIndex =
                ref.read(pointerOverWidgetIndexStateProvider);
            if (target is IndexedListenerWrapperRenderObject &&
                target.index != null &&
                target.index is Date &&
                pointerOverWidgetIndex != target.index) {
              ref.read(pointerOverWidgetIndexStateProvider.notifier).state =
                  target.index as Date;
            }
          }
        }
      }
    }

    Widget _buildListItem(int index) {
      final day =
          Date.now().add(Duration(days: index - (pageViewLimitDays ~/ 2)));

      return IndexedListenerWrapper(
        key: day.isToday ? todayKey : ValueKey(day),
        index: day,
        child: DailyMenuFutureWrapper(
          day,
        ),
      );
    }

    void _scrollListener() {
      const threshold = 50;
      final bool? newValue;
      if (scrollController.offset > todayOffset - threshold &&
          scrollController.offset < todayOffset + threshold) {
        newValue = false;
      } else {
        newValue = true;
      }

      if (newValue != displayFAB.value) {
        //displayFAB.value = newValue;
      }
    }

    Widget _buildScrollView() {
      if (_USE_SLIVER) {
        return ListView.builder(
            itemBuilder: (context, index) => _buildListItem(index));
      }
      return SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: List.generate(pageViewLimitDays, _buildListItem),
        ),
      );
    }

    useEffect(() {
      // center the scrollable area on today just on the first build
      // save the offset in order to display the button only when needed
      scrollController.addListener(_scrollListener);

      Future.delayed(Duration.zero, () {
        if (todayKey.currentContext != null) {
          Scrollable.ensureVisible(todayKey.currentContext!)
              .then((_) => todayOffset = scrollController.offset);
        }
      });

      return () => scrollController.removeListener(_scrollListener);
    }, [scrollController]);

    return Scaffold(
      appBar: appBar,
      floatingActionButton: _MenuFloatingActionButton(todayKey),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Listener(
        onPointerMove: onPointerMove,
        onPointerUp: (_) {
          ref.read(pointerOverWidgetIndexStateProvider.notifier).state = null;
          ref.read(isDraggingMenuStateProvider.notifier).state = false;
        },
        child: _buildScrollView(),
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

class _MenuFloatingActionButton extends StatelessWidget {
  final GlobalKey todayChildGlobalKey;

  const _MenuFloatingActionButton(
    this.todayChildGlobalKey, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        if (todayChildGlobalKey.currentContext != null)
          Scrollable.ensureVisible(todayChildGlobalKey.currentContext!,
              duration: Duration(milliseconds: 500), curve: Curves.decelerate);
      },
      child: //day.isToday
          //? Icon(Icons.lightbulb_outline) :
          Icon(Icons.today_outlined),
    );
  }

  void _showDateRangePicker(BuildContext context) {
    DatePickerRangeStyles styles = DatePickerRangeStyles(
      selectedPeriodLastDecoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(10.0),
              bottomRight: Radius.circular(10.0))),
      selectedPeriodStartDecoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0), bottomLeft: Radius.circular(10.0)),
      ),
      selectedPeriodMiddleDecoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.3),
          shape: BoxShape.rectangle),
    );

    showDialog(
      context: context,
      builder: (ctx) => Padding(
        padding: EdgeInsets.all(15),
        child: AlertDialog(
          title: Text('Choose a single date or a range'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              DateRangePicker(
                selectedPeriod:
                    DatePeriod(Date.now().toDateTime, Date.now().toDateTime),
                onChanged: (dp) {
                  print("${dp.start} - ${dp.end}");
                },
                firstDate: Date.now(),
                lastDate: Date.now().add(Duration(days: 30)),
                datePickerStyles: styles,
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(
                'CANCEL',
                style: TextStyle(color: Theme.of(ctx).primaryColor),
              ),
            ),
            FlatButton(
              onPressed: () {},
              child: Text(
                'CONTINUE',
                style: TextStyle(color: Theme.of(ctx).primaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
