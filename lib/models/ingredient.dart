import 'dart:convert';

import 'package:flutter_data/flutter_data.dart';
import 'package:json_annotation/json_annotation.dart';

import 'base_model.dart';

part 'ingredient.g.dart';

@JsonSerializable()
@DataRepository([BaseAdapter])
class Ingredient extends BaseModel<Ingredient> {
  String name;

  Ingredient({String id, this.name}) : super(id: id);

  factory Ingredient.fromJson(Map<String, dynamic> json) =>
      _$IngredientFromJson(json);

  Map<String, dynamic> toJson() => _$IngredientToJson(this);

  Ingredient clone() => Ingredient.fromJson(this.toJson());
}
