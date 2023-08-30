// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'import_from_menu_screen.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$_ImportFromMenuScreenStateCWProxy {
  _ImportFromMenuScreenState dailyMenuList(List<DailyMenu> dailyMenuList);

  _ImportFromMenuScreenState selectedRecipes(
      Map<DailyMenu, Set<Recipe>> selectedRecipes);

  _ImportFromMenuScreenState shoppingListItemSelection(
      Map<ShoppingListItem, bool> shoppingListItemSelection);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `_ImportFromMenuScreenState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// _ImportFromMenuScreenState(...).copyWith(id: 12, name: "My name")
  /// ````
  _ImportFromMenuScreenState call({
    List<DailyMenu>? dailyMenuList,
    Map<DailyMenu, Set<Recipe>>? selectedRecipes,
    Map<ShoppingListItem, bool>? shoppingListItemSelection,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOf_ImportFromMenuScreenState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOf_ImportFromMenuScreenState.copyWith.fieldName(...)`
class _$_ImportFromMenuScreenStateCWProxyImpl
    implements _$_ImportFromMenuScreenStateCWProxy {
  final _ImportFromMenuScreenState _value;

  const _$_ImportFromMenuScreenStateCWProxyImpl(this._value);

  @override
  _ImportFromMenuScreenState dailyMenuList(List<DailyMenu> dailyMenuList) =>
      this(dailyMenuList: dailyMenuList);

  @override
  _ImportFromMenuScreenState selectedRecipes(
          Map<DailyMenu, Set<Recipe>> selectedRecipes) =>
      this(selectedRecipes: selectedRecipes);

  @override
  _ImportFromMenuScreenState shoppingListItemSelection(
          Map<ShoppingListItem, bool> shoppingListItemSelection) =>
      this(shoppingListItemSelection: shoppingListItemSelection);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `_ImportFromMenuScreenState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// _ImportFromMenuScreenState(...).copyWith(id: 12, name: "My name")
  /// ````
  _ImportFromMenuScreenState call({
    Object? dailyMenuList = const $CopyWithPlaceholder(),
    Object? selectedRecipes = const $CopyWithPlaceholder(),
    Object? shoppingListItemSelection = const $CopyWithPlaceholder(),
  }) {
    return _ImportFromMenuScreenState(
      dailyMenuList:
          dailyMenuList == const $CopyWithPlaceholder() || dailyMenuList == null
              ? _value.dailyMenuList
              // ignore: cast_nullable_to_non_nullable
              : dailyMenuList as List<DailyMenu>,
      selectedRecipes: selectedRecipes == const $CopyWithPlaceholder() ||
              selectedRecipes == null
          ? _value.selectedRecipes
          // ignore: cast_nullable_to_non_nullable
          : selectedRecipes as Map<DailyMenu, Set<Recipe>>,
      shoppingListItemSelection:
          shoppingListItemSelection == const $CopyWithPlaceholder() ||
                  shoppingListItemSelection == null
              ? _value.shoppingListItemSelection
              // ignore: cast_nullable_to_non_nullable
              : shoppingListItemSelection as Map<ShoppingListItem, bool>,
    );
  }
}

extension _$_ImportFromMenuScreenStateCopyWith on _ImportFromMenuScreenState {
  /// Returns a callable class that can be used as follows: `instanceOf_ImportFromMenuScreenState.copyWith(...)` or like so:`instanceOf_ImportFromMenuScreenState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$_ImportFromMenuScreenStateCWProxy get copyWith =>
      _$_ImportFromMenuScreenStateCWProxyImpl(this);
}
