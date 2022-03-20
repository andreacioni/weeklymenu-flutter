// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Menu _$MenuFromJson(Map<String, dynamic> json) => Menu(
      id: json['_id'] as String,
      date: const DateConverter().fromJson(json['date'] as String),
      meal: $enumDecode(_$MealEnumMap, json['meal']),
      recipes: (json['recipes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$MenuToJson(Menu instance) => <String, dynamic>{
      '_id': instance.id,
      'date': const DateConverter().toJson(instance.date),
      'meal': _$MealEnumMap[instance.meal],
      'recipes': instance.recipes,
    };

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

final menusLocalAdapterProvider =
    Provider<LocalAdapter<Menu>>((ref) => $MenuHiveLocalAdapter(ref.read));

final menusRemoteAdapterProvider = Provider<RemoteAdapter<Menu>>((ref) =>
    $MenuRemoteAdapter(
        ref.watch(menusLocalAdapterProvider), menuProvider, menusProvider));

final menusRepositoryProvider =
    Provider<Repository<Menu>>((ref) => Repository<Menu>(ref.read));

final _menuProvider = StateNotifierProvider.autoDispose
    .family<DataStateNotifier<Menu?>, DataState<Menu?>, WatchArgs<Menu>>(
        (ref, args) {
  return ref.watch(menusRepositoryProvider).watchOneNotifier(args.id,
      remote: args.remote,
      params: args.params,
      headers: args.headers,
      alsoWatch: args.alsoWatch);
});

AutoDisposeStateNotifierProvider<DataStateNotifier<Menu?>, DataState<Menu?>>
    menuProvider(dynamic id,
        {bool? remote,
        Map<String, dynamic>? params,
        Map<String, String>? headers,
        AlsoWatch<Menu>? alsoWatch}) {
  return _menuProvider(WatchArgs(
      id: id,
      remote: remote,
      params: params,
      headers: headers,
      alsoWatch: alsoWatch));
}

final _menusProvider = StateNotifierProvider.autoDispose.family<
    DataStateNotifier<List<Menu>>,
    DataState<List<Menu>>,
    WatchArgs<Menu>>((ref, args) {
  return ref.watch(menusRepositoryProvider).watchAllNotifier(
      remote: args.remote,
      params: args.params,
      headers: args.headers,
      syncLocal: args.syncLocal);
});

AutoDisposeStateNotifierProvider<DataStateNotifier<List<Menu>>,
        DataState<List<Menu>>>
    menusProvider(
        {bool? remote,
        Map<String, dynamic>? params,
        Map<String, String>? headers,
        bool? syncLocal}) {
  return _menusProvider(WatchArgs(
      remote: remote, params: params, headers: headers, syncLocal: syncLocal));
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
