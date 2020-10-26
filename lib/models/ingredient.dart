import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:weekly_menu_app/models/base_model.dart';

part 'ingredient.g.dart';

@JsonSerializable()
@HiveType(typeId: 1)
class Ingredient extends BaseModel<Ingredient> {
  @JsonKey()
  @HiveField(1)
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
