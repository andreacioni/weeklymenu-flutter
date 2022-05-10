import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:collection/collection.dart';
import 'package:weekly_menu_app/homepage.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../globals/extensions.dart';
import '../../main.data.dart';
import 'screen.dart';
import '../../models/shopping_list.dart';

class _ColorChooseSelectionDialog extends StatelessWidget {
  Color? selectedColor;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: BlockPicker(
        pickerColor: Colors.red, //default color
        onColorChanged: (Color color) {
          selectedColor = color;
        },
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('CANCEL')),
        ElevatedButton(
          child: Text('CHOOSE'),
          onPressed: () => Navigator.of(context).pop(selectedColor),
        )
      ],
    );
  }
}

class _SupermarketSectionSelectionDialog extends HookConsumerWidget {
  final List<String> availableSupermarketSections;

  const _SupermarketSectionSelectionDialog(
    this.availableSupermarketSections, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, _) {
    final ValueNotifier<Color?> selectedColor = useState(null);
    final iconTheme = Theme.of(context).iconTheme;

    void displayColorDialog() async {
      final color = await showDialog<Color?>(
          context: context, builder: (_) => _ColorChooseSelectionDialog());

      selectedColor.value = color;
    }

    return SimpleDialog(
      title: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Supermarket Section',
              style: Theme.of(context).textTheme.titleMedium),
          Text('Select existing section or type a new one',
              style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
      titlePadding: EdgeInsets.only(top: 10, left: 10, right: 10),
      contentPadding: EdgeInsets.all(10),
      children: [
        Divider(height: 1),
        Wrap(
          direction: Axis.horizontal,
          children: availableSupermarketSections
              .map((value) => GestureDetector(
                    onTap: () => Navigator.of(context).pop(value),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Chip(
                          label: Text(value),
                          avatar: Icon(
                            Icons.bookmark_border,
                            color: getColorByString(value),
                          ),
                          backgroundColor:
                              getColorByString(value).withOpacity(0.2),
                        ),
                        SizedBox(width: 3)
                      ],
                    ),
                  ))
              .toList(),
        ),
        SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: TextFormField(
                minLines: 1,
                maxLines: 1,
                maxLength: 20,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                autofillHints: availableSupermarketSections,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  contentPadding: const EdgeInsets.all(6.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  labelText: 'New section',
                ),
                onFieldSubmitted: (value) => Navigator.of(context).pop(value),
              ),
            ),
            IconButton(
              icon: selectedColor.value == null
                  ? Icon(Icons.color_lens_outlined)
                  : Container(
                      height: iconTheme.size,
                      width: iconTheme.size,
                      decoration: BoxDecoration(
                          color: selectedColor.value, shape: BoxShape.circle)),
              onPressed: displayColorDialog,
              splashRadius: Material.defaultSplashRadius / 2,
            )
          ],
        ),
        SizedBox(height: 10),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          children: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('CANCEL')),
            SizedBox(width: 5),
            ElevatedButton(onPressed: () {}, child: Text('SET'))
          ],
        ),
      ],
    );
  }
}

class ShoppingListAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const ShoppingListAppBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedItems = ref.watch(selectedShoppingListItems);

    void setSupermarketSectionOnSelectedItems(
        MapEntry<String, Color> str) async {
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

    Future<MapEntry<String, Color>?> chooseSupermarketSectionToSelection(
        List<String> availableSupermarketSections) async {
      final section = await showDialog<MapEntry<String, Color>?>(
          context: context,
          builder: (context) =>
              _SupermarketSectionSelectionDialog(availableSupermarketSections));

      return section;
    }

    void openSupermarketSectionSelectionDialog() async {
      final allItems =
          (await ref.shoppingLists.findAll(remote: false))[0].items;
      final availableSupermarketSections =
          (allItems.map((e) => e.supermarketSection).toList()
                ..removeWhere((e) => e == null || e.trim().isEmpty))
              .unique()
              .cast<String>();

      final section = await chooseSupermarketSectionToSelection(
          availableSupermarketSections);

      if (section != null) {
        setSupermarketSectionOnSelectedItems(section);
      }

      ref.read(selectedShoppingListItems.notifier).update((state) => []);
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
              //S
              onPressed: () =>
                  Scaffold.of(Scaffold.of(context).context).openDrawer(),
              splashRadius: Material.defaultSplashRadius / 2,
            )
          : IconButton(
              icon: Icon(
                Icons.arrow_back,
                size: 30.0,
                color: Colors.black,
              ),
              splashRadius: Material.defaultSplashRadius / 2,
              onPressed: () => ref
                  .read(selectedShoppingListItems.notifier)
                  .update((state) => []),
            ),
      actions: <Widget>[
        if (selectedItems.isEmpty)
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {},
            splashRadius: Material.defaultSplashRadius / 2,
          )
        else ...[
          IconButton(
            icon: Icon(Icons.bookmark_border),
            onPressed: openSupermarketSectionSelectionDialog,
            splashRadius: Material.defaultSplashRadius / 2,
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {},
            splashRadius: Material.defaultSplashRadius / 2,
          )
        ]
      ],
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(56);
}
