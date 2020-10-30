// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ingredient _$IngredientFromJson(Map<String, dynamic> json) {
  return Ingredient(
    id: json['_id'] as String,
    name: json['name'] as String,
  )
    ..insertTimestamp = json['insert_timestamp'] as int
    ..updateTimestamp = json['update_timestamp'] as int;
}

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
    with MyJSONServerAdapter;

//

final ingredientLocalAdapterProvider =
    RiverpodAlias.provider<LocalAdapter<Ingredient>>((ref) =>
        $IngredientHiveLocalAdapter(
            ref.read(hiveLocalStorageProvider), ref.read(graphProvider)));

final ingredientRemoteAdapterProvider =
    RiverpodAlias.provider<RemoteAdapter<Ingredient>>((ref) =>
        $IngredientRemoteAdapter(ref.read(ingredientLocalAdapterProvider)));

final ingredientRepositoryProvider =
    RiverpodAlias.provider<Repository<Ingredient>>(
        (ref) => Repository<Ingredient>(ref));

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
