import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'screen.dart';

class MenuAppBar extends HookConsumerWidget implements PreferredSizeWidget {
  MenuAppBar();

  @override
  Size get preferredSize => Size.fromHeight(56);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editingMode = ref.watch(isEditingMenuStateProvider);

    return AppBar(
      title: Text("Weekly Menu"),
      centerTitle: true,
      actions: [
        IconButton(
            onPressed: () => ref
                .read(isEditingMenuStateProvider.notifier)
                .state = !editingMode,
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
    );
  }
}
