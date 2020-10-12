import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:weekly_menu_app/models/base_model.dart';
import 'package:weekly_menu_app/models/id.dart';

part 'ingredient.g.dart';

@JsonSerializable()
class Ingredient extends BaseModel<Ingredient> {
  @JsonKey()
  String name;

  Ingredient({
    Id idx,
    int insertTimestamp,
    int updateTimestamp,
    this.name,
  }) : super(
          idx: idx,
          insertTimestamp: insertTimestamp,
          updateTimestamp: updateTimestamp,
        );

  factory Ingredient.fromJson(Map<String, dynamic> json) =>
      _$IngredientFromJson(json);

  Map<String, dynamic> toJson() => _$IngredientToJson(this);

  @override
  Ingredient clone() => Ingredient.fromJson(this.toJson());
}
