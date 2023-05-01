// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$IngredientCWProxy {
  Ingredient name(String name);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Ingredient(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Ingredient(...).copyWith(id: 12, name: "My name")
  /// ````
  Ingredient call({
    String? name,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfIngredient.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfIngredient.copyWith.fieldName(...)`
class _$IngredientCWProxyImpl implements _$IngredientCWProxy {
  final Ingredient _value;

  const _$IngredientCWProxyImpl(this._value);

  @override
  Ingredient name(String name) => this(name: name);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Ingredient(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Ingredient(...).copyWith(id: 12, name: "My name")
  /// ````
  Ingredient call({
    Object? name = const $CopyWithPlaceholder(),
  }) {
    return Ingredient(
      name: name == const $CopyWithPlaceholder() || name == null
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
    );
  }
}

extension $IngredientCopyWith on Ingredient {
  /// Returns a callable class that can be used as follows: `instanceOfIngredient.copyWith(...)` or like so:`instanceOfIngredient.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$IngredientCWProxy get copyWith => _$IngredientCWProxyImpl(this);
}

// **************************************************************************
// RepositoryGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, duplicate_ignore

mixin $IngredientLocalAdapter on LocalAdapter<Ingredient> {
  static final Map<String, RelationshipMeta> _kIngredientRelationshipMetas = {};

  @override
  Map<String, RelationshipMeta> get relationshipMetas =>
      _kIngredientRelationshipMetas;

  @override
  Ingredient deserialize(map) {
    map = transformDeserialize(map);
    return Ingredient.fromJson(map);
  }

  @override
  Map<String, dynamic> serialize(model, {bool withRelationships = true}) {
    final map = model.toJson();
    return transformSerialize(map, withRelationships: withRelationships);
  }
}

final _ingredientsFinders = <String, dynamic>{};

// ignore: must_be_immutable
class $IngredientHiveLocalAdapter = HiveLocalAdapter<Ingredient>
    with $IngredientLocalAdapter;

class $IngredientRemoteAdapter = RemoteAdapter<Ingredient>
    with BaseAdapter<Ingredient>, IngredientsAdapter<Ingredient>;

final internalIngredientsRemoteAdapterProvider =
    Provider<RemoteAdapter<Ingredient>>((ref) => $IngredientRemoteAdapter(
        $IngredientHiveLocalAdapter(ref), InternalHolder(_ingredientsFinders)));

final ingredientsRepositoryProvider =
    Provider<Repository<Ingredient>>((ref) => Repository<Ingredient>(ref));

extension IngredientDataRepositoryX on Repository<Ingredient> {
  BaseAdapter<Ingredient> get baseAdapter =>
      remoteAdapter as BaseAdapter<Ingredient>;
  IngredientsAdapter<Ingredient> get ingredientsAdapter =>
      remoteAdapter as IngredientsAdapter<Ingredient>;
}

extension IngredientRelationshipGraphNodeX
    on RelationshipGraphNode<Ingredient> {}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ingredient _$IngredientFromJson(Map json) => Ingredient(
      name: json['name'] as String,
    );

Map<String, dynamic> _$IngredientToJson(Ingredient instance) =>
    <String, dynamic>{
      'name': instance.name,
    };
