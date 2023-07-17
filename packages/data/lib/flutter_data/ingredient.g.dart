// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient.dart';

// **************************************************************************
// RepositoryGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, duplicate_ignore

mixin $FlutterDataIngredientLocalAdapter
    on LocalAdapter<FlutterDataIngredient> {
  static final Map<String, RelationshipMeta>
      _kFlutterDataIngredientRelationshipMetas = {};

  @override
  Map<String, RelationshipMeta> get relationshipMetas =>
      _kFlutterDataIngredientRelationshipMetas;

  @override
  FlutterDataIngredient deserialize(map) {
    map = transformDeserialize(map);
    return FlutterDataIngredient.fromJson(map);
  }

  @override
  Map<String, dynamic> serialize(model, {bool withRelationships = true}) {
    final map = model.toJson();
    return transformSerialize(map, withRelationships: withRelationships);
  }
}

final _flutterDataIngredientsFinders = <String, dynamic>{};

// ignore: must_be_immutable
class $FlutterDataIngredientHiveLocalAdapter = HiveLocalAdapter<
    FlutterDataIngredient> with $FlutterDataIngredientLocalAdapter;

class $FlutterDataIngredientRemoteAdapter = RemoteAdapter<FlutterDataIngredient>
    with
        BaseAdapter<FlutterDataIngredient>,
        FlutterDataIngredientsAdapter<FlutterDataIngredient>;

final internalFlutterDataIngredientsRemoteAdapterProvider =
    Provider<RemoteAdapter<FlutterDataIngredient>>((ref) =>
        $FlutterDataIngredientRemoteAdapter(
            $FlutterDataIngredientHiveLocalAdapter(ref),
            InternalHolder(_flutterDataIngredientsFinders)));

final flutterDataIngredientsRepositoryProvider =
    Provider<Repository<FlutterDataIngredient>>(
        (ref) => Repository<FlutterDataIngredient>(ref));

extension FlutterDataIngredientDataRepositoryX
    on Repository<FlutterDataIngredient> {
  BaseAdapter<FlutterDataIngredient> get baseAdapter =>
      remoteAdapter as BaseAdapter<FlutterDataIngredient>;
  FlutterDataIngredientsAdapter<FlutterDataIngredient>
      get flutterDataIngredientsAdapter =>
          remoteAdapter as FlutterDataIngredientsAdapter<FlutterDataIngredient>;
}

extension FlutterDataIngredientRelationshipGraphNodeX
    on RelationshipGraphNode<FlutterDataIngredient> {}
