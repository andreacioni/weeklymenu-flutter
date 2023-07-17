import 'package:common/memento.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ingredient.g.dart';

@JsonSerializable()
@CopyWith()
class Ingredient implements Cloneable<Ingredient> {
  final String name;

  Ingredient({required this.name});

  factory Ingredient.fromJson(Map<String, dynamic> json) =>
      _$IngredientFromJson(json);

  Map<String, dynamic> toJson() => _$IngredientToJson(this);

  @override
  Ingredient clone() => Ingredient.fromJson(toJson());
}
