import 'package:flutter_data/flutter_data.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:model/ingredient.dart';

import 'base_adapter.dart';

part 'ingredient.g.dart';

@DataRepository([BaseAdapter, FlutterDataIngredientsAdapter],
    internalType: 'ingredients')
class FlutterDataIngredient extends Ingredient
    with DataModelMixin<FlutterDataIngredient> {
  FlutterDataIngredient({required super.name}) {
    init();
  }

  @override
  String get id => name.hashCode.toString();

  factory FlutterDataIngredient.fromJson(Map<String, dynamic> json) {
    final temp = Ingredient.fromJson(json);
    return FlutterDataIngredient(name: temp.name);
  }

  //fake override, needed to allow flutter_data builder to generate correct output
  // ignore: unnecessary_overrides
  @override
  Map<String, dynamic> toJson() {
    return super.toJson();
  }
}

mixin FlutterDataIngredientsAdapter<
        T extends DataModelMixin<FlutterDataIngredient>>
    on RemoteAdapter<FlutterDataIngredient> {
  @override
  String urlForFindAll(Map<String, dynamic> params) => 'ingredients-view';

  @override
  Future<FlutterDataIngredient> save(FlutterDataIngredient model,
      {bool? remote,
      Map<String, dynamic>? params,
      Map<String, String>? headers,
      OnSuccessOne<FlutterDataIngredient>? onSuccess,
      OnErrorOne<FlutterDataIngredient>? onError,
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
  Future<FlutterDataIngredient?> findOne(Object id,
      {bool? remote,
      bool? background,
      Map<String, dynamic>? params,
      Map<String, String>? headers,
      OnSuccessOne<FlutterDataIngredient>? onSuccess,
      OnErrorOne<FlutterDataIngredient>? onError,
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
