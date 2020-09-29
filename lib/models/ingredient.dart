import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:weekly_menu_app/syncronizer/syncro.dart';

@JsonSerializable()
@HiveType(typeId: 5)
class Ingredient extends BaseModel<Ingredient> {
  @JsonKey()
  String name;

  Ingredient(Id id, {this.name}) : super(id);

  factory Ingredient.fromJson(Map<String, dynamic> jsonMap) {
    return Ingredient(
      Id(onlineId: jsonMap['_id'], offlineId: jsonMap['offline_id']),
      name: jsonMap['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id.onlineId,
      'offline_id': id.offlineId,
      'name': name,
    };
  }

  @override
  Ingredient clone() => Ingredient.fromJson(this.toJson());
}
