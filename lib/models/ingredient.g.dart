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
  /// Returns a callable class that can be used as follows: `instanceOfIngredient.copyWith(...)` or like so:`instanceOfIngredient.copyWith.fieldName(...)`.
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
    with BaseAdapter<Ingredient>;

final internalIngredientsRemoteAdapterProvider =
    Provider<RemoteAdapter<Ingredient>>((ref) => $IngredientRemoteAdapter(
        $IngredientHiveLocalAdapter(ref.read),
        InternalHolder(_ingredientsFinders)));

final ingredientsRepositoryProvider =
    Provider<Repository<Ingredient>>((ref) => Repository<Ingredient>(ref.read));

extension IngredientDataRepositoryX on Repository<Ingredient> {
  BaseAdapter<Ingredient> get baseAdapter =>
      remoteAdapter as BaseAdapter<Ingredient>;
}

extension IngredientRelationshipGraphNodeX
    on RelationshipGraphNode<Ingredient> {}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ingredient _$IngredientFromJson(Map json) => Ingredient(
      id: json['_id'] as String,
      name: json['name'] as String,
      insertTimestamp: json['insert_timestamp'] as int?,
      updateTimestamp: json['update_timestamp'] as int?,
    );

Map<String, dynamic> _$IngredientToJson(Ingredient instance) {
  final val = <String, dynamic>{
    '_id': instance.id,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('insert_timestamp', instance.insertTimestamp);
  writeNotNull('update_timestamp', instance.updateTimestamp);
  val['name'] = instance.name;
  return val;
}
