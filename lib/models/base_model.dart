import 'package:flutter/foundation.dart';

import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

import 'package:weekly_menu_app/globals/memento.dart';
import 'package:weekly_menu_app/models/id.dart';

@JsonSerializable()
abstract class BaseModel<T> with ChangeNotifier implements Cloneable<T> {
  @JsonKey(name: 'offline_id', toJson: idToJson, fromJson: idFromJson)
  final Id idx;

  @JsonKey(name: 'insert_timestamp')
  int insertTimestamp;

  @JsonKey(name: 'update_timestamp')
  int updateTimestamp;

  BaseModel({
    this.idx,
    this.insertTimestamp,
    this.updateTimestamp,
  });

  @JsonKey(ignore: true)
  String get onlineId => this.onlineId;
  set onlineId(String id) => this.onlineId = id;

  @JsonKey(ignore: true)
  String get id => idx.onlineId;

  static idToJson(Id id) => id.offlineId;
  static idFromJson(dynamic id) => Id(id as String);
}
