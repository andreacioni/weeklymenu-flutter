import 'package:common/constants.dart';
import 'package:common/memento.dart';
import 'package:json_annotation/json_annotation.dart';

abstract class BaseModel<T> implements Cloneable<T> {
  @override
  @JsonKey(name: ID_FIELD)
  final Object? id;

  @JsonKey(name: INSERT_TIMESTAMP_FIELD)
  final int? insertTimestamp;

  @JsonKey(name: UPDATE_TIMESTAMP_FIELD)
  final int? updateTimestamp;

  BaseModel({
    required this.id,
    this.insertTimestamp,
    this.updateTimestamp,
  });
}
