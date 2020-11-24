// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopping_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShoppingList _$ShoppingListFromJson(Map<String, dynamic> json) {
  return ShoppingList(
    id: json['_id'] as String,
    items: (json['items'] as List)
            ?.map((e) => e == null
                ? null
                : ShoppingListItem.fromJson(e as Map<String, dynamic>))
            ?.toList() ??
        [],
    name: json['name'] as String,
  );
}

Map<String, dynamic> _$ShoppingListToJson(ShoppingList instance) {
  final val = <String, dynamic>{
    '_id': instance.id,
    'items': instance.items?.map((e) => e?.toJson())?.toList(),
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('name', instance.name);
  return val;
}

ShoppingListItem _$ShoppingListItemFromJson(Map<String, dynamic> json) {
  return ShoppingListItem(
    item: json['item'] as String,
    supermarketSection: json['supermarketSection'] as String,
    checked: json['checked'] as bool,
    quantity: (json['quantity'] as num)?.toDouble(),
    unitOfMeasure: json['unitOfMeasure'] as String,
    listPosition: json['listPosition'] as int,
  );
}

Map<String, dynamic> _$ShoppingListItemToJson(ShoppingListItem instance) {
  final val = <String, dynamic>{
    'item': instance.item,
    'checked': instance.checked,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('quantity', instance.quantity);
  writeNotNull('unitOfMeasure', instance.unitOfMeasure);
  writeNotNull('supermarketSection', instance.supermarketSection);
  writeNotNull('listPosition', instance.listPosition);
  return val;
}

// **************************************************************************
// RepositoryGenerator
// **************************************************************************

// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member, non_constant_identifier_names

mixin $ShoppingListLocalAdapter on LocalAdapter<ShoppingList> {
  @override
  Map<String, Map<String, Object>> relationshipsFor([ShoppingList model]) => {};

  @override
  ShoppingList deserialize(map) {
    for (final key in relationshipsFor().keys) {
      map[key] = {
        '_': [map[key], !map.containsKey(key)],
      };
    }
    return ShoppingList.fromJson(map);
  }

  @override
  Map<String, dynamic> serialize(model) => model.toJson();
}

// ignore: must_be_immutable
class $ShoppingListHiveLocalAdapter = HiveLocalAdapter<ShoppingList>
    with $ShoppingListLocalAdapter;

class $ShoppingListRemoteAdapter = RemoteAdapter<ShoppingList>
    with BaseAdapter<ShoppingList>, ShoppingListAdapter<ShoppingList>;

//

final shoppingListLocalAdapterProvider = Provider<LocalAdapter<ShoppingList>>(
    (ref) => $ShoppingListHiveLocalAdapter(ref));

final shoppingListRemoteAdapterProvider = Provider<RemoteAdapter<ShoppingList>>(
    (ref) =>
        $ShoppingListRemoteAdapter(ref.read(shoppingListLocalAdapterProvider)));

final shoppingListRepositoryProvider =
    Provider<Repository<ShoppingList>>((ref) => Repository<ShoppingList>(ref));

final _watchShoppingList = StateNotifierProvider.autoDispose
    .family<DataStateNotifier<ShoppingList>, WatchArgs<ShoppingList>>(
        (ref, args) {
  return ref.watch(shoppingListRepositoryProvider).watchOne(args.id,
      remote: args.remote,
      params: args.params,
      headers: args.headers,
      alsoWatch: args.alsoWatch);
});

AutoDisposeStateNotifierStateProvider<DataState<ShoppingList>>
    watchShoppingList(dynamic id,
        {bool remote = true,
        Map<String, dynamic> params = const {},
        Map<String, String> headers = const {},
        AlsoWatch<ShoppingList> alsoWatch}) {
  return _watchShoppingList(WatchArgs(
          id: id,
          remote: remote,
          params: params,
          headers: headers,
          alsoWatch: alsoWatch))
      .state;
}

final _watchShoppingLists = StateNotifierProvider.autoDispose
    .family<DataStateNotifier<List<ShoppingList>>, WatchArgs<ShoppingList>>(
        (ref, args) {
  ref.maintainState = false;
  return ref.watch(shoppingListRepositoryProvider).watchAll(
      remote: args.remote, params: args.params, headers: args.headers);
});

AutoDisposeStateNotifierProvider<DataStateNotifier<List<ShoppingList>>>
    watchShoppingLists(
        {bool remote,
        Map<String, dynamic> params,
        Map<String, String> headers}) {
  return _watchShoppingLists(
      WatchArgs(remote: remote, params: params, headers: headers));
}

extension ShoppingListX on ShoppingList {
  /// Initializes "fresh" models (i.e. manually instantiated) to use
  /// [save], [delete] and so on.
  ///
  /// Pass:
  ///  - A `BuildContext` if using Flutter with Riverpod or Provider
  ///  - Nothing if using Flutter with GetIt
  ///  - A Riverpod `ProviderContainer` if using pure Dart
  ///  - Its own [Repository<ShoppingList>]
  ShoppingList init(context) {
    final repository = context is Repository<ShoppingList>
        ? context
        : internalLocatorFn(shoppingListRepositoryProvider, context);
    return repository.internalAdapter.initializeModel(this, save: true)
        as ShoppingList;
  }
}
