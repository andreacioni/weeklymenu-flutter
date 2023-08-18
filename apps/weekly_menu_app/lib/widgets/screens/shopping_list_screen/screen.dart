import 'dart:developer';

import 'package:data/flutter_data/shopping_list.dart';
import 'package:data/repositories.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:collection/collection.dart';
import 'package:model/ingredient.dart';
import 'package:model/shopping_list.dart';
import 'package:weekly_menu_app/providers/shopping_list.dart';
import 'package:weekly_menu_app/widgets/shared/flutter_data_state_builder.dart';

import 'notifier.dart';
import '../../shared/empty_page_placeholder.dart';
import 'shopping_list_app_bar.dart';
import '../../../providers/user_preferences.dart';
import './shopping_list_tile.dart';
import './item_suggestion_text_field.dart';

class ShoppingListScreen extends HookConsumerWidget {
  const ShoppingListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProviderScope(
      overrides: [
        shoppingListScreenNotifierProvider.overrideWith(
            (ref) => ShoppingListStateNotifier(ref, ShoppingListState()))
      ],
      child: _ShoppingListScreen(key: key),
    );
  }
}

class _ShoppingListScreen extends HookConsumerWidget {
  _ShoppingListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(shoppingListScreenNotifierProvider.notifier);
    final newItemMode = ref.watch(shoppingListScreenNotifierProvider
        .select((state) => state.newItemMode));

    return ScaffoldMessenger(
      child: Scaffold(
        appBar: const ShoppingListAppBar(),
        floatingActionButton: newItemMode == false
            ? FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () => notifier.newItemMode = true,
              )
            : null,
        body: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.focusedChild?.unfocus();
            }
          },
          child: const _ShoppingListListView(),
        ),
      ),
    );
  }
}

class _ShoppingListListView extends HookConsumerWidget {
  const _ShoppingListListView({Key? key}) : super(key: key);

