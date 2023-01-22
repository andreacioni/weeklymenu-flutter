// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifier.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ShoppingListStateCWProxy {
  ShoppingListState expandChecked(bool expandChecked);

  ShoppingListState newItemMode(bool newItemMode);

  ShoppingListState selectedItems(List<ShoppingListItem> selectedItems);

  ShoppingListState shoppingList(ShoppingList? shoppingList);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ShoppingListState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ShoppingListState(...).copyWith(id: 12, name: "My name")
  /// ````
  ShoppingListState call({
    bool? expandChecked,
    bool? newItemMode,
    List<ShoppingListItem>? selectedItems,
    ShoppingList? shoppingList,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfShoppingListState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfShoppingListState.copyWith.fieldName(...)`
class _$ShoppingListStateCWProxyImpl implements _$ShoppingListStateCWProxy {
  final ShoppingListState _value;

  const _$ShoppingListStateCWProxyImpl(this._value);

  @override
  ShoppingListState expandChecked(bool expandChecked) =>
      this(expandChecked: expandChecked);

  @override
  ShoppingListState newItemMode(bool newItemMode) =>
      this(newItemMode: newItemMode);

  @override
  ShoppingListState selectedItems(List<ShoppingListItem> selectedItems) =>
      this(selectedItems: selectedItems);

  @override
  ShoppingListState shoppingList(ShoppingList? shoppingList) =>
      this(shoppingList: shoppingList);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ShoppingListState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ShoppingListState(...).copyWith(id: 12, name: "My name")
  /// ````
  ShoppingListState call({
    Object? expandChecked = const $CopyWithPlaceholder(),
    Object? newItemMode = const $CopyWithPlaceholder(),
    Object? selectedItems = const $CopyWithPlaceholder(),
    Object? shoppingList = const $CopyWithPlaceholder(),
  }) {
    return ShoppingListState(
      expandChecked:
          expandChecked == const $CopyWithPlaceholder() || expandChecked == null
              ? _value.expandChecked
              // ignore: cast_nullable_to_non_nullable
              : expandChecked as bool,
      newItemMode:
          newItemMode == const $CopyWithPlaceholder() || newItemMode == null
              ? _value.newItemMode
              // ignore: cast_nullable_to_non_nullable
              : newItemMode as bool,
      selectedItems:
          selectedItems == const $CopyWithPlaceholder() || selectedItems == null
              ? _value.selectedItems
              // ignore: cast_nullable_to_non_nullable
              : selectedItems as List<ShoppingListItem>,
      shoppingList: shoppingList == const $CopyWithPlaceholder()
          ? _value.shoppingList
          // ignore: cast_nullable_to_non_nullable
          : shoppingList as ShoppingList?,
    );
  }
}

extension $ShoppingListStateCopyWith on ShoppingListState {
  /// Returns a callable class that can be used as follows: `instanceOfShoppingListState.copyWith(...)` or like so:`instanceOfShoppingListState.copyWith.fieldName(...)`.
  _$ShoppingListStateCWProxy get copyWith =>
      _$ShoppingListStateCWProxyImpl(this);
}
