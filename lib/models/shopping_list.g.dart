// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopping_list.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ShoppingListCWProxy {
  ShoppingList id(String id);

  ShoppingList items(List<ShoppingListItem> items);

  ShoppingList name(String? name);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ShoppingList(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ShoppingList(...).copyWith(id: 12, name: "My name")
  /// ````
  ShoppingList call({
    String? id,
    List<ShoppingListItem>? items,
    String? name,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfShoppingList.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfShoppingList.copyWith.fieldName(...)`
class _$ShoppingListCWProxyImpl implements _$ShoppingListCWProxy {
  final ShoppingList _value;

  const _$ShoppingListCWProxyImpl(this._value);

  @override
  ShoppingList id(String id) => this(id: id);

  @override
  ShoppingList items(List<ShoppingListItem> items) => this(items: items);

  @override
  ShoppingList name(String? name) => this(name: name);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ShoppingList(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ShoppingList(...).copyWith(id: 12, name: "My name")
  /// ````
  ShoppingList call({
    Object? id = const $CopyWithPlaceholder(),
    Object? items = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
  }) {
    return ShoppingList(
      id: id == const $CopyWithPlaceholder() || id == null
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      items: items == const $CopyWithPlaceholder() || items == null
          ? _value.items
          // ignore: cast_nullable_to_non_nullable
          : items as List<ShoppingListItem>,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String?,
    );
  }
}

extension $ShoppingListCopyWith on ShoppingList {
  /// Returns a callable class that can be used as follows: `instanceOfclass ShoppingList extends BaseModel<ShoppingList>.name.copyWith(...)` or like so:`instanceOfclass ShoppingList extends BaseModel<ShoppingList>.name.copyWith.fieldName(...)`.
  _$ShoppingListCWProxy get copyWith => _$ShoppingListCWProxyImpl(this);
}

abstract class _$ShoppingListItemCWProxy {
  ShoppingListItem checked(bool checked);

  ShoppingListItem item(String item);

  ShoppingListItem listPosition(int? listPosition);

  ShoppingListItem quantity(double? quantity);

  ShoppingListItem supermarketSection(String? supermarketSection);

  ShoppingListItem unitOfMeasure(String? unitOfMeasure);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ShoppingListItem(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ShoppingListItem(...).copyWith(id: 12, name: "My name")
  /// ````
  ShoppingListItem call({
    bool? checked,
    String? item,
    int? listPosition,
    double? quantity,
    String? supermarketSection,
    String? unitOfMeasure,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfShoppingListItem.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfShoppingListItem.copyWith.fieldName(...)`
class _$ShoppingListItemCWProxyImpl implements _$ShoppingListItemCWProxy {
  final ShoppingListItem _value;

  const _$ShoppingListItemCWProxyImpl(this._value);

  @override
  ShoppingListItem checked(bool checked) => this(checked: checked);

  @override
  ShoppingListItem item(String item) => this(item: item);

  @override
  ShoppingListItem listPosition(int? listPosition) =>
      this(listPosition: listPosition);

  @override
  ShoppingListItem quantity(double? quantity) => this(quantity: quantity);

  @override
  ShoppingListItem supermarketSection(String? supermarketSection) =>
      this(supermarketSection: supermarketSection);

  @override
  ShoppingListItem unitOfMeasure(String? unitOfMeasure) =>
      this(unitOfMeasure: unitOfMeasure);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ShoppingListItem(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ShoppingListItem(...).copyWith(id: 12, name: "My name")
  /// ````
  ShoppingListItem call({
    Object? checked = const $CopyWithPlaceholder(),
    Object? item = const $CopyWithPlaceholder(),
    Object? listPosition = const $CopyWithPlaceholder(),
    Object? quantity = const $CopyWithPlaceholder(),
    Object? supermarketSection = const $CopyWithPlaceholder(),
    Object? unitOfMeasure = const $CopyWithPlaceholder(),
  }) {
    return ShoppingListItem(
      checked: checked == const $CopyWithPlaceholder() || checked == null
          ? _value.checked
          // ignore: cast_nullable_to_non_nullable
          : checked as bool,
      item: item == const $CopyWithPlaceholder() || item == null
          ? _value.item
          // ignore: cast_nullable_to_non_nullable
          : item as String,
      listPosition: listPosition == const $CopyWithPlaceholder()
          ? _value.listPosition
          // ignore: cast_nullable_to_non_nullable
          : listPosition as int?,
      quantity: quantity == const $CopyWithPlaceholder()
          ? _value.quantity
          // ignore: cast_nullable_to_non_nullable
          : quantity as double?,
      supermarketSection: supermarketSection == const $CopyWithPlaceholder()
          ? _value.supermarketSection
          // ignore: cast_nullable_to_non_nullable
          : supermarketSection as String?,
      unitOfMeasure: unitOfMeasure == const $CopyWithPlaceholder()
          ? _value.unitOfMeasure
          // ignore: cast_nullable_to_non_nullable
          : unitOfMeasure as String?,
    );
  }
}

extension $ShoppingListItemCopyWith on ShoppingListItem {
  /// Returns a callable class that can be used as follows: `instanceOfclass ShoppingListItem with ChangeNotifier.name.copyWith(...)` or like so:`instanceOfclass ShoppingListItem with ChangeNotifier.name.copyWith.fieldName(...)`.
  _$ShoppingListItemCWProxy get copyWith => _$ShoppingListItemCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShoppingList _$ShoppingListFromJson(Map<String, dynamic> json) => ShoppingList(
      id: json['_id'] as String,
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => ShoppingListItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      name: json['name'] as String?,
    );

Map<String, dynamic> _$ShoppingListToJson(ShoppingList instance) {
  final val = <String, dynamic>{
    '_id': instance.id,
    'items': instance.items.map((e) => e.toJson()).toList(),
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('name', instance.name);
  return val;
}

ShoppingListItem _$ShoppingListItemFromJson(Map<String, dynamic> json) =>
    ShoppingListItem(
      item: json['item'] as String,
      supermarketSection: json['supermarketSection'] as String?,
      checked: json['checked'] as bool? ?? false,
      quantity: (json['quantity'] as num?)?.toDouble(),
      unitOfMeasure: json['unitOfMeasure'] as String?,
      listPosition: json['listPosition'] as int?,
    );

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
  Map<String, Map<String, Object?>> relationshipsFor([ShoppingList? model]) =>
      {};

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

final shoppingListsLocalAdapterProvider = Provider<LocalAdapter<ShoppingList>>(
    (ref) => $ShoppingListHiveLocalAdapter(ref.read));

final shoppingListsRemoteAdapterProvider =
    Provider<RemoteAdapter<ShoppingList>>((ref) => $ShoppingListRemoteAdapter(
        ref.watch(shoppingListsLocalAdapterProvider),
        shoppingListProvider,
        shoppingListsProvider));

final shoppingListsRepositoryProvider = Provider<Repository<ShoppingList>>(
    (ref) => Repository<ShoppingList>(ref.read));

final _shoppingListProvider = StateNotifierProvider.autoDispose.family<
    DataStateNotifier<ShoppingList?>,
    DataState<ShoppingList?>,
    WatchArgs<ShoppingList>>((ref, args) {
  return ref.watch(shoppingListsRepositoryProvider).watchOneNotifier(args.id!,
      remote: args.remote,
      params: args.params,
      headers: args.headers,
      alsoWatch: args.alsoWatch);
});

AutoDisposeStateNotifierProvider<DataStateNotifier<ShoppingList?>,
        DataState<ShoppingList?>>
    shoppingListProvider(Object? id,
        {bool? remote,
        Map<String, dynamic>? params,
        Map<String, String>? headers,
        AlsoWatch<ShoppingList>? alsoWatch}) {
  return _shoppingListProvider(WatchArgs(
      id: id,
      remote: remote,
      params: params,
      headers: headers,
      alsoWatch: alsoWatch));
}

final _shoppingListsProvider = StateNotifierProvider.autoDispose.family<
    DataStateNotifier<List<ShoppingList>>,
    DataState<List<ShoppingList>>,
    WatchArgs<ShoppingList>>((ref, args) {
  return ref.watch(shoppingListsRepositoryProvider).watchAllNotifier(
      remote: args.remote,
      params: args.params,
      headers: args.headers,
      syncLocal: args.syncLocal);
});

AutoDisposeStateNotifierProvider<DataStateNotifier<List<ShoppingList>>,
        DataState<List<ShoppingList>>>
    shoppingListsProvider(
        {bool? remote,
        Map<String, dynamic>? params,
        Map<String, String>? headers,
        bool? syncLocal}) {
  return _shoppingListsProvider(WatchArgs(
      remote: remote, params: params, headers: headers, syncLocal: syncLocal));
}

extension ShoppingListDataX on ShoppingList {
  /// Initializes "fresh" models (i.e. manually instantiated) to use
  /// [save], [delete] and so on.
  ///
  /// Can be obtained via `ref.read`, `container.read`
  ShoppingList init(Reader read, {bool save = true}) {
    final repository = internalLocatorFn(shoppingListsRepositoryProvider, read);
    final updatedModel =
        repository.remoteAdapter.initializeModel(this, save: save);
    return save ? updatedModel : this;
  }
}

extension ShoppingListDataRepositoryX on Repository<ShoppingList> {
  BaseAdapter<ShoppingList> get baseAdapter =>
      remoteAdapter as BaseAdapter<ShoppingList>;
  ShoppingListAdapter<ShoppingList> get shoppingListAdapter =>
      remoteAdapter as ShoppingListAdapter<ShoppingList>;
}