  static Map<String, List<ShoppingListItem>> _sortAndFoldShoppingListItem(
      List<ShoppingListItem> items) {
    final ordered = [...items]..sort((a, b) => (b.supermarketSectionName ?? '')
        .compareTo(a.supermarketSectionName ?? ''));

    return ordered.fold<Map<String, List<ShoppingListItem>>>(
        <String, List<ShoppingListItem>>{}, (pv, e) {
      final currentList = pv[e.supermarketSectionName ?? ''];
      if (currentList == null) {
        pv[e.supermarketSectionName ?? ''] = [e];
      } else {
        pv[e.supermarketSectionName ?? '']!.add(e);
      }
      return pv;
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(shoppingListItemRepositoryProvider);
    final shoppingListId =
        ref.watch(shoppingListProvider.select((s) => s?.idx));

    final notifier = ref.read(shoppingListScreenNotifierProvider.notifier);
    final expandChecked = ref.watch(shoppingListScreenNotifierProvider
        .select((state) => state.expandChecked));
    final selectedItems = ref.watch(shoppingListScreenNotifierProvider
        .select((state) => state.selectedItems));
    final selectionModeOn = ref.watch(shoppingListScreenNotifierProvider
        .select((state) => state.selectionModeOn));
    final newItemMode = ref.watch(shoppingListScreenNotifierProvider
        .select((state) => state.newItemMode));

    Widget _buildLoadingItem() {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    void handleTextFieldSubmission(
        Object? newValue, ShoppingListItem? previousItem, bool checked) {
      if (newValue == null) return;

      if (previousItem != null) {
        //UPDATE ITEM
        if (newValue is ShoppingListItem) {
          if (newValue.itemName.trim() != previousItem.itemName.trim()) {
            //selected item mismatch, delete the previous item before going further
            notifier.removeItemFromList(previousItem);
            notifier.setItemChecked(newValue, checked);
          } else {
            //item is the same so this is an update on checked field
            // or on uof
            notifier.updateItem(previousItem, newValue);
          }
        } else if (newValue is String) {
          notifier.updateItem(
              previousItem, previousItem.copyWith(itemName: newValue));
        } else if (newValue is Ingredient) {
          notifier.updateItem(
              previousItem, previousItem.copyWith(itemName: newValue.name));
        }
      } else {
        //CREATE ITEM
        if (newValue is String) {
          notifier.createShoppingListItemByIngredientName(newValue, checked);
        } else if (newValue is ShoppingListItem) {
          notifier.setItemChecked(newValue, checked);
        } else if (newValue is Ingredient) {
          notifier.createShoppingListItemByIngredient(newValue, checked);
        }
      }
    }

    Widget _buildAddItem() {
      return SliverList(
        delegate: SliverChildListDelegate.fixed(
          <Widget>[
            ListTile(
              leading: Icon(Icons.add),
              title: ItemSuggestionTextField(
                hintText: 'Add element...',
                autofocus: true,
                onFocusChanged: (hasFocus) {
                  if (hasFocus == false) {
                    notifier.newItemMode = false;
                  }
                },
                onSubmitted: (value) {
                  handleTextFieldSubmission(value, null, false);
                  notifier.newItemMode = false;
                },
              ),
            ),
            Divider(
              height: 0,
            )
          ],
        ),
      );
    }

    List<Widget> _buildCheckedList(List<ShoppingListItem> checkedItems) {
      final sliverSectionMap = _sortAndFoldShoppingListItem(checkedItems);

      final tilesAndSectionTitle = sliverSectionMap.entries
          .map((e) {
            final sectionColor = ref
                .read(supermarketSectionByNameProvider(
                    e.value[0].supermarketSectionName))
                ?.color;

            return <Widget>[
              _SupermarketSectionTitle(
                sectionColor: sectionColor,
                sectionName: e.key,
                textColor: Colors.grey,
              ),
              SliverList(
                delegate: SliverChildListDelegate.fixed(
                  e.value
                      .mapIndexed(
                        (idx, item) => ShoppingListItemTile(
                          item,
                          key: ValueKey("${idx}_${item.itemName.trim()}"),
                          editable: !selectionModeOn,
                          displayLeading: !selectionModeOn,
                          displayTrailing: !selectionModeOn,
                          dismissible: !selectionModeOn,
                          selected: selectedItems.contains(item),
                          onSubmitted: (value) {
                            handleTextFieldSubmission(value, item, true);
                          },
                          onTap: selectionModeOn
                              ? () => notifier.toggleItemToSelectedItems(item)
                              : null,
                          onLongPress: () =>
                              notifier.toggleItemToSelectedItems(item),
                          onCheckChange: (_) {
                            notifier.setItemChecked(item, false);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              behavior: SnackBarBehavior.floating,
                              content: Text('"${item.itemName}" checked'),
                              action: SnackBarAction(
                                label: 'Undo',
                                onPressed: () =>
                                    notifier.setItemChecked(item, true),
                              ),
                            ));
                          },
                          onDismiss: (_) => notifier.removeItemFromList(item),
                        ),
                      )
                      .toList(),
                ),
              ),
            ];
          })
          .expand((e) => e) //flat
          .toList();

      return [
        SliverAppBar(
          primary: false,
          pinned: true,
          title: Text("Checked (${checkedItems.length})"),
          forceElevated: true,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.grey.shade100,
          centerTitle: false,
          actions: <Widget>[
            if (expandChecked)
              IconButton(
                icon: Icon(Icons.expand_less),
                onPressed: () => notifier.expandChecked = false,
              ),
            if (!expandChecked)
              IconButton(
                icon: Icon(Icons.expand_more),
                onPressed: () => notifier.expandChecked = true,
              )
          ],
        ),
        if (expandChecked) ...tilesAndSectionTitle
      ];
    }

    List<Widget> _buildUncheckedList(List<ShoppingListItem> uncheckedItems) {
      final sliverSectionMap = _sortAndFoldShoppingListItem(uncheckedItems);

      return sliverSectionMap.entries
          .map((e) {
            final sectionColor = ref
                .read(supermarketSectionByNameProvider(
                    e.value[0].supermarketSectionName))
                ?.color;

            return <Widget>[
              _SupermarketSectionTitle(
                sectionColor: sectionColor,
                sectionName: e.key,
              ),
              SliverList(
                delegate: SliverChildListDelegate.fixed(
                  e.value
                      .mapIndexed(
                        (idx, item) => ShoppingListItemTile(
                          item,
                          key: ValueKey("${idx}_${item.itemName.trim()}"),
                          editable: !selectionModeOn,
                          displayLeading: !selectionModeOn,
                          displayTrailing: !selectionModeOn,
                          dismissible: !selectionModeOn,
                          selected: selectedItems.contains(item),
                          onSubmitted: (value) {
                            handleTextFieldSubmission(value, item, false);
                          },
                          onTap: selectionModeOn
                              ? () => notifier.toggleItemToSelectedItems(item)
                              : null,
                          onLongPress: () =>
                              notifier.toggleItemToSelectedItems(item),
                          onCheckChange: (_) {
                            notifier.setItemChecked(item, true);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              behavior: SnackBarBehavior.floating,
                              content: Text('"${item.itemName}" unchecked'),
                              action: SnackBarAction(
                                label: 'Undo',
                                onPressed: () =>
                                    notifier.setItemChecked(item, false),
                              ),
                            ));
                          },
                          onDismiss: (_) => notifier.removeItemFromList(item),
                        ),
                      )
                      .toList(),
                ),
              ),
            ];
          })
          .expand((e) => e) //flat
          .toList();
    }

