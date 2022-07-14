// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_preferences.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UserPreferenceCWProxy {
  UserPreference id(String? id);

  UserPreference insertTimestamp(int? insertTimestamp);

  UserPreference owner(String? owner);

  UserPreference shoppingDays(List<int>? shoppingDays);

  UserPreference supermarketSections(
      List<SupermarketSection>? supermarketSections);

  UserPreference updateTimestamp(int? updateTimestamp);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UserPreference(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UserPreference(...).copyWith(id: 12, name: "My name")
  /// ````
  UserPreference call({
    String? id,
    int? insertTimestamp,
    String? owner,
    List<int>? shoppingDays,
    List<SupermarketSection>? supermarketSections,
    int? updateTimestamp,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfUserPreference.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfUserPreference.copyWith.fieldName(...)`
class _$UserPreferenceCWProxyImpl implements _$UserPreferenceCWProxy {
  final UserPreference _value;

  const _$UserPreferenceCWProxyImpl(this._value);

  @override
  UserPreference id(String? id) => this(id: id);

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
    Object? id = const $CopyWithPlaceholder(),
    Object? insertTimestamp = const $CopyWithPlaceholder(),
    Object? owner = const $CopyWithPlaceholder(),
    Object? shoppingDays = const $CopyWithPlaceholder(),
    Object? supermarketSections = const $CopyWithPlaceholder(),
    Object? updateTimestamp = const $CopyWithPlaceholder(),
  }) {
    return UserPreference(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String?,
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
      updateTimestamp: updateTimestamp == const $CopyWithPlaceholder()
          ? _value.updateTimestamp
          // ignore: cast_nullable_to_non_nullable
          : updateTimestamp as int?,
    );
  }
}

extension $UserPreferenceCopyWith on UserPreference {
  /// Returns a callable class that can be used as follows: `instanceOfUserPreference.copyWith(...)` or like so:`instanceOfUserPreference.copyWith.fieldName(...)`.
  _$UserPreferenceCWProxy get copyWith => _$UserPreferenceCWProxyImpl(this);
}

// **************************************************************************
// RepositoryGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, duplicate_ignore

mixin $UserPreferenceLocalAdapter on LocalAdapter<UserPreference> {
  static final Map<String, RelationshipMeta> _kUserPreferenceRelationshipMetas =
      {};

  @override
  Map<String, RelationshipMeta> get relationshipMetas =>
      _kUserPreferenceRelationshipMetas;

  @override
  UserPreference deserialize(map) {
    map = transformDeserialize(map);
    return UserPreference.fromJson(map);
  }

  @override
  Map<String, dynamic> serialize(model, {bool withRelationships = true}) {
    final map = model.toJson();
    return transformSerialize(map, withRelationships: withRelationships);
  }
}

final _userPreferencesFinders = <String, dynamic>{};

// ignore: must_be_immutable
class $UserPreferenceHiveLocalAdapter = HiveLocalAdapter<UserPreference>
    with $UserPreferenceLocalAdapter;

class $UserPreferenceRemoteAdapter = RemoteAdapter<UserPreference>
    with BaseAdapter<UserPreference>, UserPreferencesAdapter<UserPreference>;

final internalUserPreferencesRemoteAdapterProvider =
    Provider<RemoteAdapter<UserPreference>>((ref) =>
        $UserPreferenceRemoteAdapter(
            $UserPreferenceHiveLocalAdapter(ref.read, typeId: null),
            InternalHolder(_userPreferencesFinders)));

final userPreferencesRepositoryProvider = Provider<Repository<UserPreference>>(
    (ref) => Repository<UserPreference>(ref.read));

extension UserPreferenceDataRepositoryX on Repository<UserPreference> {
  BaseAdapter<UserPreference> get baseAdapter =>
      remoteAdapter as BaseAdapter<UserPreference>;
  UserPreferencesAdapter<UserPreference> get userPreferencesAdapter =>
      remoteAdapter as UserPreferencesAdapter<UserPreference>;
}

extension UserPreferenceRelationshipGraphNodeX
    on RelationshipGraphNode<UserPreference> {}

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
      id: json['_id'] as String?,
      insertTimestamp: json['insert_timestamp'] as int?,
      updateTimestamp: json['update_timestamp'] as int?,
      shoppingDays: (json['shopping_days'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
      supermarketSections: (json['supermarket_sections'] as List<dynamic>?)
          ?.map((e) =>
              SupermarketSection.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );

Map<String, dynamic> _$UserPreferenceToJson(UserPreference instance) {
  final val = <String, dynamic>{
    '_id': instance.id,
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
  return val;
}
