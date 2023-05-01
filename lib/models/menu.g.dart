// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$MenuCWProxy {
  Menu date(Date date);

  Menu id(String? id);

  Menu insertTimestamp(int? insertTimestamp);

  Menu meal(Meal meal);

  Menu recipes(List<String> recipes);

  Menu updateTimestamp(int? updateTimestamp);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Menu(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Menu(...).copyWith(id: 12, name: "My name")
  /// ````
  Menu call({
    Date? date,
    String? id,
    int? insertTimestamp,
    Meal? meal,
    List<String>? recipes,
    int? updateTimestamp,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfMenu.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfMenu.copyWith.fieldName(...)`
class _$MenuCWProxyImpl implements _$MenuCWProxy {
  final Menu _value;

  const _$MenuCWProxyImpl(this._value);

  @override
  Menu date(Date date) => this(date: date);

  @override
  Menu id(String? id) => this(id: id);

  @override
  Menu insertTimestamp(int? insertTimestamp) =>
      this(insertTimestamp: insertTimestamp);

  @override
  Menu meal(Meal meal) => this(meal: meal);

  @override
  Menu recipes(List<String> recipes) => this(recipes: recipes);

  @override
  Menu updateTimestamp(int? updateTimestamp) =>
      this(updateTimestamp: updateTimestamp);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Menu(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Menu(...).copyWith(id: 12, name: "My name")
  /// ````
  Menu call({
    Object? date = const $CopyWithPlaceholder(),
    Object? id = const $CopyWithPlaceholder(),
    Object? insertTimestamp = const $CopyWithPlaceholder(),
    Object? meal = const $CopyWithPlaceholder(),
    Object? recipes = const $CopyWithPlaceholder(),
    Object? updateTimestamp = const $CopyWithPlaceholder(),
  }) {
    return Menu(
      date: date == const $CopyWithPlaceholder() || date == null
          ? _value.date
          // ignore: cast_nullable_to_non_nullable
          : date as Date,
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String?,
      insertTimestamp: insertTimestamp == const $CopyWithPlaceholder()
          ? _value.insertTimestamp
          // ignore: cast_nullable_to_non_nullable
          : insertTimestamp as int?,
      meal: meal == const $CopyWithPlaceholder() || meal == null
          ? _value.meal
          // ignore: cast_nullable_to_non_nullable
          : meal as Meal,
      recipes: recipes == const $CopyWithPlaceholder() || recipes == null
          ? _value.recipes
          // ignore: cast_nullable_to_non_nullable
          : recipes as List<String>,
      updateTimestamp: updateTimestamp == const $CopyWithPlaceholder()
          ? _value.updateTimestamp
          // ignore: cast_nullable_to_non_nullable
          : updateTimestamp as int?,
    );
  }
}

extension $MenuCopyWith on Menu {
  /// Returns a callable class that can be used as follows: `instanceOfMenu.copyWith(...)` or like so:`instanceOfMenu.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$MenuCWProxy get copyWith => _$MenuCWProxyImpl(this);
}

abstract class _$DailyMenuCWProxy {
  DailyMenu day(Date day);

  DailyMenu menus(List<Menu> menus);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DailyMenu(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DailyMenu(...).copyWith(id: 12, name: "My name")
  /// ````
  DailyMenu call({
    Date? day,
    List<Menu>? menus,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDailyMenu.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDailyMenu.copyWith.fieldName(...)`
class _$DailyMenuCWProxyImpl implements _$DailyMenuCWProxy {
  final DailyMenu _value;

  const _$DailyMenuCWProxyImpl(this._value);

  @override
  DailyMenu day(Date day) => this(day: day);

  @override
  DailyMenu menus(List<Menu> menus) => this(menus: menus);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DailyMenu(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DailyMenu(...).copyWith(id: 12, name: "My name")
  /// ````
  DailyMenu call({
    Object? day = const $CopyWithPlaceholder(),
    Object? menus = const $CopyWithPlaceholder(),
  }) {
    return DailyMenu(
      day: day == const $CopyWithPlaceholder() || day == null
          ? _value.day
          // ignore: cast_nullable_to_non_nullable
          : day as Date,
      menus: menus == const $CopyWithPlaceholder() || menus == null
          ? _value.menus
          // ignore: cast_nullable_to_non_nullable
          : menus as List<Menu>,
    );
  }
}

extension $DailyMenuCopyWith on DailyMenu {
  /// Returns a callable class that can be used as follows: `instanceOfDailyMenu.copyWith(...)` or like so:`instanceOfDailyMenu.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DailyMenuCWProxy get copyWith => _$DailyMenuCWProxyImpl(this);
}

// **************************************************************************
// RepositoryGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, duplicate_ignore

mixin $MenuLocalAdapter on LocalAdapter<Menu> {
  static final Map<String, RelationshipMeta> _kMenuRelationshipMetas = {};

  @override
  Map<String, RelationshipMeta> get relationshipMetas =>
      _kMenuRelationshipMetas;

  @override
  Menu deserialize(map) {
    map = transformDeserialize(map);
    return Menu.fromJson(map);
  }

  @override
  Map<String, dynamic> serialize(model, {bool withRelationships = true}) {
    final map = model.toJson();
    return transformSerialize(map, withRelationships: withRelationships);
  }
}

final _menusFinders = <String, dynamic>{};

// ignore: must_be_immutable
class $MenuHiveLocalAdapter = HiveLocalAdapter<Menu> with $MenuLocalAdapter;

class $MenuRemoteAdapter = RemoteAdapter<Menu> with BaseAdapter<Menu>;

final internalMenusRemoteAdapterProvider = Provider<RemoteAdapter<Menu>>(
    (ref) => $MenuRemoteAdapter(
        $MenuHiveLocalAdapter(ref), InternalHolder(_menusFinders)));

final menusRepositoryProvider =
    Provider<Repository<Menu>>((ref) => Repository<Menu>(ref));

extension MenuDataRepositoryX on Repository<Menu> {
  BaseAdapter<Menu> get baseAdapter => remoteAdapter as BaseAdapter<Menu>;
}

extension MenuRelationshipGraphNodeX on RelationshipGraphNode<Menu> {}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Menu _$MenuFromJson(Map json) => Menu(
      id: json['_id'] as String?,
      date: const DateConverter().fromJson(json['date'] as String),
      meal: $enumDecode(_$MealEnumMap, json['meal']),
      recipes: (json['recipes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      insertTimestamp: json['insert_timestamp'] as int?,
      updateTimestamp: json['update_timestamp'] as int?,
    );

Map<String, dynamic> _$MenuToJson(Menu instance) {
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
  val['date'] = const DateConverter().toJson(instance.date);
  val['meal'] = _$MealEnumMap[instance.meal]!;
  val['recipes'] = instance.recipes;
  return val;
}

const _$MealEnumMap = {
  Meal.Breakfast: 'Breakfast',
  Meal.Lunch: 'Lunch',
  Meal.Dinner: 'Dinner',
};
