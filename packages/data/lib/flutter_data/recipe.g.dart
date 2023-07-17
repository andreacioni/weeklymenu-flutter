// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe.dart';

// **************************************************************************
// RepositoryGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, duplicate_ignore

mixin $FlutterDataRecipeLocalAdapter on LocalAdapter<FlutterDataRecipe> {
  static final Map<String, RelationshipMeta>
      _kFlutterDataRecipeRelationshipMetas = {};

  @override
  Map<String, RelationshipMeta> get relationshipMetas =>
      _kFlutterDataRecipeRelationshipMetas;

  @override
  FlutterDataRecipe deserialize(map) {
    map = transformDeserialize(map);
    return FlutterDataRecipe.fromJson(map);
  }

  @override
  Map<String, dynamic> serialize(model, {bool withRelationships = true}) {
    final map = model.toJson();
    return transformSerialize(map, withRelationships: withRelationships);
  }
}

final _flutterDataRecipesFinders = <String, dynamic>{};

// ignore: must_be_immutable
class $FlutterDataRecipeHiveLocalAdapter = HiveLocalAdapter<FlutterDataRecipe>
    with $FlutterDataRecipeLocalAdapter;

class $FlutterDataRecipeRemoteAdapter = RemoteAdapter<FlutterDataRecipe>
    with BaseAdapter<FlutterDataRecipe>;

final internalFlutterDataRecipesRemoteAdapterProvider =
    Provider<RemoteAdapter<FlutterDataRecipe>>((ref) =>
        $FlutterDataRecipeRemoteAdapter($FlutterDataRecipeHiveLocalAdapter(ref),
            InternalHolder(_flutterDataRecipesFinders)));

final flutterDataRecipesRepositoryProvider =
    Provider<Repository<FlutterDataRecipe>>(
        (ref) => Repository<FlutterDataRecipe>(ref));

extension FlutterDataRecipeDataRepositoryX on Repository<FlutterDataRecipe> {
  BaseAdapter<FlutterDataRecipe> get baseAdapter =>
      remoteAdapter as BaseAdapter<FlutterDataRecipe>;
}

extension FlutterDataRecipeRelationshipGraphNodeX
    on RelationshipGraphNode<FlutterDataRecipe> {}
