// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifier.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$RecipeScreenStateCWProxy {
  RecipeScreenState recipeOriginator(RecipeOriginator recipeOriginator);

  RecipeScreenState editEnabled(bool editEnabled);

  RecipeScreenState newIngredientMode(bool newIngredientMode);

  RecipeScreenState isNewRecipe(bool isNewRecipe);

  RecipeScreenState newStepMode(bool newStepMode);

  RecipeScreenState currentTab(int currentTab);

  RecipeScreenState servingsMultiplier(int? servingsMultiplier);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RecipeScreenState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RecipeScreenState(...).copyWith(id: 12, name: "My name")
  /// ````
  RecipeScreenState call({
    RecipeOriginator? recipeOriginator,
    bool? editEnabled,
    bool? newIngredientMode,
    bool? isNewRecipe,
    bool? newStepMode,
    int? currentTab,
    int? servingsMultiplier,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfRecipeScreenState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfRecipeScreenState.copyWith.fieldName(...)`
class _$RecipeScreenStateCWProxyImpl implements _$RecipeScreenStateCWProxy {
  const _$RecipeScreenStateCWProxyImpl(this._value);

  final RecipeScreenState _value;

  @override
  RecipeScreenState recipeOriginator(RecipeOriginator recipeOriginator) =>
      this(recipeOriginator: recipeOriginator);

  @override
  RecipeScreenState editEnabled(bool editEnabled) =>
      this(editEnabled: editEnabled);

  @override
  RecipeScreenState newIngredientMode(bool newIngredientMode) =>
      this(newIngredientMode: newIngredientMode);

  @override
  RecipeScreenState isNewRecipe(bool isNewRecipe) =>
      this(isNewRecipe: isNewRecipe);

  @override
  RecipeScreenState newStepMode(bool newStepMode) =>
      this(newStepMode: newStepMode);

  @override
  RecipeScreenState currentTab(int currentTab) => this(currentTab: currentTab);

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
    Object? recipeOriginator = const $CopyWithPlaceholder(),
    Object? editEnabled = const $CopyWithPlaceholder(),
    Object? newIngredientMode = const $CopyWithPlaceholder(),
    Object? isNewRecipe = const $CopyWithPlaceholder(),
    Object? newStepMode = const $CopyWithPlaceholder(),
    Object? currentTab = const $CopyWithPlaceholder(),
    Object? servingsMultiplier = const $CopyWithPlaceholder(),
  }) {
    return RecipeScreenState(
      recipeOriginator: recipeOriginator == const $CopyWithPlaceholder() ||
              recipeOriginator == null
          ? _value.recipeOriginator
          // ignore: cast_nullable_to_non_nullable
          : recipeOriginator as RecipeOriginator,
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
      isNewRecipe:
          isNewRecipe == const $CopyWithPlaceholder() || isNewRecipe == null
              ? _value.isNewRecipe
              // ignore: cast_nullable_to_non_nullable
              : isNewRecipe as bool,
      newStepMode:
          newStepMode == const $CopyWithPlaceholder() || newStepMode == null
              ? _value.newStepMode
              // ignore: cast_nullable_to_non_nullable
              : newStepMode as bool,
      currentTab:
          currentTab == const $CopyWithPlaceholder() || currentTab == null
              ? _value.currentTab
              // ignore: cast_nullable_to_non_nullable
              : currentTab as int,
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
