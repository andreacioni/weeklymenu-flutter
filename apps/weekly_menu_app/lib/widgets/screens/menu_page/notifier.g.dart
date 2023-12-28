// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifier.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$MenuScreenStateCWProxy {
  MenuScreenState editMode(bool editMode);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MenuScreenState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MenuScreenState(...).copyWith(id: 12, name: "My name")
  /// ````
  MenuScreenState call({
    bool? editMode,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfMenuScreenState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfMenuScreenState.copyWith.fieldName(...)`
class _$MenuScreenStateCWProxyImpl implements _$MenuScreenStateCWProxy {
  final MenuScreenState _value;

  const _$MenuScreenStateCWProxyImpl(this._value);

  @override
  MenuScreenState editMode(bool editMode) => this(editMode: editMode);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MenuScreenState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MenuScreenState(...).copyWith(id: 12, name: "My name")
  /// ````
  MenuScreenState call({
    Object? editMode = const $CopyWithPlaceholder(),
  }) {
    return MenuScreenState(
      editMode: editMode == const $CopyWithPlaceholder() || editMode == null
          ? _value.editMode
          // ignore: cast_nullable_to_non_nullable
          : editMode as bool,
    );
  }
}

extension $MenuScreenStateCopyWith on MenuScreenState {
  /// Returns a callable class that can be used as follows: `instanceOfMenuScreenState.copyWith(...)` or like so:`instanceOfMenuScreenState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$MenuScreenStateCWProxy get copyWith => _$MenuScreenStateCWProxyImpl(this);
}
