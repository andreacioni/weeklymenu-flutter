// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifier.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ShoppingListStateCWProxy {
  ShoppingListState allItems(List<ShoppingListItem> allItems);

  ShoppingListState newItemMode(bool newItemMode);

  ShoppingListState expandChecked(bool expandChecked);

  ShoppingListState selectedItems(List<ShoppingListItem> selectedItems);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ShoppingListState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ShoppingListState(...).copyWith(id: 12, name: "My name")
  /// ````
  ShoppingListState call({
    List<ShoppingListItem>? allItems,
    bool? newItemMode,
    bool? expandChecked,
    List<ShoppingListItem>? selectedItems,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfShoppingListState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfShoppingListState.copyWith.fieldName(...)`
class _$ShoppingListStateCWProxyImpl implements _$ShoppingListStateCWProxy {
  const _$ShoppingListStateCWProxyImpl(this._value);

  final ShoppingListState _value;

  @override
  ShoppingListState allItems(List<ShoppingListItem> allItems) =>
      this(allItems: allItems);

  @override
  ShoppingListState newItemMode(bool newItemMode) =>
      this(newItemMode: newItemMode);

  @override
  ShoppingListState expandChecked(bool expandChecked) =>
      this(expandChecked: expandChecked);

  @override
  ShoppingListState selectedItems(List<ShoppingListItem> selectedItems) =>
      this(selectedItems: selectedItems);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ShoppingListState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ShoppingListState(...).copyWith(id: 12, name: "My name")
  /// ````
  ShoppingListState call({
    Object? allItems = const $CopyWithPlaceholder(),
    Object? newItemMode = const $CopyWithPlaceholder(),
    Object? expandChecked = const $CopyWithPlaceholder(),
    Object? selectedItems = const $CopyWithPlaceholder(),
  }) {
    return ShoppingListState(
      allItems: allItems == const $CopyWithPlaceholder() || allItems == null
          ? _value.allItems
          // ignore: cast_nullable_to_non_nullable
          : allItems as List<ShoppingListItem>,
      newItemMode:
          newItemMode == const $CopyWithPlaceholder() || newItemMode == null
              ? _value.newItemMode
              // ignore: cast_nullable_to_non_nullable
              : newItemMode as bool,
      expandChecked:
          expandChecked == const $CopyWithPlaceholder() || expandChecked == null
              ? _value.expandChecked
              // ignore: cast_nullable_to_non_nullable
              : expandChecked as bool,
      selectedItems:
          selectedItems == const $CopyWithPlaceholder() || selectedItems == null
              ? _value.selectedItems
              // ignore: cast_nullable_to_non_nullable
              : selectedItems as List<ShoppingListItem>,
    );
  }
}

extension $ShoppingListStateCopyWith on ShoppingListState {
  /// Returns a callable class that can be used as follows: `instanceOfShoppingListState.copyWith(...)` or like so:`instanceOfShoppingListState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ShoppingListStateCWProxy get copyWith =>
      _$ShoppingListStateCWProxyImpl(this);
}
