import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:weekly_menu_app/models/base_model.dart';

part 'ingredient.g.dart';

@JsonSerializable()
class Ingredient extends BaseModel<Ingredient> {
  @JsonKey()
  String name;

  Ingredient({this.name}) : super(Uuid().v4());

  factory Ingredient.fromJson(Map<String, dynamic> json) =>
      _$IngredientFromJson(json);

  Map<String, dynamic> toJson() => _$IngredientToJson(this);

  @override
  Ingredient clone() => Ingredient.fromJson(this.toJson());
}
