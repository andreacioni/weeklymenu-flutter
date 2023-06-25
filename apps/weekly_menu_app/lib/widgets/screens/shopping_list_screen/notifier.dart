import 'dart:developer';

import 'package:common/constants.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:data/repositories.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:collection/collection.dart';
import 'package:model/ingredient.dart';
import 'package:model/shopping_list.dart';
import 'package:model/user_preferences.dart';

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
  final ShoppingList? shoppingList;

  ShoppingListState({
    this.shoppingList,
    this.newItemMode = false,
    this.expandChecked = true,
    this.selectedItems = const <ShoppingListItem>[],
  });

  bool get selectionModeOn => selectedItems.isNotEmpty;

  List<ShoppingListItem> get allItems => shoppingList?.getAllItems ?? [];
  List<ShoppingListItem> get checkedItems =>
      shoppingList?.getCheckedItems ?? [];
  List<ShoppingListItem> get uncheckedItems =>
      shoppingList?.getUncheckedItems ?? [];
}

class ShoppingListStateNotifier extends StateNotifier<ShoppingListState> {
  final Ref ref;

  ShoppingListStateNotifier(this.ref, ShoppingListState state) : super(state);

  void initShoppingList(ShoppingList shoppingList) {
    Future.delayed(Duration.zero,
        () => state = state.copyWith(shoppingList: shoppingList));
  }

  set expandChecked(bool expandChecked) {
    state = state.copyWith(expandChecked: expandChecked);
  }

  set newItemMode(bool newItemMode) {
    state = state.copyWith(newItemMode: newItemMode);
  }

  Future<void> removeItemFromList(ShoppingListItem shoppingListItem) async {
    var shoppingList = state.shoppingList!;
    shoppingList = shoppingList.removeItemFromList(shoppingListItem);
    _saveShoppingList(shoppingList);
  }

  Future<void> setItemChecked(ShoppingListItem shopItem, bool checked) async {
    var shoppingList = state.shoppingList!;
    shoppingList = shoppingList.setChecked(shopItem, checked);
    _saveShoppingList(shoppingList);
  }

  Future<void> createShoppingListItemByIngredientName(
      String ingredientName, bool checked,
      [ShoppingListItem? previousItem]) async {
    if (ingredientName.isEmpty) {
      return;
    }
    var shoppingList = state.shoppingList!;
    if (previousItem != null &&
        previousItem.itemName.trim() != ingredientName.trim()) {
      //selected item mismatch, delete the previous item before going further
      shoppingList = shoppingList.removeItemFromList(previousItem);
    }

    final shopListItems = shoppingList.getAllItems;

    //retrieve the shopping list item (if any)
    var shoppingListItem = shopListItems
        .firstWhereOrNull((i) => i.itemName.trim() == ingredientName.trim());

    if (shoppingListItem != null && shoppingListItem.checked != checked) {
      //if the ingredient is already in the shopping list but in the wrong
      //checked state, just update the 'checked' state.
      return setItemChecked(shoppingListItem, checked);
    }

    if (previousItem != null) {
      shoppingListItem =
          previousItem.copyWith(checked: checked, itemName: ingredientName);
      shoppingList = shoppingList.updateItem(previousItem, shoppingListItem);
    } else {
      shoppingListItem =
          ShoppingListItem(itemName: ingredientName, checked: checked);

      shoppingList = shoppingList.addShoppingListItem(shoppingListItem);
    }

    _saveShoppingList(shoppingList);
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
    var shoppingList = state.shoppingList;

    for (final selectedItem in state.selectedItems) {
      if (selectedItem.supermarketSectionName != section?.name) {
        final newItem =
            selectedItem.copyWith(supermarketSectionName: section?.name);

        shoppingList = shoppingList?.updateItem(selectedItem, newItem);
      }
    }

    clearSelection();

    _saveShoppingList(shoppingList);
  }

  void removeSelectedShoppingItemFromList() async {
    var shoppingList = state.shoppingList;
    state.selectedItems.forEach((i) {
      shoppingList = shoppingList?.removeItemFromList(i);
    });
    clearSelection();
    _saveShoppingList(shoppingList);
  }

  void updateItem(ShoppingListItem previousItem, ShoppingListItem newItem) {
    final shoppingList = state.shoppingList?.updateItem(previousItem, newItem);
    _saveShoppingList(shoppingList);
  }

  void _saveShoppingList([ShoppingList? shoppingList]) {
    try {
      if (shoppingList != null) {
        ref
            .read(shoppingListRepositoryProvider)
            .save(shoppingList, params: {UPDATE_PARAM: true});
      } else if (state.shoppingList != null) {
        ref
            .read(shoppingListRepositoryProvider)
            .save(state.shoppingList!, params: {UPDATE_PARAM: true});
      }
    } catch (e) {
      log("failed to save shopping list");
    }
  }
}
