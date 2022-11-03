import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:collection/collection.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:flutter_data/flutter_data.dart';
import '../../../providers/shopping_list.dart';
import '../../../globals/constants.dart';
import '../../../models/user_preferences.dart' hide userPreferenceProvider;
import '../../../providers/user_preferences.dart';
import '../../../globals/extensions.dart';
import '../../../main.data.dart';
import 'screen.dart';
import '../../../models/shopping_list.dart' hide shoppingListProvider;

class ShoppingListAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const ShoppingListAppBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedItems = ref.watch(selectedShoppingListItemsProvider);
    final supermarketSections = ref.read(supermarketSectionProvider);

    Future<void> updateUserPreferences(SupermarketSection section) async {
      supermarketSections?.removeWhere((s) => s.name == section.name);

      final userPref = ref.read(userPreferenceProvider);
      if (userPref == null) {
        print('user preferences not available');
        return;
      }

      List<SupermarketSection> newSections;
      if (supermarketSections == null) {
        newSections = [];
      } else {
        newSections = [...supermarketSections];
      }

      newSections.add(section);

      await ref.read(userPreferencesRepositoryProvider).save(
          userPref.copyWith(supermarketSections: newSections),
          params: {UPDATE_PARAM: true});
    }

    Future<void> setSupermarketSectionOnSelectedItems(
        SupermarketSection? section) async {
      final shoppingListId =
          (await ref.read(firstShoppingListIdProvider.future));

      if (shoppingListId == null) throw 'No shopping list id resolved';

      final allItems = (await ref.shoppingListItems.findAll(
              remote: false,
              params: {SHOPPING_LIST_ID_PARAM: shoppingListId})) ??
          [];

      for (final selectedItem in selectedItems) {
        final previousItem =
            allItems.firstWhereOrNull((item) => item.item == selectedItem.item);
        if (previousItem == null ||
            previousItem.supermarketSectionName == section?.name) return;

        final newItem =
            previousItem.copyWith(supermarketSectionName: section?.name);

        await ref.shoppingListItems.save(newItem, params: {
          UPDATE_PARAM: true,
          SHOPPING_LIST_ID_PARAM: shoppingListId
        });
      }
    }

    Future<SupermarketSection?> chooseSupermarketSectionToSelection(
        List<String> availableSupermarketSections) async {
      final section = await showDialog<SupermarketSection?>(
          context: context,
          builder: (context) => _SupermarketSectionSelectionDialog());

      return section;
    }

    void removeShoppingItemFromList() async {
      final shoppingListId = ref.read(firstShoppingListIdProvider);

      selectedItems.forEach((i) {
        i.delete(params: {
          UPDATE_PARAM: true,
          SHOPPING_LIST_ID_PARAM: shoppingListId
        });
      });

      ref
          .read(selectedShoppingListItemsProvider.notifier)
          .update((state) => []);
    }

    void removeSupermarketSectionOnSelectedItems() async {
      setSupermarketSectionOnSelectedItems(null);
      ref
          .read(selectedShoppingListItemsProvider.notifier)
          .update((state) => []);
    }

    void openSupermarketSectionSelectionDialog() async {
      final shoppingListId = ref.read(firstShoppingListIdProvider);

      final allItems = (await ref.shoppingListItems.findAll(
              remote: false,
              params: {SHOPPING_LIST_ID_PARAM: shoppingListId})) ??
          [];
      final availableSupermarketSections =
          (allItems.map((e) => e.supermarketSectionName).toList()
                ..removeWhere((e) => e == null || e.trim().isEmpty))
              .unique()
              .cast<String>();

      final section = await chooseSupermarketSectionToSelection(
          availableSupermarketSections);

      if (section != null) {
        setSupermarketSectionOnSelectedItems(section);
        updateUserPreferences(section);
      }

      ref
          .read(selectedShoppingListItemsProvider.notifier)
          .update((state) => []);
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
                  .read(selectedShoppingListItemsProvider.notifier)
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
            icon: Icon(Icons.bookmark_remove_outlined),
            onPressed: removeSupermarketSectionOnSelectedItems,
            splashRadius: Material.defaultSplashRadius / 2,
          ),
          IconButton(
            icon: Icon(Icons.bookmark_border),
            onPressed: openSupermarketSectionSelectionDialog,
            splashRadius: Material.defaultSplashRadius / 2,
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: removeShoppingItemFromList,
            splashRadius: Material.defaultSplashRadius / 2,
          )
        ]
      ],
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(56);
}

class _ColorChooseSelectionDialog extends HookConsumerWidget {
  final Color? initialColor;

  _ColorChooseSelectionDialog({this.initialColor});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ValueNotifier<Color?> selectedColor = useState(initialColor);

    return AlertDialog(
      content: BlockPicker(
        pickerColor: selectedColor.value ?? Colors.transparent,
        onColorChanged: (Color color) {
          selectedColor.value = color;
        },
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('CANCEL')),
        ElevatedButton(
          child: Text('CHOOSE'),
          onPressed: selectedColor.value != null
              ? () => Navigator.of(context).pop(selectedColor.value)
              : null,
        )
      ],
    );
  }
}

class _SupermarketSectionSelectionDialog extends HookConsumerWidget {
  static const defaultColor = Colors.white;
  const _SupermarketSectionSelectionDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ValueNotifier<Color?> selectedColor = useState(null);
    final ObjectRef<String?> textFieldValue = useRef(null);
    final textController = useTextEditingController();
    final iconTheme = Theme.of(context).iconTheme;

    final availableSupermarketSections =
        ref.read(supermarketSectionProvider) ?? <SupermarketSection>[];

    void displayColorDialog() async {
      final color = await showDialog<Color?>(
          context: context,
          builder: (_) =>
              _ColorChooseSelectionDialog(initialColor: selectedColor.value));

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
        Divider(height: 5),
        Wrap(
          direction: Axis.horizontal,
          children: availableSupermarketSections
              .map((value) => GestureDetector(
                    onTap: () {
                      selectedColor.value = value.color;
                      textController.text = value.name;
                      textFieldValue.value = value.name;
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Chip(
                          label: Text(value.name),
                          avatar: Icon(Icons.bookmark_border,
                              color: value.color ?? defaultColor),
                          backgroundColor:
                              (value.color ?? defaultColor).withOpacity(0.2),
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
                controller: textController,
                minLines: 1,
                maxLines: 1,
                maxLength: 20,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                autofillHints:
                    availableSupermarketSections.map((e) => e.name).toList(),
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  contentPadding: const EdgeInsets.all(6.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  labelText: 'New section',
                ),
                onChanged: (value) => textFieldValue.value = value,
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
            ElevatedButton(
                onPressed: () {
                  final name = textFieldValue.value?.trim();
                  if (name?.isNotEmpty ?? false) {
                    Navigator.of(context).pop(SupermarketSection(
                        name: name!, color: selectedColor.value));
                  }
                },
                child: Text('SET'))
          ],
        ),
      ],
    );
  }
}
