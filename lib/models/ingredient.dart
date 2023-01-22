import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter_data/flutter_data.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:objectid/objectid.dart';

import 'base_model.dart';

part 'ingredient.g.dart';

@JsonSerializable()
@DataRepository([BaseAdapter, IngredientsAdapter], internalType: 'ingredients')
@CopyWith()
class Ingredient extends DataModel<Ingredient> {
  @override
  String get id => name.hashCode.toString();

  final String name;

  Ingredient({required this.name});

  factory Ingredient.fromJson(Map<String, dynamic> json) =>
      _$IngredientFromJson(json);

  Map<String, dynamic> toJson() => _$IngredientToJson(this);

  Ingredient clone() => Ingredient.fromJson(this.toJson());
}

mixin IngredientsAdapter<T extends DataModel<Ingredient>>
    on RemoteAdapter<Ingredient> {
  @override
  String urlForFindAll(Map<String, dynamic> params) => 'ingredients-view';

  @override
  Future<Ingredient> save(Ingredient model,
      {bool? remote,
      Map<String, dynamic>? params,
      Map<String, String>? headers,
      OnSuccessOne<Ingredient>? onSuccess,
      OnErrorOne<Ingredient>? onError,
      DataRequestLabel? label}) {
    // no need to save
    return super.save(model,
        remote: false,
        params: params,
        headers: headers,
        onSuccess: onSuccess,
        onError: onError,
        label: label);
  }

  @override
  Future<Ingredient?> findOne(Object id,
      {bool? remote,
      bool? background,
      Map<String, dynamic>? params,
      Map<String, String>? headers,
      OnSuccessOne<Ingredient>? onSuccess,
      OnErrorOne<Ingredient>? onError,
      DataRequestLabel? label}) {
    // find one is not implemented server-side
    return super.findOne(id,
        remote: false,
        background: background,
        params: params,
        headers: headers,
        onSuccess: onSuccess,
        onError: onError,
        label: label);
  }
}
