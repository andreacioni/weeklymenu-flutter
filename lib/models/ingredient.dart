import 'dart:convert';

import 'package:flutter_data/flutter_data.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:weekly_menu_app/models/base_model.dart';

part 'ingredient.g.dart';

@JsonSerializable()
@DataRepository([MyJSONServerAdapter])
class Ingredient extends BaseModel<Ingredient> {
  String name;

  Ingredient({String id, this.name}) : super(id: id);

  factory Ingredient.fromJson(Map<String, dynamic> json) =>
      _$IngredientFromJson(json);

  Map<String, dynamic> toJson() => _$IngredientToJson(this);

  Ingredient clone() => Ingredient.fromJson(this.toJson());
}

mixin MyJSONServerAdapter on RemoteAdapter<Ingredient> {
  @override
  String get baseUrl =>
      "https://heroku-weeklymenu.herokuapp.com/api/v1/ingredients";
}
