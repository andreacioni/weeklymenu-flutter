import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:collection/collection.dart';

import 'screen.dart';
import '../../main.data.dart';
import '../../models/shopping_list.dart';

class ShoppingListAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const ShoppingListAppBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedItems = ref.watch(selectedShoppingListItems);

    void setSupermarketSectionOnSelectedItems(String str) async {
      if (str.trim().isEmpty) return;

      final shoppingList = (await ref.shoppingLists.findAll())[0];
      final items = [...shoppingList.items];

      selectedItems.forEach((itemId) {
        final previousItem =
            items.firstWhereOrNull((item) => item.item == itemId);
        if (previousItem == null) return;
        items.removeWhere((item) => itemId == item.item);
        items.add(previousItem.copyWith(supermarketSection: str));
      });

      final newShoppingList = shoppingList.copyWith(items: items);
      await ref
          .read(shoppingListsRepositoryProvider)
          .save(newShoppingList, params: {'update': true});
    }

    Future<String?> chooseSupermarketSectionToSelection() async {
      final sectionName = await showDialog<String>(
          context: context,
          builder: (context) => SimpleDialog(
                title: Text('Choose a section'),
                titlePadding: EdgeInsets.all(10),
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                children: [
                  ConstrainedBox(
                    child: TextField(),
                    constraints: BoxConstraints(maxWidth: 100),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: ['Ciao', 'Gigi']
                        .map((value) => GestureDetector(
                              onTap: () => Navigator.of(context).pop(value),
                              child: Chip(
                                label: Text(value),
                                avatar: Icon(Icons.bookmark_border),
                                backgroundColor: getColorByString(value),
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ));

      return sectionName;
    }

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
            onPressed: () async {
              final section = await chooseSupermarketSectionToSelection();
              if (section != null) {
                setSupermarketSectionOnSelectedItems(section);
              }
              ref
                  .read(selectedShoppingListItems.notifier)
                  .update((state) => []);
            },
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
