// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopping_list.dart';

// **************************************************************************
// RepositoryGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, duplicate_ignore

mixin $FlutterDataShoppingListLocalAdapter
    on LocalAdapter<FlutterDataShoppingList> {
  static final Map<String, RelationshipMeta>
      _kFlutterDataShoppingListRelationshipMetas = {};

  @override
  Map<String, RelationshipMeta> get relationshipMetas =>
      _kFlutterDataShoppingListRelationshipMetas;

  @override
  FlutterDataShoppingList deserialize(map) {
    map = transformDeserialize(map);
    return FlutterDataShoppingList.fromJson(map);
  }

  @override
  Map<String, dynamic> serialize(model, {bool withRelationships = true}) {
    final map = model.toJson();
    return transformSerialize(map, withRelationships: withRelationships);
  }
}

final _flutterDataShoppingListsFinders = <String, dynamic>{
  'findAllCustom': (_) => _.findAllCustom,
};

// ignore: must_be_immutable
class $FlutterDataShoppingListHiveLocalAdapter = HiveLocalAdapter<
    FlutterDataShoppingList> with $FlutterDataShoppingListLocalAdapter;

class $FlutterDataShoppingListRemoteAdapter = RemoteAdapter<
        FlutterDataShoppingList>
    with
        BaseAdapter<FlutterDataShoppingList>,
        ShoppingListAdapter<FlutterDataShoppingList>;

final internalFlutterDataShoppingListsRemoteAdapterProvider =
    Provider<RemoteAdapter<FlutterDataShoppingList>>((ref) =>
        $FlutterDataShoppingListRemoteAdapter(
            $FlutterDataShoppingListHiveLocalAdapter(ref),
            InternalHolder(_flutterDataShoppingListsFinders)));

final flutterDataShoppingListsRepositoryProvider =
    Provider<Repository<FlutterDataShoppingList>>(
        (ref) => Repository<FlutterDataShoppingList>(ref));

extension FlutterDataShoppingListDataRepositoryX
    on Repository<FlutterDataShoppingList> {
  BaseAdapter<FlutterDataShoppingList> get baseAdapter =>
      remoteAdapter as BaseAdapter<FlutterDataShoppingList>;
  ShoppingListAdapter<FlutterDataShoppingList> get shoppingListAdapter =>
      remoteAdapter as ShoppingListAdapter<FlutterDataShoppingList>;
}

extension FlutterDataShoppingListRelationshipGraphNodeX
    on RelationshipGraphNode<FlutterDataShoppingList> {}

// ignore_for_file: non_constant_identifier_names, duplicate_ignore

mixin $FlutterDataShoppingListItemLocalAdapter
    on LocalAdapter<FlutterDataShoppingListItem> {
  static final Map<String, RelationshipMeta>
      _kFlutterDataShoppingListItemRelationshipMetas = {};

  @override
  Map<String, RelationshipMeta> get relationshipMetas =>
      _kFlutterDataShoppingListItemRelationshipMetas;

  @override
  FlutterDataShoppingListItem deserialize(map) {
    map = transformDeserialize(map);
    return FlutterDataShoppingListItem.fromJson(map);
  }

  @override
  Map<String, dynamic> serialize(model, {bool withRelationships = true}) {
    final map = model.toJson();
    return transformSerialize(map, withRelationships: withRelationships);
  }
}

final _flutterDataShoppingListItemsFinders = <String, dynamic>{
  'findAllCustom': (_) => _.findAllCustom,
};

// ignore: must_be_immutable
class $FlutterDataShoppingListItemHiveLocalAdapter = HiveLocalAdapter<
    FlutterDataShoppingListItem> with $FlutterDataShoppingListItemLocalAdapter;

class $FlutterDataShoppingListItemRemoteAdapter = RemoteAdapter<
        FlutterDataShoppingListItem>
    with
        BaseAdapter<FlutterDataShoppingListItem>,
        ShoppingListItemAdapter<FlutterDataShoppingListItem>;

final internalFlutterDataShoppingListItemsRemoteAdapterProvider =
    Provider<RemoteAdapter<FlutterDataShoppingListItem>>((ref) =>
        $FlutterDataShoppingListItemRemoteAdapter(
            $FlutterDataShoppingListItemHiveLocalAdapter(ref),
            InternalHolder(_flutterDataShoppingListItemsFinders)));

final flutterDataShoppingListItemsRepositoryProvider =
    Provider<Repository<FlutterDataShoppingListItem>>(
        (ref) => Repository<FlutterDataShoppingListItem>(ref));

extension FlutterDataShoppingListItemDataRepositoryX
    on Repository<FlutterDataShoppingListItem> {
  BaseAdapter<FlutterDataShoppingListItem> get baseAdapter =>
      remoteAdapter as BaseAdapter<FlutterDataShoppingListItem>;
  ShoppingListItemAdapter<FlutterDataShoppingListItem>
      get shoppingListItemAdapter =>
          remoteAdapter as ShoppingListItemAdapter<FlutterDataShoppingListItem>;
}

extension FlutterDataShoppingListItemRelationshipGraphNodeX
    on RelationshipGraphNode<FlutterDataShoppingListItem> {}
