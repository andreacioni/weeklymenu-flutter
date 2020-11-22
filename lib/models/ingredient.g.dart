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

final ingredientLocalAdapterProvider = Provider<LocalAdapter<Ingredient>>(
    (ref) => $IngredientHiveLocalAdapter(ref));

final ingredientRemoteAdapterProvider = Provider<RemoteAdapter<Ingredient>>(
    (ref) =>
        $IngredientRemoteAdapter(ref.read(ingredientLocalAdapterProvider)));

final ingredientRepositoryProvider =
    Provider<Repository<Ingredient>>((ref) => Repository<Ingredient>(ref));

final _watchIngredient = StateNotifierProvider.autoDispose
    .family<DataStateNotifier<Ingredient>, WatchArgs<Ingredient>>((ref, args) {
  return ref.watch(ingredientRepositoryProvider).watchOne(args.id,
      remote: args.remote,
      params: args.params,
      headers: args.headers,
      alsoWatch: args.alsoWatch);
});

AutoDisposeStateNotifierStateProvider<DataState<Ingredient>> watchIngredient(
    dynamic id,
    {bool remote = true,
    Map<String, dynamic> params = const {},
    Map<String, String> headers = const {},
    AlsoWatch<Ingredient> alsoWatch}) {
  return _watchIngredient(WatchArgs(
          id: id,
          remote: remote,
          params: params,
          headers: headers,
          alsoWatch: alsoWatch))
      .state;
}

final _watchIngredients = StateNotifierProvider.autoDispose
    .family<DataStateNotifier<List<Ingredient>>, WatchArgs<Ingredient>>(
        (ref, args) {
  ref.maintainState = false;
  return ref.watch(ingredientRepositoryProvider).watchAll(
      remote: args.remote, params: args.params, headers: args.headers);
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
  /// Pass:
  ///  - A `BuildContext` if using Flutter with Riverpod or Provider
  ///  - Nothing if using Flutter with GetIt
  ///  - A Riverpod `ProviderContainer` if using pure Dart
  ///  - Its own [Repository<Ingredient>]
  Ingredient init(context) {
    final repository = context is Repository<Ingredient>
        ? context
        : internalLocatorFn(ingredientRepositoryProvider, context);
    return repository.internalAdapter.initializeModel(this, save: true)
        as Ingredient;
  }
}
