// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_menu.dart';

// **************************************************************************
// RepositoryGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, duplicate_ignore

mixin $FlutterDataDailyMenuLocalAdapter on LocalAdapter<FlutterDataDailyMenu> {
  static final Map<String, RelationshipMeta>
      _kFlutterDataDailyMenuRelationshipMetas = {};

  @override
  Map<String, RelationshipMeta> get relationshipMetas =>
      _kFlutterDataDailyMenuRelationshipMetas;

  @override
  FlutterDataDailyMenu deserialize(map) {
    map = transformDeserialize(map);
    return FlutterDataDailyMenu.fromJson(map);
  }

  @override
  Map<String, dynamic> serialize(model, {bool withRelationships = true}) {
    final map = model.toJson();
    return transformSerialize(map, withRelationships: withRelationships);
  }
}

final _flutterDataDailyMenusFinders = <String, dynamic>{
  'findOneCustom': (_) => _.findOneCustom,
};

// ignore: must_be_immutable
class $FlutterDataDailyMenuHiveLocalAdapter = HiveLocalAdapter<
    FlutterDataDailyMenu> with $FlutterDataDailyMenuLocalAdapter;

class $FlutterDataDailyMenuRemoteAdapter = RemoteAdapter<FlutterDataDailyMenu>
    with
        DailyMenuAdapter<FlutterDataDailyMenu>,
        BaseAdapter<FlutterDataDailyMenu>;

final internalFlutterDataDailyMenusRemoteAdapterProvider =
    Provider<RemoteAdapter<FlutterDataDailyMenu>>((ref) =>
        $FlutterDataDailyMenuRemoteAdapter(
            $FlutterDataDailyMenuHiveLocalAdapter(ref),
            InternalHolder(_flutterDataDailyMenusFinders)));

final flutterDataDailyMenusRepositoryProvider =
    Provider<Repository<FlutterDataDailyMenu>>(
        (ref) => Repository<FlutterDataDailyMenu>(ref));

extension FlutterDataDailyMenuDataRepositoryX
    on Repository<FlutterDataDailyMenu> {
  DailyMenuAdapter<FlutterDataDailyMenu> get dailyMenuAdapter =>
      remoteAdapter as DailyMenuAdapter<FlutterDataDailyMenu>;
  BaseAdapter<FlutterDataDailyMenu> get baseAdapter =>
      remoteAdapter as BaseAdapter<FlutterDataDailyMenu>;
}

extension FlutterDataDailyMenuRelationshipGraphNodeX
    on RelationshipGraphNode<FlutterDataDailyMenu> {}
