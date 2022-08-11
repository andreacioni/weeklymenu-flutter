import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_data/flutter_data.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:objectid/objectid.dart';

import '../globals/json_converter.dart';
import 'base_model.dart';

part 'user_preferences.g.dart';

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

@JsonSerializable(explicitToJson: true, anyMap: true)
@DataRepository([BaseAdapter, UserPreferencesAdapter],
    internalType: 'userPreferences')
@CopyWith()
class UserPreference extends BaseModel<UserPreference> {
  @JsonKey(name: 'shopping_days')
  final List<int>? shoppingDays;

  @JsonKey(name: 'supermarket_sections')
  final List<SupermarketSection>? supermarketSections;

  @JsonKey(ignore: true)
  final String? owner;

  UserPreference(
      {String? id,
      this.owner,
      int? insertTimestamp,
      int? updateTimestamp,
      this.shoppingDays,
      this.supermarketSections})
      : super(
            id: id ?? ObjectId().hexString,
            insertTimestamp: insertTimestamp,
            updateTimestamp: updateTimestamp);

  factory UserPreference.fromJson(Map<String, dynamic> json) =>
      _$UserPreferenceFromJson(json);

  Map<String, dynamic> toJson() => _$UserPreferenceToJson(this);

  UserPreference clone() => UserPreference.fromJson(this.toJson());

  @override
  String toString() => "$shoppingDays, $supermarketSections";
}

mixin UserPreferencesAdapter<T extends DataModel<UserPreference>>
    on RemoteAdapter<UserPreference> {
  static const _BASE_PATH = 'users/me/preferences';
  @override
  String urlForFindAll(Map<String, dynamic> params) => _BASE_PATH;

  @override
  String urlForFindOne(id, Map<String, dynamic> params) => '$_BASE_PATH/$id';

  @override
  String urlForSave(id, Map<String, dynamic> params) => '$_BASE_PATH/$id';
}
