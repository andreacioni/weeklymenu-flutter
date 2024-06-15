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

final _flutterDataRecipesFinders = <String, dynamic>{
  'findAllCustom': (_) => _.findAllCustom,
  'findOneCustom': (_) => _.findOneCustom,
};

// ignore: must_be_immutable
class $FlutterDataRecipeHiveLocalAdapter = HiveLocalAdapter<FlutterDataRecipe>
    with $FlutterDataRecipeLocalAdapter;

class $FlutterDataRecipeRemoteAdapter = RemoteAdapter<FlutterDataRecipe>
    with RecipeAdapter<FlutterDataRecipe>, BaseAdapter<FlutterDataRecipe>;

final internalFlutterDataRecipesRemoteAdapterProvider =
    Provider<RemoteAdapter<FlutterDataRecipe>>((ref) =>
        $FlutterDataRecipeRemoteAdapter($FlutterDataRecipeHiveLocalAdapter(ref),
            InternalHolder(_flutterDataRecipesFinders)));

final flutterDataRecipesRepositoryProvider =
    Provider<Repository<FlutterDataRecipe>>(
        (ref) => Repository<FlutterDataRecipe>(ref));

extension FlutterDataRecipeDataRepositoryX on Repository<FlutterDataRecipe> {
  RecipeAdapter<FlutterDataRecipe> get recipeAdapter =>
      remoteAdapter as RecipeAdapter<FlutterDataRecipe>;
  BaseAdapter<FlutterDataRecipe> get baseAdapter =>
      remoteAdapter as BaseAdapter<FlutterDataRecipe>;
}

extension FlutterDataRecipeRelationshipGraphNodeX
    on RelationshipGraphNode<FlutterDataRecipe> {}

// ignore_for_file: non_constant_identifier_names, duplicate_ignore

mixin $FlutterDataExternalRecipeLocalAdapter
    on LocalAdapter<FlutterDataExternalRecipe> {
  static final Map<String, RelationshipMeta>
      _kFlutterDataExternalRecipeRelationshipMetas = {};

  @override
  Map<String, RelationshipMeta> get relationshipMetas =>
      _kFlutterDataExternalRecipeRelationshipMetas;

  @override
  FlutterDataExternalRecipe deserialize(map) {
    map = transformDeserialize(map);
    return FlutterDataExternalRecipe.fromJson(map);
  }

  @override
  Map<String, dynamic> serialize(model, {bool withRelationships = true}) {
    final map = model.toJson();
    return transformSerialize(map, withRelationships: withRelationships);
  }
}

final _flutterDataExternalRecipesFinders = <String, dynamic>{};

// ignore: must_be_immutable
class $FlutterDataExternalRecipeHiveLocalAdapter = HiveLocalAdapter<
    FlutterDataExternalRecipe> with $FlutterDataExternalRecipeLocalAdapter;

class $FlutterDataExternalRecipeRemoteAdapter = RemoteAdapter<
        FlutterDataExternalRecipe>
    with
        BaseAdapter<FlutterDataExternalRecipe>,
        ExternalRecipeAdapter<FlutterDataExternalRecipe>;

final internalFlutterDataExternalRecipesRemoteAdapterProvider =
    Provider<RemoteAdapter<FlutterDataExternalRecipe>>((ref) =>
        $FlutterDataExternalRecipeRemoteAdapter(
            $FlutterDataExternalRecipeHiveLocalAdapter(ref),
            InternalHolder(_flutterDataExternalRecipesFinders)));

final flutterDataExternalRecipesRepositoryProvider =
    Provider<Repository<FlutterDataExternalRecipe>>(
        (ref) => Repository<FlutterDataExternalRecipe>(ref));

extension FlutterDataExternalRecipeDataRepositoryX
    on Repository<FlutterDataExternalRecipe> {
  BaseAdapter<FlutterDataExternalRecipe> get baseAdapter =>
      remoteAdapter as BaseAdapter<FlutterDataExternalRecipe>;
  ExternalRecipeAdapter<FlutterDataExternalRecipe> get externalRecipeAdapter =>
      remoteAdapter as ExternalRecipeAdapter<FlutterDataExternalRecipe>;
}

extension FlutterDataExternalRecipeRelationshipGraphNodeX
    on RelationshipGraphNode<FlutterDataExternalRecipe> {}
