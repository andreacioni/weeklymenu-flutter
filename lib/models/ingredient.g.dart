// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$IngredientCWProxy {
  Ingredient id(String id);

  Ingredient insertTimestamp(int? insertTimestamp);

  Ingredient name(String name);

  Ingredient updateTimestamp(int? updateTimestamp);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Ingredient(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Ingredient(...).copyWith(id: 12, name: "My name")
  /// ````
  Ingredient call({
    String? id,
    int? insertTimestamp,
    String? name,
    int? updateTimestamp,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfIngredient.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfIngredient.copyWith.fieldName(...)`
class _$IngredientCWProxyImpl implements _$IngredientCWProxy {
  final Ingredient _value;

  const _$IngredientCWProxyImpl(this._value);

  @override
  Ingredient id(String id) => this(id: id);

  @override
  Ingredient insertTimestamp(int? insertTimestamp) =>
      this(insertTimestamp: insertTimestamp);

  @override
  Ingredient name(String name) => this(name: name);

  @override
  Ingredient updateTimestamp(int? updateTimestamp) =>
      this(updateTimestamp: updateTimestamp);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Ingredient(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Ingredient(...).copyWith(id: 12, name: "My name")
  /// ````
  Ingredient call({
    Object? id = const $CopyWithPlaceholder(),
    Object? insertTimestamp = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? updateTimestamp = const $CopyWithPlaceholder(),
  }) {
    return Ingredient(
      id: id == const $CopyWithPlaceholder() || id == null
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      insertTimestamp: insertTimestamp == const $CopyWithPlaceholder()
          ? _value.insertTimestamp
          // ignore: cast_nullable_to_non_nullable
          : insertTimestamp as int?,
      name: name == const $CopyWithPlaceholder() || name == null
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      updateTimestamp: updateTimestamp == const $CopyWithPlaceholder()
          ? _value.updateTimestamp
          // ignore: cast_nullable_to_non_nullable
          : updateTimestamp as int?,
    );
  }
}

extension $IngredientCopyWith on Ingredient {
  /// Returns a callable class that can be used as follows: `instanceOfclass Ingredient extends BaseModel<Ingredient>.name.copyWith(...)` or like so:`instanceOfclass Ingredient extends BaseModel<Ingredient>.name.copyWith.fieldName(...)`.
  _$IngredientCWProxy get copyWith => _$IngredientCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ingredient _$IngredientFromJson(Map json) => Ingredient(
      id: json['_id'] as String,
      name: json['name'] as String,
      insertTimestamp: json['insert_timestamp'] as int?,
      updateTimestamp: json['update_timestamp'] as int?,
    );

Map<String, dynamic> _$IngredientToJson(Ingredient instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'insert_timestamp': instance.insertTimestamp,
      'update_timestamp': instance.updateTimestamp,
      'name': instance.name,
    };

// **************************************************************************
// RepositoryGenerator
// **************************************************************************

// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member, non_constant_identifier_names

mixin $IngredientLocalAdapter on LocalAdapter<Ingredient> {
  @override
  Map<String, Map<String, Object?>> relationshipsFor([Ingredient? model]) => {};

  @override
  Ingredient deserialize(map) {
    for (final key in relationshipsFor().keys) {
      map[key] = {
        '_': [map[key], !map.containsKey(key)],
      };
    }
    return Ingredient.fromJson(map);
  }

  @override
  Map<String, dynamic> serialize(model) => model.toJson();
}

// ignore: must_be_immutable
class $IngredientHiveLocalAdapter = HiveLocalAdapter<Ingredient>
    with $IngredientLocalAdapter;

class $IngredientRemoteAdapter = RemoteAdapter<Ingredient>
    with BaseAdapter<Ingredient>;

//

final ingredientsRemoteAdapterProvider = Provider<RemoteAdapter<Ingredient>>(
    (ref) => $IngredientRemoteAdapter($IngredientHiveLocalAdapter(ref.read),
        ingredientProvider, ingredientsProvider));

final ingredientsRepositoryProvider =
    Provider<Repository<Ingredient>>((ref) => Repository<Ingredient>(ref.read));

final _ingredientProvider = StateNotifierProvider.autoDispose.family<
    DataStateNotifier<Ingredient?>,
    DataState<Ingredient?>,
    WatchArgs<Ingredient>>((ref, args) {
  final adapter = ref.watch(ingredientsRemoteAdapterProvider);
  final notifier =
      adapter.strategies.watchersOne[args.watcher] ?? adapter.watchOneNotifier;
  return notifier(args.id!,
      remote: args.remote,
      params: args.params,
      headers: args.headers,
      alsoWatch: args.alsoWatch,
      finder: args.finder);
});

AutoDisposeStateNotifierProvider<DataStateNotifier<Ingredient?>,
        DataState<Ingredient?>>
    ingredientProvider(Object? id,
        {bool? remote,
        Map<String, dynamic>? params,
        Map<String, String>? headers,
        AlsoWatch<Ingredient>? alsoWatch,
        String? finder,
        String? watcher}) {
  return _ingredientProvider(WatchArgs(
      id: id,
      remote: remote,
      params: params,
      headers: headers,
      alsoWatch: alsoWatch,
      finder: finder,
      watcher: watcher));
}

final _ingredientsProvider = StateNotifierProvider.autoDispose.family<
    DataStateNotifier<List<Ingredient>>,
    DataState<List<Ingredient>>,
    WatchArgs<Ingredient>>((ref, args) {
  final adapter = ref.watch(ingredientsRemoteAdapterProvider);
  final notifier =
      adapter.strategies.watchersAll[args.watcher] ?? adapter.watchAllNotifier;
  return notifier(
      remote: args.remote,
      params: args.params,
      headers: args.headers,
      syncLocal: args.syncLocal,
      finder: args.finder);
});

AutoDisposeStateNotifierProvider<DataStateNotifier<List<Ingredient>>,
        DataState<List<Ingredient>>>
    ingredientsProvider(
        {bool? remote,
        Map<String, dynamic>? params,
        Map<String, String>? headers,
        bool? syncLocal,
        String? finder,
        String? watcher}) {
  return _ingredientsProvider(WatchArgs(
      remote: remote,
      params: params,
      headers: headers,
      syncLocal: syncLocal,
      finder: finder,
      watcher: watcher));
}

extension IngredientDataX on Ingredient {
  /// Initializes "fresh" models (i.e. manually instantiated) to use
  /// [save], [delete] and so on.
  ///
  /// Can be obtained via `ref.read`, `container.read`
  Ingredient init(Reader read, {bool save = true}) {
    final repository = internalLocatorFn(ingredientsRepositoryProvider, read);
    final updatedModel =
        repository.remoteAdapter.initializeModel(this, save: save);
    return save ? updatedModel : this;
  }
}

extension IngredientDataRepositoryX on Repository<Ingredient> {
  BaseAdapter<Ingredient> get baseAdapter =>
      remoteAdapter as BaseAdapter<Ingredient>;
}
