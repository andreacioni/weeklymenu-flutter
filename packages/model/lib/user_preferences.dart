import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:model/converter/json_converter.dart';

import 'base_model.dart';

part 'user_preferences.g.dart';

const STANDARD_UNIT_OF_MEASURE = const [
  "pcs",
  "g",
  "Kg",
  "gr",
  "cup",
  "tsp",
  "tbs",
  "L",
  "ml",
  "dl",
  "cl",
  "m",
  "cm",
  "mm",
  "glass",
  "lb",
  "oz",
  "pt",
  "gl",
  "qt"
];

@JsonSerializable()
class SupermarketSection {
  final String name;

  @ColorConverter()
  final Color? color;

  SupermarketSection({required this.name, this.color});

  factory SupermarketSection.fromJson(Map<String, dynamic> json) =>
      _$SupermarketSectionFromJson(json);

  Map<String, dynamic> toJson() => _$SupermarketSectionToJson(this);

  @override
  String toString() => "$name, $color";
}

@JsonSerializable(
    explicitToJson: true, anyMap: true, fieldRename: FieldRename.snake)
class UserPreference extends BaseModel<UserPreference> {
  final List<int>? shoppingDays;

  final List<SupermarketSection>? supermarketSections;

  @JsonKey(defaultValue: STANDARD_UNIT_OF_MEASURE)
  final List<String>? unitsOfMeasure;

  @JsonKey(ignore: true)
  final String? owner;

  UserPreference(
      {required Object? id,
      this.owner,
      int? insertTimestamp,
      int? updateTimestamp,
      this.shoppingDays,
      this.supermarketSections,
      this.unitsOfMeasure})
      : super(
            id: id,
            insertTimestamp: insertTimestamp,
            updateTimestamp: updateTimestamp);

  factory UserPreference.fromJson(Map<String, dynamic> json) =>
      _$UserPreferenceFromJson(json);

  Map<String, dynamic> toJson() => _$UserPreferenceToJson(this);

  UserPreference clone() => UserPreference.fromJson(this.toJson());

  @override
  String toString() => "$shoppingDays, $supermarketSections, $unitsOfMeasure";
}
