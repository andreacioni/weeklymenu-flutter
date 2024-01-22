import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:model/converter/json_converter.dart';
import 'package:objectid/objectid.dart';

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
@CopyWith()
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
@CopyWith()
class UserPreference extends BaseModel<UserPreference> {
  final List<int>? shoppingDays;

  final List<SupermarketSection>? supermarketSections;

  @JsonKey(defaultValue: STANDARD_UNIT_OF_MEASURE)
  final List<String>? unitsOfMeasure;

  @JsonKey()
  final String? language;

  @JsonKey(ignore: true)
  final String? owner;

  UserPreference({
    String? idx,
    this.owner,
    int? insertTimestamp,
    int? updateTimestamp,
    this.shoppingDays,
    this.supermarketSections,
    this.unitsOfMeasure,
    this.language,
  }) : super(
            idx: idx ?? ObjectId().hexString,
            insertTimestamp: insertTimestamp,
            updateTimestamp: updateTimestamp);

  factory UserPreference.fromJson(Map<String, dynamic> json) =>
      _$UserPreferenceFromJson(json);

  Map<String, dynamic> toJson() => _$UserPreferenceToJson(this);

  UserPreference clone() => UserPreference.fromJson(this.toJson());

  @override
  String toString() => "$shoppingDays, $supermarketSections, $unitsOfMeasure";
}
