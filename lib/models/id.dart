import 'package:flutter/foundation.dart';

import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:weekly_menu_app/globals/memento.dart';

class Id {
  final String offlineId;

  String onlineId;

  Id(this.offlineId, {this.onlineId});
}
