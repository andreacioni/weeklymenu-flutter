// ignore_for_file: invalid_annotation_target

import 'package:flutter_data/flutter_data.dart';
import 'package:model/menu.dart';

import 'base_adapter.dart';

part 'menu.g.dart';

@DataRepository([BaseAdapter], internalType: 'menus')
class FlutterDataMenu extends Menu with DataModelMixin<FlutterDataMenu> {
  FlutterDataMenu(
      {required super.id,
      required super.date,
      required super.meal,
      super.insertTimestamp,
      super.recipes,
      super.updateTimestamp}) {
    init();
  }

  factory FlutterDataMenu.fromJson(Map<String, dynamic> json) {
    final temp = Menu.fromJson(json);
    return FlutterDataMenu(
        id: temp.id,
        date: temp.date,
        meal: temp.meal,
        insertTimestamp: temp.insertTimestamp,
        updateTimestamp: temp.updateTimestamp,
        recipes: temp.recipes);
  }

  //fake override, needed to allow flutter_data builder to generate correct output
  // ignore: unnecessary_overrides
  @override
  Map<String, dynamic> toJson() {
    return super.toJson();
  }
}
