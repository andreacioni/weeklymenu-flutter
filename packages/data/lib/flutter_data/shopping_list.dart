import 'package:common/constants.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_data/flutter_data.dart';
import 'package:model/base_model.dart';
import 'package:model/shopping_list.dart';
import 'package:objectid/objectid.dart';

import 'base_adapter.dart';
part 'shopping_list.g.dart';

const SHOPPING_LIST_ID_PARAM = 'shopping_list_id';

@DataRepository([BaseAdapter, ShoppingListAdapter],
    internalType: 'shopping-lists')
class FlutterDataShoppingList extends ShoppingList
    with DataModelMixin<FlutterDataShoppingList> {
  FlutterDataShoppingList(
      {required super.idx,
      super.insertTimestamp,
      super.items,
      super.name,
      super.updateTimestamp}) {
    init();
  }

  factory FlutterDataShoppingList.fromJson(Map<String, dynamic> json) {
    final temp = ShoppingList.fromJson(json);
    return FlutterDataShoppingList(
        idx: temp.idx,
        insertTimestamp: temp.insertTimestamp,
        items: temp.items,
        name: temp.name,
        updateTimestamp: temp.updateTimestamp);
  }

  @override
  String get id => idx;

  //fake override, needed to allow flutter_data builder to generate correct output
  // ignore: unnecessary_overrides
  @override
  Map<String, dynamic> toJson() {
    return super.toJson();
  }
}

mixin ShoppingListAdapter<T extends DataModelMixin<FlutterDataShoppingList>>
    on RemoteAdapter<FlutterDataShoppingList> {
  @override
  String urlForFindAll(Map<String, dynamic> params) => dashCaseType;

  @override
  String urlForFindOne(id, Map<String, dynamic> params) => '$dashCaseType/$id';

  @override
  String urlForSave(id, Map<String, dynamic> params) =>
      params[UPDATE_PARAM] == true ? '$dashCaseType/$id' : dashCaseType;

  String get dashCaseType =>
      type.split(RegExp('(?=[A-Z])')).join('-').toLowerCase();
}
