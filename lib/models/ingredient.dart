import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import 'package:weekly_menu_app/models/base_model.dart';

part 'ingredient.g.dart';

@JsonSerializable()
class Ingredient extends BaseModel<Ingredient> {
  @JsonKey()
  String name;

  Ingredient({String id, this.name}) : super(id: id);

  factory Ingredient.fromJson(Map<String, dynamic> json) =>
      _$IngredientFromJson(json);

  factory Ingredient.fromJsonString(String json) =>
      Ingredient.fromJson(jsonDecode(json));

  Map<String, dynamic> toJson() => _$IngredientToJson(this);

  String toJsonString() => jsonEncode(toJson());

  @override
  Ingredient clone() => Ingredient.fromJson(this.toJson());
}
