import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:weekly_menu_app/widgets/screens/menu_page/notifier.dart';
import 'package:weekly_menu_app/widgets/shared/app_bar.dart';
import 'package:common/date.dart';

class MenuAppBar extends HookConsumerWidget implements PreferredSizeWidget {
  MenuAppBar();

  @override
  Size get preferredSize => Size.fromHeight(56);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(menuScreenNotifierProvider.notifier);

    final editingMode =
        ref.watch(menuScreenNotifierProvider.select((s) => s.editMode));

    return DateRangeAppBar(
      dateRange: DateRange(Date.now(), Date.now().add(Duration(days: 7))),
      actionIcon: editingMode
          ? Icon(Icons.done)
          : Icon(Icons.mode_edit_outline_outlined),
      onActionTap: () => notifier.setEditMode(!editingMode),
      onLeadingTap: () {
        /*
          * We need the root Scaffold so we need the above context. If we don't
          * do this the  InherithedWidget will look into first parent Scaffold 
          * that does not contains any Drawer.
          */
        Scaffold.of(Scaffold.of(context).context).openDrawer();
      },
    );
    /* return AppBar(
      title: Text("Weekly Menu"),
      centerTitle: true,
      actions: [
        IconButton(
            onPressed: () => notifier.setEditMode(!editingMode),
            icon: editingMode
                ? Icon(Icons.done)
                : Icon(Icons.mode_edit_outline_outlined))
      ],
      leading: IconButton(
        icon: Icon(Icons.menu, size: 30.0),
        onPressed: () {
          /*
          * We need the root Scaffold so we need the above context. If we don't
          * do this the  InherithedWidget will look into first parent Scaffold 
          * that does not contains any Drawer.
          */
          Scaffold.of(Scaffold.of(context).context).openDrawer();
        },
      ),
    ); */
  }
}
