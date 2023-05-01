// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifier.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$RecipeScreenStateCWProxy {
  RecipeScreenState currentTab(int currentTab);

  RecipeScreenState editEnabled(bool editEnabled);

  RecipeScreenState newIngredientMode(bool newIngredientMode);

  RecipeScreenState newStepMode(bool newStepMode);

  RecipeScreenState recipeOriginator(RecipeOriginator recipeOriginator);

  RecipeScreenState servingsMultiplier(int? servingsMultiplier);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RecipeScreenState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RecipeScreenState(...).copyWith(id: 12, name: "My name")
  /// ````
  RecipeScreenState call({
    int? currentTab,
    bool? editEnabled,
    bool? newIngredientMode,
    bool? newStepMode,
    RecipeOriginator? recipeOriginator,
    int? servingsMultiplier,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfRecipeScreenState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfRecipeScreenState.copyWith.fieldName(...)`
class _$RecipeScreenStateCWProxyImpl implements _$RecipeScreenStateCWProxy {
  final RecipeScreenState _value;

  const _$RecipeScreenStateCWProxyImpl(this._value);

  @override
  RecipeScreenState currentTab(int currentTab) => this(currentTab: currentTab);

  @override
  RecipeScreenState editEnabled(bool editEnabled) =>
      this(editEnabled: editEnabled);

  @override
  RecipeScreenState newIngredientMode(bool newIngredientMode) =>
      this(newIngredientMode: newIngredientMode);

  @override
  RecipeScreenState newStepMode(bool newStepMode) =>
      this(newStepMode: newStepMode);

  @override
  RecipeScreenState recipeOriginator(RecipeOriginator recipeOriginator) =>
      this(recipeOriginator: recipeOriginator);

  @override
  RecipeScreenState servingsMultiplier(int? servingsMultiplier) =>
      this(servingsMultiplier: servingsMultiplier);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RecipeScreenState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RecipeScreenState(...).copyWith(id: 12, name: "My name")
  /// ````
  RecipeScreenState call({
    Object? currentTab = const $CopyWithPlaceholder(),
    Object? editEnabled = const $CopyWithPlaceholder(),
    Object? newIngredientMode = const $CopyWithPlaceholder(),
    Object? newStepMode = const $CopyWithPlaceholder(),
    Object? recipeOriginator = const $CopyWithPlaceholder(),
    Object? servingsMultiplier = const $CopyWithPlaceholder(),
  }) {
    return RecipeScreenState(
      currentTab:
          currentTab == const $CopyWithPlaceholder() || currentTab == null
              ? _value.currentTab
              // ignore: cast_nullable_to_non_nullable
              : currentTab as int,
      editEnabled:
          editEnabled == const $CopyWithPlaceholder() || editEnabled == null
              ? _value.editEnabled
              // ignore: cast_nullable_to_non_nullable
              : editEnabled as bool,
      newIngredientMode: newIngredientMode == const $CopyWithPlaceholder() ||
              newIngredientMode == null
          ? _value.newIngredientMode
          // ignore: cast_nullable_to_non_nullable
          : newIngredientMode as bool,
      newStepMode:
          newStepMode == const $CopyWithPlaceholder() || newStepMode == null
              ? _value.newStepMode
              // ignore: cast_nullable_to_non_nullable
              : newStepMode as bool,
      recipeOriginator: recipeOriginator == const $CopyWithPlaceholder() ||
              recipeOriginator == null
          ? _value.recipeOriginator
          // ignore: cast_nullable_to_non_nullable
          : recipeOriginator as RecipeOriginator,
      servingsMultiplier: servingsMultiplier == const $CopyWithPlaceholder()
          ? _value.servingsMultiplier
          // ignore: cast_nullable_to_non_nullable
          : servingsMultiplier as int?,
    );
  }
}

extension $RecipeScreenStateCopyWith on RecipeScreenState {
  /// Returns a callable class that can be used as follows: `instanceOfRecipeScreenState.copyWith(...)` or like so:`instanceOfRecipeScreenState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$RecipeScreenStateCWProxy get copyWith =>
      _$RecipeScreenStateCWProxyImpl(this);
}
