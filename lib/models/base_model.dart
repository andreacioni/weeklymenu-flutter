import 'package:flutter/foundation.dart';

import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

import 'package:weekly_menu_app/globals/memento.dart';
import 'package:weekly_menu_app/models/id.dart';

abstract class BaseModel<T> with ChangeNotifier implements Cloneable<T> {
  @JsonKey(name: 'offline_id', toJson: idToJson, fromJson: idFromJson)
  final Id id;

  @JsonKey(name: 'insert_timestamp')
  int insertTimestamp;

  @JsonKey(name: 'update_timestamp')
  int updateTimestamp;

  BaseModel({
    this.id,
    this.insertTimestamp,
    this.updateTimestamp,
  });

  set onlineId(String id) => this.onlineId = id;

  static idToJson(Id id) => id.offlineId;
  static idFromJson(dynamic id) => Id(id as String);
}