    Widget _buildAddFirstItemFieldWrapper() {
      return CustomScrollView(
        slivers: [_buildAddItem()],
      );
    }

    Widget _buildNoElementsPage() {
      return EmptyPagePlaceholder(
        text: 'Your Shopping List Is Empty',
        icon: Icons.check_box,
      );
    }

    if (shoppingListId == null) {
      log("shopping list id is null");
      return _buildLoadingItem();
    }

    return RepositoryStreamBuilder<List<ShoppingListItem>>(
      stream:
          repository.stream(params: {SHOPPING_LIST_ID_PARAM: shoppingListId}),
      loading: _buildLoadingItem(),
      notFound: newItemMode
          ? _buildAddFirstItemFieldWrapper()
          : _buildNoElementsPage(),
      onRefresh: () async =>
          repository.reload(params: {SHOPPING_LIST_ID_PARAM: shoppingListId}),
      builder: (context, data) {
        //before this time shopping list is null
        log("build! ${data.length}");
        Future.delayed(Duration.zero, () => notifier.refreshItems(data));

        final allItems = data;

        final checkedItems = allItems.where((i) => i.checked).toList();
        final uncheckedItems = allItems.where((i) => !i.checked).toList();

        return CustomScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: <Widget>[
            if (newItemMode) _buildAddItem(),
            if (allItems.isNotEmpty) ..._buildUncheckedList(uncheckedItems),
            if (allItems.isNotEmpty) ..._buildCheckedList(checkedItems),
          ],
        );
      },
    );
  }
}

class _SupermarketSectionTitle extends StatelessWidget {
  static const SUPERMARKET_SECTION_TITLE_HEIGHT = 30.0;

  final String sectionName;
  final Color? sectionColor;
  final Color? textColor;

  const _SupermarketSectionTitle(
      {Key? key,
      this.sectionColor,
      this.textColor = Colors.black,
      this.sectionName = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SliverToBoxAdapter(
      child: Container(
        height: SUPERMARKET_SECTION_TITLE_HEIGHT,
        color: sectionColor?.withOpacity(0.1) ?? Colors.grey.withOpacity(0.1),
        child: Row(
          children: [
            Container(
              color: sectionColor,
              width: 6,
              height: SUPERMARKET_SECTION_TITLE_HEIGHT,
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(sectionName,
                  style: textTheme.subtitle2!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
