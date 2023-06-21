// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu.dart';

// **************************************************************************
// RepositoryGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, duplicate_ignore

mixin $FlutterDataMenuLocalAdapter on LocalAdapter<FlutterDataMenu> {
  static final Map<String, RelationshipMeta>
      _kFlutterDataMenuRelationshipMetas = {};

  @override
  Map<String, RelationshipMeta> get relationshipMetas =>
      _kFlutterDataMenuRelationshipMetas;

  @override
  FlutterDataMenu deserialize(map) {
    map = transformDeserialize(map);
    return FlutterDataMenu.fromJson(map);
  }

  @override
  Map<String, dynamic> serialize(model, {bool withRelationships = true}) {
    final map = model.toJson();
    return transformSerialize(map, withRelationships: withRelationships);
  }
}

final _flutterDataMenusFinders = <String, dynamic>{};

// ignore: must_be_immutable
class $FlutterDataMenuHiveLocalAdapter = HiveLocalAdapter<FlutterDataMenu>
    with $FlutterDataMenuLocalAdapter;

class $FlutterDataMenuRemoteAdapter = RemoteAdapter<FlutterDataMenu>
    with BaseAdapter<FlutterDataMenu>;

final internalFlutterDataMenusRemoteAdapterProvider =
    Provider<RemoteAdapter<FlutterDataMenu>>((ref) =>
        $FlutterDataMenuRemoteAdapter($FlutterDataMenuHiveLocalAdapter(ref),
            InternalHolder(_flutterDataMenusFinders)));

final flutterDataMenusRepositoryProvider =
    Provider<Repository<FlutterDataMenu>>(
        (ref) => Repository<FlutterDataMenu>(ref));

extension FlutterDataMenuDataRepositoryX on Repository<FlutterDataMenu> {
  BaseAdapter<FlutterDataMenu> get baseAdapter =>
      remoteAdapter as BaseAdapter<FlutterDataMenu>;
}

extension FlutterDataMenuRelationshipGraphNodeX
    on RelationshipGraphNode<FlutterDataMenu> {}
