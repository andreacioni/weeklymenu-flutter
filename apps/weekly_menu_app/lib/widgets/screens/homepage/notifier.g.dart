// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifier.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$HomepageScreenStateCWProxy {
  HomepageScreenState isLoading(bool isLoading);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `HomepageScreenState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// HomepageScreenState(...).copyWith(id: 12, name: "My name")
  /// ````
  HomepageScreenState call({
    bool? isLoading,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfHomepageScreenState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfHomepageScreenState.copyWith.fieldName(...)`
class _$HomepageScreenStateCWProxyImpl implements _$HomepageScreenStateCWProxy {
  final HomepageScreenState _value;

  const _$HomepageScreenStateCWProxyImpl(this._value);

  @override
  HomepageScreenState isLoading(bool isLoading) => this(isLoading: isLoading);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `HomepageScreenState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// HomepageScreenState(...).copyWith(id: 12, name: "My name")
  /// ````
  HomepageScreenState call({
    Object? isLoading = const $CopyWithPlaceholder(),
  }) {
    return HomepageScreenState(
      isLoading: isLoading == const $CopyWithPlaceholder() || isLoading == null
          ? _value.isLoading
          // ignore: cast_nullable_to_non_nullable
          : isLoading as bool,
    );
  }
}

extension $HomepageScreenStateCopyWith on HomepageScreenState {
  /// Returns a callable class that can be used as follows: `instanceOfHomepageScreenState.copyWith(...)` or like so:`instanceOfHomepageScreenState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$HomepageScreenStateCWProxy get copyWith =>
      _$HomepageScreenStateCWProxyImpl(this);
}
