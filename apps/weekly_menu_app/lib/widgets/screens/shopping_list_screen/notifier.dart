import 'package:common/constants.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:data/flutter_data/shopping_list.dart';
import 'package:data/repositories.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:collection/collection.dart';
import 'package:model/ingredient.dart';
import 'package:model/shopping_list.dart';
import 'package:model/user_preferences.dart';
import 'package:weekly_menu_app/providers/shopping_list.dart';

part 'notifier.g.dart';

final shoppingListScreenNotifierProvider = StateNotifierProvider.autoDispose<
    ShoppingListStateNotifier,
    ShoppingListState>((ref) => throw UnimplementedError());

@immutable
@CopyWith()
class ShoppingListState {
  final bool newItemMode;
  final bool expandChecked;
  final List<ShoppingListItem> selectedItems;
  final List<ShoppingListItem> allItems;

  ShoppingListState({
    this.allItems = const <ShoppingListItem>[],
    this.newItemMode = false,
    this.expandChecked = true,
    this.selectedItems = const <ShoppingListItem>[],
  });

  bool get selectionModeOn => selectedItems.isNotEmpty;

  List<ShoppingListItem> get checkedItems =>
      allItems.where((e) => e.checked).toList();
  List<ShoppingListItem> get uncheckedItems =>
      allItems.where((e) => !e.checked).toList();
}

class ShoppingListStateNotifier extends StateNotifier<ShoppingListState> {
  final Ref ref;

  ShoppingListStateNotifier(this.ref, ShoppingListState state) : super(state);

  set expandChecked(bool expandChecked) {
    state = state.copyWith(expandChecked: expandChecked);
  }

  set newItemMode(bool newItemMode) {
    state = state.copyWith(newItemMode: newItemMode);
  }

  Future<void> removeItemFromList(ShoppingListItem shoppingListItem) async {
    final shoppingListId = ref.read(shoppingListProvider)!.idx;
    ref.read(shoppingListItemRepositoryProvider).delete(
        shoppingListItem.itemName,
        params: {SHOPPING_LIST_ID_PARAM: shoppingListId});
  }

  void setItemChecked(ShoppingListItem shopItem, bool checked) {
    final shoppingListId = ref.read(shoppingListProvider)!.idx;
    shopItem = shopItem.copyWith(checked: checked);
    ref.read(shoppingListItemRepositoryProvider).save(shopItem,
        params: {UPDATE_PARAM: true, SHOPPING_LIST_ID_PARAM: shoppingListId});
  }

  Future<void> createShoppingListItemByIngredientName(
      String ingredientName, bool checked,
      [ShoppingListItem? previousItem]) async {
    if (ingredientName.isEmpty) {
      return;
    }

    final shoppingListId = ref.read(shoppingListProvider)!.idx;
    final repository = ref.read(shoppingListItemRepositoryProvider);

    if (previousItem != null &&
        previousItem.itemName.trim() != ingredientName.trim()) {
      //selected item mismatch, delete the previous item before going further
      repository.delete(previousItem.itemName,
          params: {SHOPPING_LIST_ID_PARAM: shoppingListId});
    }

    final shopListItems = state.allItems;

    //retrieve the shopping list item (if any)
    var shoppingListItem = shopListItems
        .firstWhereOrNull((i) => i.itemName.trim() == ingredientName.trim());

    if (shoppingListItem != null && shoppingListItem.checked != checked) {
      //if the ingredient is already in the shopping list but in the wrong
      //checked state, just update the 'checked' state.
      return setItemChecked(shoppingListItem, checked);
    }

    if (previousItem != null) {
      //old item
      shoppingListItem =
          previousItem.copyWith(checked: checked, itemName: ingredientName);
      updateItem(previousItem, shoppingListItem);
    } else {
      //new item
      shoppingListItem =
          ShoppingListItem(itemName: ingredientName, checked: checked);

      repository.save(shoppingListItem, params: {
        UPDATE_PARAM: false,
        SHOPPING_LIST_ID_PARAM: shoppingListId
      });
    }
  }

  Future<void> createShoppingListItemByIngredient(
      Ingredient ingredient, bool checked,
      [ShoppingListItem? previousItem]) async {
    return createShoppingListItemByIngredientName(
        ingredient.name, checked, previousItem);
  }

  void toggleItemToSelectedItems(ShoppingListItem item) {
    if (!state.selectedItems.contains(item)) {
      state = state.copyWith(selectedItems: [...state.selectedItems, item]);
    } else {
      state = state.copyWith(selectedItems: [
        ...state.selectedItems..removeWhere((e) => e == item)
      ]);
    }
  }

  void clearSelection() {
    state = state.copyWith(selectedItems: []);
  }

  Future<void> setSupermarketSectionOnSelectedItems(
      SupermarketSection? section) async {
    final shoppingListId = ref.read(shoppingListProvider)!.idx;

    for (final selectedItem in state.selectedItems) {
      if (selectedItem.supermarketSectionName != section?.name) {
        final newItem =
            selectedItem.copyWith(supermarketSectionName: section?.name);
        ref.read(shoppingListItemRepositoryProvider).save(newItem, params: {
          UPDATE_PARAM: true,
          SHOPPING_LIST_ID_PARAM: shoppingListId
        });
      }
    }

    clearSelection();
  }

  void removeSelectedShoppingItemFromList() async {
    final shoppingListId = ref.read(shoppingListProvider)!.idx;
    state.selectedItems.forEach((item) {
      ref.read(shoppingListItemRepositoryProvider).save(item,
          params: {UPDATE_PARAM: true, SHOPPING_LIST_ID_PARAM: shoppingListId});
    });
    clearSelection();
  }

  Future<void> updateItem(
      ShoppingListItem previousItem, ShoppingListItem newItem) async {
    final shoppingListId = ref.read(shoppingListProvider)!.idx;

    if (previousItem.itemName != newItem.itemName) {
      ref.read(shoppingListItemRepositoryProvider).delete(previousItem.itemName,
          params: {UPDATE_PARAM: true, SHOPPING_LIST_ID_PARAM: shoppingListId});
    }

    ref.read(shoppingListItemRepositoryProvider).save(newItem,
        params: {UPDATE_PARAM: true, SHOPPING_LIST_ID_PARAM: shoppingListId});
  }

  void refreshItems(List<ShoppingListItem> items) {
    state = state.copyWith(allItems: items);
  }
}
