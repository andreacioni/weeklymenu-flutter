// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifier.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$RecipeScreenStateCWProxy {
  RecipeScreenState editEnabled(bool editEnabled);

  RecipeScreenState newIngredientMode(bool newIngredientMode);

  RecipeScreenState recipeOriginator(RecipeOriginator? recipeOriginator);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RecipeScreenState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RecipeScreenState(...).copyWith(id: 12, name: "My name")
  /// ````
  RecipeScreenState call({
    bool? editEnabled,
    bool? newIngredientMode,
    RecipeOriginator? recipeOriginator,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfRecipeScreenState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfRecipeScreenState.copyWith.fieldName(...)`
class _$RecipeScreenStateCWProxyImpl implements _$RecipeScreenStateCWProxy {
  final RecipeScreenState _value;

  const _$RecipeScreenStateCWProxyImpl(this._value);

  @override
  RecipeScreenState editEnabled(bool editEnabled) =>
      this(editEnabled: editEnabled);

  @override
  RecipeScreenState newIngredientMode(bool newIngredientMode) =>
      this(newIngredientMode: newIngredientMode);

  @override
  RecipeScreenState recipeOriginator(RecipeOriginator? recipeOriginator) =>
      this(recipeOriginator: recipeOriginator);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RecipeScreenState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RecipeScreenState(...).copyWith(id: 12, name: "My name")
  /// ````
  RecipeScreenState call({
    Object? editEnabled = const $CopyWithPlaceholder(),
    Object? newIngredientMode = const $CopyWithPlaceholder(),
    Object? recipeOriginator = const $CopyWithPlaceholder(),
  }) {
    return RecipeScreenState(
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
      recipeOriginator: recipeOriginator == const $CopyWithPlaceholder()
          ? _value.recipeOriginator
          // ignore: cast_nullable_to_non_nullable
          : recipeOriginator as RecipeOriginator?,
    );
  }
}

extension $RecipeScreenStateCopyWith on RecipeScreenState {
  /// Returns a callable class that can be used as follows: `instanceOfRecipeScreenState.copyWith(...)` or like so:`instanceOfRecipeScreenState.copyWith.fieldName(...)`.
  _$RecipeScreenStateCWProxy get copyWith =>
      _$RecipeScreenStateCWProxyImpl(this);
}
