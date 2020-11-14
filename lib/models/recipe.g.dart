// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Recipe _$RecipeFromJson(Map json) {
  return Recipe(
    id: json['_id'] as String,
    name: json['name'] as String,
    description: json['description'] as String,
    ingredients: (json['ingredients'] as List)
            ?.map((e) => e == null
                ? null
                : RecipeIngredient.fromJson((e as Map)?.map(
                    (k, e) => MapEntry(k as String, e),
                  )))
            ?.toList() ??
        [],
    difficulty: json['difficulty'] as String,
    rating: json['rating'] as int,
    cost: json['cost'] as int,
    availabilityMonths:
        (json['availabilityMonths'] as List)?.map((e) => e as int)?.toList(),
    servs: json['servs'] as int,
    estimatedPreparationTime: json['estimatedPreparationTime'] as int,
    estimatedCookingTime: json['estimatedCookingTime'] as int,
    imgUrl: json['imgUrl'] as String,
    tags: (json['tags'] as List)?.map((e) => e as String)?.toList(),
    preparation: json['preparation'] as String,
    recipeUrl: json['recipeUrl'] as String,
    note: json['note'] as String,
  );
}

Map<String, dynamic> _$RecipeToJson(Recipe instance) {
  final val = <String, dynamic>{
    '_id': instance.id,
    'name': instance.name,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('description', instance.description);
  writeNotNull('rating', instance.rating);
  writeNotNull('cost', instance.cost);
  writeNotNull('difficulty', instance.difficulty);
  writeNotNull('availabilityMonths', instance.availabilityMonths);
  writeNotNull('servs', instance.servs);
  writeNotNull('estimatedCookingTime', instance.estimatedCookingTime);
  writeNotNull('estimatedPreparationTime', instance.estimatedPreparationTime);
  writeNotNull(
      'ingredients', instance.ingredients?.map((e) => e?.toJson())?.toList());
  writeNotNull('preparation', instance.preparation);
  writeNotNull('note', instance.note);
  writeNotNull('imgUrl', instance.imgUrl);
  writeNotNull('recipeUrl', instance.recipeUrl);
  writeNotNull('tags', instance.tags);
  return val;
}

RecipeIngredient _$RecipeIngredientFromJson(Map<String, dynamic> json) {
  return RecipeIngredient(
    ingredientId: json['ingredient'] as String,
    quantity: (json['quantity'] as num)?.toDouble(),
    unitOfMeasure: json['unitOfMeasure'] as String,
    freezed: json['freezed'] as bool,
  );
}

Map<String, dynamic> _$RecipeIngredientToJson(RecipeIngredient instance) {
  final val = <String, dynamic>{
    'ingredient': instance.ingredientId,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('quantity', instance.quantity);
  writeNotNull('unitOfMeasure', instance.unitOfMeasure);
  writeNotNull('freezed', instance.freezed);
  return val;
}

// **************************************************************************
// RepositoryGenerator
// **************************************************************************

// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member, non_constant_identifier_names

mixin $RecipeLocalAdapter on LocalAdapter<Recipe> {
  @override
  Map<String, Map<String, Object>> relationshipsFor([Recipe model]) => {};

  @override
  Recipe deserialize(map) {
    for (final key in relationshipsFor().keys) {
      map[key] = {
        '_': [map[key], !map.containsKey(key)],
      };
    }
    return Recipe.fromJson(map);
  }

  @override
  Map<String, dynamic> serialize(model) => model.toJson();
}

// ignore: must_be_immutable
class $RecipeHiveLocalAdapter = HiveLocalAdapter<Recipe>
    with $RecipeLocalAdapter;

class $RecipeRemoteAdapter = RemoteAdapter<Recipe> with BaseAdapter<Recipe>;

//

final recipeLocalAdapterProvider =
    Provider<LocalAdapter<Recipe>>((ref) => $RecipeHiveLocalAdapter(ref));

final recipeRemoteAdapterProvider = Provider<RemoteAdapter<Recipe>>(
    (ref) => $RecipeRemoteAdapter(ref.read(recipeLocalAdapterProvider)));

final recipeRepositoryProvider =
    Provider<Repository<Recipe>>((ref) => Repository<Recipe>(ref));

final _watchRecipe = StateNotifierProvider.autoDispose
    .family<DataStateNotifier<Recipe>, WatchArgs<Recipe>>((ref, args) {
  return ref.watch(recipeRepositoryProvider).watchOne(args.id,
      remote: args.remote,
      params: args.params,
      headers: args.headers,
      alsoWatch: args.alsoWatch);
});

AutoDisposeStateNotifierStateProvider<DataState<Recipe>> watchRecipe(dynamic id,
    {bool remote = true,
    Map<String, dynamic> params = const {},
    Map<String, String> headers = const {},
    AlsoWatch<Recipe> alsoWatch}) {
  return _watchRecipe(WatchArgs(
          id: id,
          remote: remote,
          params: params,
          headers: headers,
          alsoWatch: alsoWatch))
      .state;
}

final _watchRecipes = StateNotifierProvider.autoDispose
    .family<DataStateNotifier<List<Recipe>>, WatchArgs<Recipe>>((ref, args) {
  ref.maintainState = false;
  return ref.watch(recipeRepositoryProvider).watchAll(
      remote: args.remote, params: args.params, headers: args.headers);
});

AutoDisposeStateNotifierProvider<DataStateNotifier<List<Recipe>>> watchRecipes(
    {bool remote, Map<String, dynamic> params, Map<String, String> headers}) {
  return _watchRecipes(
      WatchArgs(remote: remote, params: params, headers: headers));
}

extension RecipeX on Recipe {
  /// Initializes "fresh" models (i.e. manually instantiated) to use
  /// [save], [delete] and so on.
  ///
  /// Pass:
  ///  - A `BuildContext` if using Flutter with Riverpod or Provider
  ///  - Nothing if using Flutter with GetIt
  ///  - A Riverpod `ProviderContainer` if using pure Dart
  ///  - Its own [Repository<Recipe>]
  Recipe init(context) {
    final repository = context is Repository<Recipe>
        ? context
        : internalLocatorFn(recipeRepositoryProvider, context);
    return repository.internalAdapter.initializeModel(this, save: true)
        as Recipe;
  }
}
