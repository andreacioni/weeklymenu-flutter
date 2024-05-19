// ignore_for_file: invalid_annotation_target

import 'package:flutter_data/flutter_data.dart';
import 'package:model/daily_menu.dart';
import 'package:common/date.dart';

import 'package:intl/intl.dart';
import 'base_adapter.dart';

part 'daily_menu.g.dart';

@DataRepository([BaseAdapter], internalType: 'daily_menu')
class FlutterDataDailyMenu extends DailyMenu
    with DataModelMixin<FlutterDataDailyMenu> {
  FlutterDataDailyMenu(
      {required super.idx,
      required super.date,
      required super.meals,
      super.insertTimestamp,
      super.updateTimestamp}) {
    init();
  }

  factory FlutterDataDailyMenu.fromJson(Map<String, dynamic> json) {
    final temp = DailyMenu.fromJson(json);
    return FlutterDataDailyMenu(
        idx: temp.idx,
        date: temp.date,
        meals: temp.meals,
        insertTimestamp: temp.insertTimestamp,
        updateTimestamp: temp.updateTimestamp);
  }

  @override
  String get id => date.formatId();

  //fake override, needed to allow flutter_data builder to generate correct output
  // ignore: unnecessary_overrides
  @override
  Map<String, dynamic> toJson() {
    return super.toJson();
  }
}
