import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:weekly_menu_app/widgets/shopping_list_screen/screen.dart';

class ShoppingListAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const ShoppingListAppBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedItems = ref.watch(selectedShoppingListItems);

    return AppBar(
      elevation: 5,
      title: Row(
        children: [
          if (selectedItems.isEmpty)
            const Text('Shopping List')
          else
            Text('${selectedItems.length}')
        ],
      ),
      leading: selectedItems.isEmpty
          ? IconButton(
              icon: Icon(
                Icons.menu,
                size: 30.0,
                color: Colors.black,
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
            )
          : IconButton(
              icon: Icon(
                Icons.arrow_back,
                size: 30.0,
                color: Colors.black,
              ),
              onPressed: () => ref
                  .read(selectedShoppingListItems.notifier)
                  .update((state) => []),
            ),
      actions: <Widget>[
        if (selectedItems.isEmpty)
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {},
          )
        else ...[
          IconButton(
            icon: Icon(Icons.bookmark_border),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {},
          )
        ]
      ],
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(50);
}
