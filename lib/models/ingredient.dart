import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter_data/flutter_data.dart';
import 'package:json_annotation/json_annotation.dart';

import 'base_model.dart';

part 'ingredient.g.dart';

@JsonSerializable()
@DataRepository([BaseAdapter], internalType: 'ingredients')
@CopyWith()
class Ingredient extends BaseModel<Ingredient> {
  final String name;

  Ingredient(
      {required String id,
      required this.name,
      int? insertTimestamp,
      int? updateTimestamp})
      : super(
            id: id,
            insertTimestamp: insertTimestamp,
            updateTimestamp: updateTimestamp);

  factory Ingredient.fromJson(Map<String, dynamic> json) =>
      _$IngredientFromJson(json);

  Map<String, dynamic> toJson() => _$IngredientToJson(this);

  Ingredient clone() => Ingredient.fromJson(this.toJson());
}
