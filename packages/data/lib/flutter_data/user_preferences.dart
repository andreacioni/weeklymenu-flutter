import 'package:flutter_data/flutter_data.dart';
import 'package:model/user_preferences.dart';

import 'base_adapter.dart';

part 'user_preferences.g.dart';

@DataRepository([BaseAdapter, UserPreferencesAdapter],
    internalType: 'userPreferences')
class FlutterDataUserPreference extends UserPreference
    with DataModelMixin<FlutterDataUserPreference> {
  FlutterDataUserPreference(
      {required super.idx,
      super.insertTimestamp,
      super.owner,
      super.shoppingDays,
      super.supermarketSections,
      super.unitsOfMeasure,
      super.language,
      super.updateTimestamp}) {
    init();
  }

  factory FlutterDataUserPreference.fromJson(Map<String, dynamic> json) {
    final temp = UserPreference.fromJson(json);
    return FlutterDataUserPreference(
        idx: temp.idx,
        insertTimestamp: temp.insertTimestamp,
        owner: temp.owner,
        shoppingDays: temp.shoppingDays,
        supermarketSections: temp.supermarketSections,
        unitsOfMeasure: temp.unitsOfMeasure,
        language: temp.language,
        updateTimestamp: temp.insertTimestamp);
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

mixin UserPreferencesAdapter<
        T extends DataModelMixin<FlutterDataUserPreference>>
    on RemoteAdapter<FlutterDataUserPreference> {
  static const _BASE_PATH = 'users/me/preferences';
  @override
  String urlForFindAll(Map<String, dynamic> params) => _BASE_PATH;

  @override
  String urlForFindOne(id, Map<String, dynamic> params) => '$_BASE_PATH/$id';

  @override
  String urlForSave(id, Map<String, dynamic> params) => '$_BASE_PATH/$id';
}
