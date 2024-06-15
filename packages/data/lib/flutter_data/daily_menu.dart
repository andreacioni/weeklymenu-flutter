// ignore_for_file: invalid_annotation_target

import 'dart:async';

import 'package:common/log.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_data/flutter_data.dart';
import 'package:model/daily_menu.dart';
import 'package:common/date.dart';

import 'base_adapter.dart';

part 'daily_menu.g.dart';

@DataRepository([DailyMenuAdapter, BaseAdapter], internalType: 'daily_menu')
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

mixin DailyMenuAdapter<T extends DataModelMixin<FlutterDataDailyMenu>>
    on RemoteAdapter<FlutterDataDailyMenu> {
  @DataFinder()
  Future<FlutterDataDailyMenu?> findOneCustom(Object id,
      {bool? remote,
      bool? background,
      Map<String, dynamic>? params,
      Map<String, String>? headers,
      OnSuccessOne<FlutterDataDailyMenu>? onSuccess,
      OnErrorOne<FlutterDataDailyMenu>? onError,
      DataRequestLabel? label}) {
    var originalOnError = onError;

    onError = (err, label, adapter) {
      logWarn("ciao");
      if (err is OfflineException && label.kind == 'findOne') {
        return null;
      }

      return originalOnError?.call(err, label, adapter);
    };
    return super.findOne(id,
        remote: remote,
        background: background,
        params: params,
        headers: headers,
        onSuccess: onSuccess,
        onError: onError,
        label: label);
  }
}
