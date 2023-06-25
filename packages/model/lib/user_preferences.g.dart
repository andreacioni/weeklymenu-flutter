// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_preferences.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SupermarketSectionCWProxy {
  SupermarketSection color(Color? color);

  SupermarketSection name(String name);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SupermarketSection(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SupermarketSection(...).copyWith(id: 12, name: "My name")
  /// ````
  SupermarketSection call({
    Color? color,
    String? name,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSupermarketSection.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSupermarketSection.copyWith.fieldName(...)`
class _$SupermarketSectionCWProxyImpl implements _$SupermarketSectionCWProxy {
  final SupermarketSection _value;

  const _$SupermarketSectionCWProxyImpl(this._value);

  @override
  SupermarketSection color(Color? color) => this(color: color);

  @override
  SupermarketSection name(String name) => this(name: name);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SupermarketSection(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SupermarketSection(...).copyWith(id: 12, name: "My name")
  /// ````
  SupermarketSection call({
    Object? color = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
  }) {
    return SupermarketSection(
      color: color == const $CopyWithPlaceholder()
          ? _value.color
          // ignore: cast_nullable_to_non_nullable
          : color as Color?,
      name: name == const $CopyWithPlaceholder() || name == null
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
    );
  }
}

extension $SupermarketSectionCopyWith on SupermarketSection {
  /// Returns a callable class that can be used as follows: `instanceOfSupermarketSection.copyWith(...)` or like so:`instanceOfSupermarketSection.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SupermarketSectionCWProxy get copyWith =>
      _$SupermarketSectionCWProxyImpl(this);
}

abstract class _$UserPreferenceCWProxy {
  UserPreference idx(String? idx);

  UserPreference insertTimestamp(int? insertTimestamp);

  UserPreference owner(String? owner);

  UserPreference shoppingDays(List<int>? shoppingDays);

  UserPreference supermarketSections(
      List<SupermarketSection>? supermarketSections);

  UserPreference unitsOfMeasure(List<String>? unitsOfMeasure);

  UserPreference updateTimestamp(int? updateTimestamp);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UserPreference(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UserPreference(...).copyWith(id: 12, name: "My name")
  /// ````
  UserPreference call({
    String? idx,
    int? insertTimestamp,
    String? owner,
    List<int>? shoppingDays,
    List<SupermarketSection>? supermarketSections,
    List<String>? unitsOfMeasure,
    int? updateTimestamp,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfUserPreference.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfUserPreference.copyWith.fieldName(...)`
class _$UserPreferenceCWProxyImpl implements _$UserPreferenceCWProxy {
  final UserPreference _value;

  const _$UserPreferenceCWProxyImpl(this._value);

  @override
  UserPreference idx(String? idx) => this(idx: idx);

  @override
  UserPreference insertTimestamp(int? insertTimestamp) =>
      this(insertTimestamp: insertTimestamp);

  @override
  UserPreference owner(String? owner) => this(owner: owner);

  @override
  UserPreference shoppingDays(List<int>? shoppingDays) =>
      this(shoppingDays: shoppingDays);

  @override
  UserPreference supermarketSections(
          List<SupermarketSection>? supermarketSections) =>
      this(supermarketSections: supermarketSections);

  @override
  UserPreference unitsOfMeasure(List<String>? unitsOfMeasure) =>
      this(unitsOfMeasure: unitsOfMeasure);

  @override
  UserPreference updateTimestamp(int? updateTimestamp) =>
      this(updateTimestamp: updateTimestamp);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UserPreference(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UserPreference(...).copyWith(id: 12, name: "My name")
  /// ````
  UserPreference call({
    Object? idx = const $CopyWithPlaceholder(),
    Object? insertTimestamp = const $CopyWithPlaceholder(),
    Object? owner = const $CopyWithPlaceholder(),
    Object? shoppingDays = const $CopyWithPlaceholder(),
    Object? supermarketSections = const $CopyWithPlaceholder(),
    Object? unitsOfMeasure = const $CopyWithPlaceholder(),
    Object? updateTimestamp = const $CopyWithPlaceholder(),
  }) {
    return UserPreference(
      idx: idx == const $CopyWithPlaceholder()
          ? _value.idx
          // ignore: cast_nullable_to_non_nullable
          : idx as String?,
      insertTimestamp: insertTimestamp == const $CopyWithPlaceholder()
          ? _value.insertTimestamp
          // ignore: cast_nullable_to_non_nullable
          : insertTimestamp as int?,
      owner: owner == const $CopyWithPlaceholder()
          ? _value.owner
          // ignore: cast_nullable_to_non_nullable
          : owner as String?,
      shoppingDays: shoppingDays == const $CopyWithPlaceholder()
          ? _value.shoppingDays
          // ignore: cast_nullable_to_non_nullable
          : shoppingDays as List<int>?,
      supermarketSections: supermarketSections == const $CopyWithPlaceholder()
          ? _value.supermarketSections
          // ignore: cast_nullable_to_non_nullable
          : supermarketSections as List<SupermarketSection>?,
      unitsOfMeasure: unitsOfMeasure == const $CopyWithPlaceholder()
          ? _value.unitsOfMeasure
          // ignore: cast_nullable_to_non_nullable
          : unitsOfMeasure as List<String>?,
      updateTimestamp: updateTimestamp == const $CopyWithPlaceholder()
          ? _value.updateTimestamp
          // ignore: cast_nullable_to_non_nullable
          : updateTimestamp as int?,
    );
  }
}

extension $UserPreferenceCopyWith on UserPreference {
  /// Returns a callable class that can be used as follows: `instanceOfUserPreference.copyWith(...)` or like so:`instanceOfUserPreference.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UserPreferenceCWProxy get copyWith => _$UserPreferenceCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupermarketSection _$SupermarketSectionFromJson(Map json) => SupermarketSection(
      name: json['name'] as String,
      color: const ColorConverter().fromJson(json['color'] as int?),
    );

Map<String, dynamic> _$SupermarketSectionToJson(SupermarketSection instance) {
  final val = <String, dynamic>{
    'name': instance.name,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('color', const ColorConverter().toJson(instance.color));
  return val;
}

UserPreference _$UserPreferenceFromJson(Map json) => UserPreference(
      idx: json['_id'] as String?,
      insertTimestamp: json['insert_timestamp'] as int?,
      updateTimestamp: json['update_timestamp'] as int?,
      shoppingDays: (json['shopping_days'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
      supermarketSections: (json['supermarket_sections'] as List<dynamic>?)
          ?.map((e) =>
              SupermarketSection.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      unitsOfMeasure: (json['units_of_measure'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [
            'pcs',
            'g',
            'Kg',
            'gr',
            'cup',
            'tsp',
            'tbs',
            'L',
            'ml',
            'dl',
            'cl',
            'm',
            'cm',
            'mm',
            'glass',
            'lb',
            'oz',
            'pt',
            'gl',
            'qt'
          ],
    );

Map<String, dynamic> _$UserPreferenceToJson(UserPreference instance) {
  final val = <String, dynamic>{
    '_id': instance.idx,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('insert_timestamp', instance.insertTimestamp);
  writeNotNull('update_timestamp', instance.updateTimestamp);
  writeNotNull('shopping_days', instance.shoppingDays);
  writeNotNull('supermarket_sections',
      instance.supermarketSections?.map((e) => e.toJson()).toList());
  writeNotNull('units_of_measure', instance.unitsOfMeasure);
  return val;
}
