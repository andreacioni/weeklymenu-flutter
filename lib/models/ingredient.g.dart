// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ingredient _$IngredientFromJson(Map<String, dynamic> json) {
  return Ingredient(
    id: json['_id'] as String,
    name: json['name'] as String,
  );
}

Map<String, dynamic> _$IngredientToJson(Ingredient instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
    };

// **************************************************************************
// RepositoryGenerator
// **************************************************************************

// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member, non_constant_identifier_names

mixin $IngredientLocalAdapter on LocalAdapter<Ingredient> {
  @override
  Map<String, Map<String, Object>> relationshipsFor([Ingredient model]) => {};

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

final ingredientsLocalAdapterProvider = Provider<LocalAdapter<Ingredient>>(
    (ref) => $IngredientHiveLocalAdapter(ref));

final ingredientsRemoteAdapterProvider = Provider<RemoteAdapter<Ingredient>>(
    (ref) =>
        $IngredientRemoteAdapter(ref.read(ingredientsLocalAdapterProvider)));

final ingredientsRepositoryProvider =
    Provider<Repository<Ingredient>>((ref) => Repository<Ingredient>(ref));

final _watchIngredient = StateNotifierProvider.autoDispose
    .family<DataStateNotifier<Ingredient>, WatchArgs<Ingredient>>((ref, args) {
  return ref.read(ingredientsRepositoryProvider).watchOne(args.id,
      remote: args.remote,
      params: args.params,
      headers: args.headers,
      alsoWatch: args.alsoWatch);
});

AutoDisposeStateNotifierProvider<DataStateNotifier<Ingredient>> watchIngredient(
    dynamic id,
    {bool remote,
    Map<String, dynamic> params = const {},
    Map<String, String> headers = const {},
    AlsoWatch<Ingredient> alsoWatch}) {
  return _watchIngredient(WatchArgs(
      id: id,
      remote: remote,
      params: params,
      headers: headers,
      alsoWatch: alsoWatch));
}

final _watchIngredients = StateNotifierProvider.autoDispose
    .family<DataStateNotifier<List<Ingredient>>, WatchArgs<Ingredient>>(
        (ref, args) {
  ref.maintainState = false;
  return ref.read(ingredientsRepositoryProvider).watchAll(
      remote: args.remote,
      params: args.params,
      headers: args.headers,
      filterLocal: args.filterLocal,
      syncLocal: args.syncLocal);
});

AutoDisposeStateNotifierProvider<DataStateNotifier<List<Ingredient>>>
    watchIngredients(
        {bool remote,
        Map<String, dynamic> params,
        Map<String, String> headers}) {
  return _watchIngredients(
      WatchArgs(remote: remote, params: params, headers: headers));
}

extension IngredientX on Ingredient {
  /// Initializes "fresh" models (i.e. manually instantiated) to use
  /// [save], [delete] and so on.
  ///
  /// Can be obtained via `context.read`, `ref.read`, `container.read`
  Ingredient init(Reader read) {
    final repository = internalLocatorFn(ingredientsRepositoryProvider, read);
    return repository.remoteAdapter.initializeModel(this, save: true);
  }
}
