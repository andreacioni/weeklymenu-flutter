import 'package:flutter/foundation.dart';

import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

import 'package:weekly_menu_app/globals/memento.dart';
import 'package:weekly_menu_app/models/id.dart';

@JsonSerializable()
abstract class BaseModel<T> with ChangeNotifier implements Cloneable<T> {
  @JsonKey()
  String onlineId;

  @JsonKey(name: 'offline_id')
  final String offlineId;

  @JsonKey(name: 'insert_timestamp')
  int insertTimestamp;

  @JsonKey(name: 'update_timestamp')
  int updateTimestamp;

  BaseModel(
    this.offlineId, {
    this.onlineId,
    this.insertTimestamp,
    this.updateTimestamp,
  });

  @JsonKey(ignore: true)
  String get id => offlineId;
}
