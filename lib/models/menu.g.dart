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
  /// Returns a callable class that can be used as follows: `instanceOfclass Menu extends BaseModel<Menu>.name.copyWith(...)` or like so:`instanceOfclass Menu extends BaseModel<Menu>.name.copyWith.fieldName(...)`.
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
  /// Returns a callable class that can be used as follows: `instanceOfclass DailyMenu.name.copyWith(...)` or like so:`instanceOfclass DailyMenu.name.copyWith.fieldName(...)`.
  _$DailyMenuCWProxy get copyWith => _$DailyMenuCWProxyImpl(this);
}

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
  writeNotNull('date', const DateConverter().toJson(instance.date));
  val['meal'] = _$MealEnumMap[instance.meal];
  val['recipes'] = instance.recipes;
  return val;
}

const _$MealEnumMap = {
  Meal.Breakfast: 'Breakfast',
  Meal.Lunch: 'Lunch',
  Meal.Dinner: 'Dinner',
};

// **************************************************************************
// RepositoryGenerator
// **************************************************************************

// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member, non_constant_identifier_names

mixin $MenuLocalAdapter on LocalAdapter<Menu> {
  @override
  Map<String, Map<String, Object?>> relationshipsFor([Menu? model]) => {};

  @override
  Menu deserialize(map) {
    for (final key in relationshipsFor().keys) {
      map[key] = {
        '_': [map[key], !map.containsKey(key)],
      };
    }
    return Menu.fromJson(map);
  }

  @override
  Map<String, dynamic> serialize(model) => model.toJson();
}

// ignore: must_be_immutable
class $MenuHiveLocalAdapter = HiveLocalAdapter<Menu> with $MenuLocalAdapter;

class $MenuRemoteAdapter = RemoteAdapter<Menu> with BaseAdapter<Menu>;

//

final menusRemoteAdapterProvider = Provider<RemoteAdapter<Menu>>((ref) =>
    $MenuRemoteAdapter(
        $MenuHiveLocalAdapter(ref.read), menuProvider, menusProvider));

final menusRepositoryProvider =
    Provider<Repository<Menu>>((ref) => Repository<Menu>(ref.read));

final _menuProvider = StateNotifierProvider.autoDispose
    .family<DataStateNotifier<Menu?>, DataState<Menu?>, WatchArgs<Menu>>(
        (ref, args) {
  final adapter = ref.watch(menusRemoteAdapterProvider);
  final notifier =
      adapter.strategies.watchersOne[args.watcher] ?? adapter.watchOneNotifier;
  return notifier(args.id!,
      remote: args.remote,
      params: args.params,
      headers: args.headers,
      alsoWatch: args.alsoWatch,
      finder: args.finder);
});

AutoDisposeStateNotifierProvider<DataStateNotifier<Menu?>, DataState<Menu?>>
    menuProvider(Object? id,
        {bool? remote,
        Map<String, dynamic>? params,
        Map<String, String>? headers,
        AlsoWatch<Menu>? alsoWatch,
        String? finder,
        String? watcher}) {
  return _menuProvider(WatchArgs(
      id: id,
      remote: remote,
      params: params,
      headers: headers,
      alsoWatch: alsoWatch,
      finder: finder,
      watcher: watcher));
}

final _menusProvider = StateNotifierProvider.autoDispose.family<
    DataStateNotifier<List<Menu>>,
    DataState<List<Menu>>,
    WatchArgs<Menu>>((ref, args) {
  final adapter = ref.watch(menusRemoteAdapterProvider);
  final notifier =
      adapter.strategies.watchersAll[args.watcher] ?? adapter.watchAllNotifier;
  return notifier(
      remote: args.remote,
      params: args.params,
      headers: args.headers,
      syncLocal: args.syncLocal,
      finder: args.finder);
});

AutoDisposeStateNotifierProvider<DataStateNotifier<List<Menu>>,
        DataState<List<Menu>>>
    menusProvider(
        {bool? remote,
        Map<String, dynamic>? params,
        Map<String, String>? headers,
        bool? syncLocal,
        String? finder,
        String? watcher}) {
  return _menusProvider(WatchArgs(
      remote: remote,
      params: params,
      headers: headers,
      syncLocal: syncLocal,
      finder: finder,
      watcher: watcher));
}

extension MenuDataX on Menu {
  /// Initializes "fresh" models (i.e. manually instantiated) to use
  /// [save], [delete] and so on.
  ///
  /// Can be obtained via `ref.read`, `container.read`
  Menu init(Reader read, {bool save = true}) {
    final repository = internalLocatorFn(menusRepositoryProvider, read);
    final updatedModel =
        repository.remoteAdapter.initializeModel(this, save: save);
    return save ? updatedModel : this;
  }
}

extension MenuDataRepositoryX on Repository<Menu> {
  BaseAdapter<Menu> get baseAdapter => remoteAdapter as BaseAdapter<Menu>;
}
