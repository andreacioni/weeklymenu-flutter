import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import 'package:flutter/foundation.dart';

import 'package:json_annotation/json_annotation.dart';
import 'package:weekly_menu_app/globals/memento.dart';

@JsonSerializable()
@HiveType(typeId: 1)
class Id {
  static final RegExp _uuidRegExp = RegExp(
      '^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}\$');

  @JsonKey(name: '_id')
  @HiveField(0)
  String _onlineId;

  @JsonKey(name: 'offline_id')
  @HiveField(1)
  String _offlineId;

  Id({String onlineId, String offlineId})
      : assert(offlineId != null && _uuidRegExp.hasMatch(offlineId)) {
    if (offlineId == null) {
      offlineId = Uuid().v4().toString();
    }
  }

  factory Id.newInstance() => Id();

  String get onlineId => _onlineId;

  String get offlineId => _offlineId;

  bool get hasValidOnlineId => _uuidRegExp.hasMatch(_onlineId);

  @override
  bool operator ==(o) => o is Id && o._offlineId == this._offlineId;

  @override
  int get hashCode => _offlineId.hashCode;

  @override
  String toString() => _offlineId;
}

abstract class BaseModel<T> with ChangeNotifier implements Cloneable<T> {
  @HiveField(0)
  Id id;

  @JsonKey(name: 'insert_timestamp')
  @HiveField(1)
  String _insertTimestamp;

  @JsonKey(name: 'update_timestamp')
  @HiveField(2)
  String _updateTimestamp;

  BaseModel(this.id);

  String get insertTimestamp => _insertTimestamp;

  String get updateTimestamp => _updateTimestamp;
}
