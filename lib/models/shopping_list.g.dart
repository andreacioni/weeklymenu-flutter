// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopping_list.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ShoppingListCWProxy {
  ShoppingList id(String? id);

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
  ShoppingList id(String? id) => this(id: id);

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
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String?,
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
  /// Returns a callable class that can be used as follows: `instanceOfclass ShoppingList extends BaseModel2<ShoppingList>.name.copyWith(...)` or like so:`instanceOfclass ShoppingList extends BaseModel2<ShoppingList>.name.copyWith.fieldName(...)`.
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
// IsarCollectionGenerator
// **************************************************************************

// ignore_for_file: duplicate_ignore, non_constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast

extension GetShoppingListCollection on Isar {
  IsarCollection<ShoppingList> get shoppingLists {
    return getCollection('ShoppingList');
  }
}

final ShoppingListSchema = CollectionSchema(
  name: 'ShoppingList',
  schema:
      '{"name":"ShoppingList","idName":"internalId","properties":[{"name":"id","type":"String"},{"name":"insertTimestamp","type":"Long"},{"name":"name","type":"String"},{"name":"updateTimestamp","type":"Long"}],"indexes":[{"name":"id","unique":false,"properties":[{"name":"id","type":"Hash","caseSensitive":true}]}],"links":[]}',
  nativeAdapter: const _ShoppingListNativeAdapter(),
  webAdapter: const _ShoppingListWebAdapter(),
  idName: 'internalId',
  propertyIds: {'id': 0, 'insertTimestamp': 1, 'name': 2, 'updateTimestamp': 3},
  listProperties: {},
  indexIds: {'id': 0},
  indexTypes: {
    'id': [
      NativeIndexType.stringHash,
    ]
  },
  linkIds: {},
  backlinkIds: {},
  linkedCollections: [],
  getId: (obj) {
    if (obj.internalId == Isar.autoIncrement) {
      return null;
    } else {
      return obj.internalId;
    }
  },
  setId: null,
  getLinks: (obj) => [],
  version: 2,
);

class _ShoppingListWebAdapter extends IsarWebTypeAdapter<ShoppingList> {
  const _ShoppingListWebAdapter();

  @override
  Object serialize(
      IsarCollection<ShoppingList> collection, ShoppingList object) {
    final jsObj = IsarNative.newJsObject();
    IsarNative.jsObjectSet(jsObj, 'id', object.id);
    IsarNative.jsObjectSet(jsObj, 'insertTimestamp', object.insertTimestamp);
    IsarNative.jsObjectSet(jsObj, 'internalId', object.internalId);
    IsarNative.jsObjectSet(jsObj, 'name', object.name);
    IsarNative.jsObjectSet(jsObj, 'updateTimestamp', object.updateTimestamp);
    return jsObj;
  }

  @override
  ShoppingList deserialize(
      IsarCollection<ShoppingList> collection, dynamic jsObj) {
    final object = ShoppingList(
      id: IsarNative.jsObjectGet(jsObj, 'id'),
      name: IsarNative.jsObjectGet(jsObj, 'name'),
    );
    return object;
  }

  @override
  P deserializeProperty<P>(Object jsObj, String propertyName) {
    switch (propertyName) {
      case 'id':
        return (IsarNative.jsObjectGet(jsObj, 'id')) as P;
      case 'insertTimestamp':
        return (IsarNative.jsObjectGet(jsObj, 'insertTimestamp') ??
            double.negativeInfinity) as P;
      case 'internalId':
        return (IsarNative.jsObjectGet(jsObj, 'internalId')) as P;
      case 'name':
        return (IsarNative.jsObjectGet(jsObj, 'name')) as P;
      case 'updateTimestamp':
        return (IsarNative.jsObjectGet(jsObj, 'updateTimestamp') ??
            double.negativeInfinity) as P;
      default:
        throw 'Illegal propertyName';
    }
  }

  @override
  void attachLinks(Isar isar, int id, ShoppingList object) {}
}

class _ShoppingListNativeAdapter extends IsarNativeTypeAdapter<ShoppingList> {
  const _ShoppingListNativeAdapter();

  @override
  void serialize(
      IsarCollection<ShoppingList> collection,
      IsarRawObject rawObj,
      ShoppingList object,
      int staticSize,
      List<int> offsets,
      AdapterAlloc alloc) {
    var dynamicSize = 0;
    final value0 = object.id;
    IsarUint8List? _id;
    if (value0 != null) {
      _id = IsarBinaryWriter.utf8Encoder.convert(value0);
    }
    dynamicSize += (_id?.length ?? 0) as int;
    final value1 = object.insertTimestamp;
    final _insertTimestamp = value1;
    final value2 = object.name;
    IsarUint8List? _name;
    if (value2 != null) {
      _name = IsarBinaryWriter.utf8Encoder.convert(value2);
    }
    dynamicSize += (_name?.length ?? 0) as int;
    final value3 = object.updateTimestamp;
    final _updateTimestamp = value3;
    final size = staticSize + dynamicSize;

    rawObj.buffer = alloc(size);
    rawObj.buffer_length = size;
    final buffer = IsarNative.bufAsBytes(rawObj.buffer, size);
    final writer = IsarBinaryWriter(buffer, staticSize);
    writer.writeBytes(offsets[0], _id);
    writer.writeLong(offsets[1], _insertTimestamp);
    writer.writeBytes(offsets[2], _name);
    writer.writeLong(offsets[3], _updateTimestamp);
  }

  @override
  ShoppingList deserialize(IsarCollection<ShoppingList> collection, int id,
      IsarBinaryReader reader, List<int> offsets) {
    final object = ShoppingList(
      id: reader.readStringOrNull(offsets[0]),
      name: reader.readStringOrNull(offsets[2]),
    );
    return object;
  }

  @override
  P deserializeProperty<P>(
      int id, IsarBinaryReader reader, int propertyIndex, int offset) {
    switch (propertyIndex) {
      case -1:
        return id as P;
      case 0:
        return (reader.readStringOrNull(offset)) as P;
      case 1:
        return (reader.readLong(offset)) as P;
      case 2:
        return (reader.readStringOrNull(offset)) as P;
      case 3:
        return (reader.readLong(offset)) as P;
      default:
        throw 'Illegal propertyIndex';
    }
  }

  @override
  void attachLinks(Isar isar, int id, ShoppingList object) {}
}

extension ShoppingListQueryWhereSort
    on QueryBuilder<ShoppingList, ShoppingList, QWhere> {
  QueryBuilder<ShoppingList, ShoppingList, QAfterWhere> anyInternalId() {
    return addWhereClauseInternal(const WhereClause(indexName: null));
  }

  QueryBuilder<ShoppingList, ShoppingList, QAfterWhere> anyId() {
    return addWhereClauseInternal(const WhereClause(indexName: 'id'));
  }
}

extension ShoppingListQueryWhere
    on QueryBuilder<ShoppingList, ShoppingList, QWhereClause> {
  QueryBuilder<ShoppingList, ShoppingList, QAfterWhereClause> internalIdEqualTo(
      int? internalId) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [internalId],
      includeLower: true,
      upper: [internalId],
      includeUpper: true,
    ));
  }

  QueryBuilder<ShoppingList, ShoppingList, QAfterWhereClause>
      internalIdNotEqualTo(int? internalId) {
    if (whereSortInternal == Sort.asc) {
      return addWhereClauseInternal(WhereClause(
        indexName: null,
        upper: [internalId],
        includeUpper: false,
      )).addWhereClauseInternal(WhereClause(
        indexName: null,
        lower: [internalId],
        includeLower: false,
      ));
    } else {
      return addWhereClauseInternal(WhereClause(
        indexName: null,
        lower: [internalId],
        includeLower: false,
      )).addWhereClauseInternal(WhereClause(
        indexName: null,
        upper: [internalId],
        includeUpper: false,
      ));
    }
  }

  QueryBuilder<ShoppingList, ShoppingList, QAfterWhereClause>
      internalIdGreaterThan(
    int? internalId, {
    bool include = false,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [internalId],
      includeLower: include,
    ));
  }

  QueryBuilder<ShoppingList, ShoppingList, QAfterWhereClause>
      internalIdLessThan(
    int? internalId, {
    bool include = false,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      upper: [internalId],
      includeUpper: include,
    ));
  }

  QueryBuilder<ShoppingList, ShoppingList, QAfterWhereClause> internalIdBetween(
    int? lowerInternalId,
    int? upperInternalId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [lowerInternalId],
      includeLower: includeLower,
      upper: [upperInternalId],
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<ShoppingList, ShoppingList, QAfterWhereClause> idEqualTo(
      String? id) {
    return addWhereClauseInternal(WhereClause(
      indexName: 'id',
      lower: [id],
      includeLower: true,
      upper: [id],
      includeUpper: true,
    ));
  }

  QueryBuilder<ShoppingList, ShoppingList, QAfterWhereClause> idNotEqualTo(
      String? id) {
    if (whereSortInternal == Sort.asc) {
      return addWhereClauseInternal(WhereClause(
        indexName: 'id',
        upper: [id],
        includeUpper: false,
      )).addWhereClauseInternal(WhereClause(
        indexName: 'id',
        lower: [id],
        includeLower: false,
      ));
    } else {
      return addWhereClauseInternal(WhereClause(
        indexName: 'id',
        lower: [id],
        includeLower: false,
      )).addWhereClauseInternal(WhereClause(
        indexName: 'id',
        upper: [id],
        includeUpper: false,
      ));
    }
  }

  QueryBuilder<ShoppingList, ShoppingList, QAfterWhereClause> idIsNull() {
    return addWhereClauseInternal(const WhereClause(
      indexName: 'id',
      upper: [null],
      includeUpper: true,
      lower: [null],
      includeLower: true,
    ));
  }

  QueryBuilder<ShoppingList, ShoppingList, QAfterWhereClause> idIsNotNull() {
    return addWhereClauseInternal(const WhereClause(
      indexName: 'id',
      lower: [null],
      includeLower: false,
    ));
  }
}

extension ShoppingListQueryFilter
    on QueryBuilder<ShoppingList, ShoppingList, QFilterCondition> {
  QueryBuilder<ShoppingList, ShoppingList, QAfterFilterCondition> idIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'id',
      value: null,
    ));
  }

  QueryBuilder<ShoppingList, ShoppingList, QAfterFilterCondition> idEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'id',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<ShoppingList, ShoppingList, QAfterFilterCondition> idGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'id',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<ShoppingList, ShoppingList, QAfterFilterCondition> idLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'id',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<ShoppingList, ShoppingList, QAfterFilterCondition> idBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'id',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<ShoppingList, ShoppingList, QAfterFilterCondition> idStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'id',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<ShoppingList, ShoppingList, QAfterFilterCondition> idEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'id',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<ShoppingList, ShoppingList, QAfterFilterCondition> idContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'id',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<ShoppingList, ShoppingList, QAfterFilterCondition> idMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'id',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<ShoppingList, ShoppingList, QAfterFilterCondition>
      insertTimestampEqualTo(int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'insertTimestamp',
      value: value,
    ));
  }

  QueryBuilder<ShoppingList, ShoppingList, QAfterFilterCondition>
      insertTimestampGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'insertTimestamp',
      value: value,
    ));
  }

  QueryBuilder<ShoppingList, ShoppingList, QAfterFilterCondition>
      insertTimestampLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'insertTimestamp',
      value: value,
    ));
  }

  QueryBuilder<ShoppingList, ShoppingList, QAfterFilterCondition>
      insertTimestampBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'insertTimestamp',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<ShoppingList, ShoppingList, QAfterFilterCondition>
      internalIdIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'internalId',
      value: null,
    ));
  }

  QueryBuilder<ShoppingList, ShoppingList, QAfterFilterCondition>
      internalIdEqualTo(int? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'internalId',
      value: value,
    ));
  }

  QueryBuilder<ShoppingList, ShoppingList, QAfterFilterCondition>
      internalIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'internalId',
      value: value,
    ));
  }

  QueryBuilder<ShoppingList, ShoppingList, QAfterFilterCondition>
      internalIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'internalId',
      value: value,
    ));
  }

  QueryBuilder<ShoppingList, ShoppingList, QAfterFilterCondition>
      internalIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'internalId',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<ShoppingList, ShoppingList, QAfterFilterCondition> nameIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'name',
      value: null,
    ));
  }

  QueryBuilder<ShoppingList, ShoppingList, QAfterFilterCondition> nameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<ShoppingList, ShoppingList, QAfterFilterCondition>
      nameGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<ShoppingList, ShoppingList, QAfterFilterCondition> nameLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<ShoppingList, ShoppingList, QAfterFilterCondition> nameBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'name',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<ShoppingList, ShoppingList, QAfterFilterCondition>
      nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<ShoppingList, ShoppingList, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<ShoppingList, ShoppingList, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<ShoppingList, ShoppingList, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'name',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<ShoppingList, ShoppingList, QAfterFilterCondition>
      updateTimestampEqualTo(int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'updateTimestamp',
      value: value,
    ));
  }

  QueryBuilder<ShoppingList, ShoppingList, QAfterFilterCondition>
      updateTimestampGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'updateTimestamp',
      value: value,
    ));
  }

  QueryBuilder<ShoppingList, ShoppingList, QAfterFilterCondition>
      updateTimestampLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'updateTimestamp',
      value: value,
    ));
  }

  QueryBuilder<ShoppingList, ShoppingList, QAfterFilterCondition>
      updateTimestampBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'updateTimestamp',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }
}

extension ShoppingListQueryLinks
    on QueryBuilder<ShoppingList, ShoppingList, QFilterCondition> {}

extension ShoppingListQueryWhereSortBy
    on QueryBuilder<ShoppingList, ShoppingList, QSortBy> {
  QueryBuilder<ShoppingList, ShoppingList, QAfterSortBy> sortById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<ShoppingList, ShoppingList, QAfterSortBy> sortByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<ShoppingList, ShoppingList, QAfterSortBy>
      sortByInsertTimestamp() {
    return addSortByInternal('insertTimestamp', Sort.asc);
  }

  QueryBuilder<ShoppingList, ShoppingList, QAfterSortBy>
      sortByInsertTimestampDesc() {
    return addSortByInternal('insertTimestamp', Sort.desc);
  }

  QueryBuilder<ShoppingList, ShoppingList, QAfterSortBy> sortByInternalId() {
    return addSortByInternal('internalId', Sort.asc);
  }

  QueryBuilder<ShoppingList, ShoppingList, QAfterSortBy>
      sortByInternalIdDesc() {
    return addSortByInternal('internalId', Sort.desc);
  }

  QueryBuilder<ShoppingList, ShoppingList, QAfterSortBy> sortByName() {
    return addSortByInternal('name', Sort.asc);
  }

  QueryBuilder<ShoppingList, ShoppingList, QAfterSortBy> sortByNameDesc() {
    return addSortByInternal('name', Sort.desc);
  }

  QueryBuilder<ShoppingList, ShoppingList, QAfterSortBy>
      sortByUpdateTimestamp() {
    return addSortByInternal('updateTimestamp', Sort.asc);
  }

  QueryBuilder<ShoppingList, ShoppingList, QAfterSortBy>
      sortByUpdateTimestampDesc() {
    return addSortByInternal('updateTimestamp', Sort.desc);
  }
}

extension ShoppingListQueryWhereSortThenBy
    on QueryBuilder<ShoppingList, ShoppingList, QSortThenBy> {
  QueryBuilder<ShoppingList, ShoppingList, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<ShoppingList, ShoppingList, QAfterSortBy> thenByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<ShoppingList, ShoppingList, QAfterSortBy>
      thenByInsertTimestamp() {
    return addSortByInternal('insertTimestamp', Sort.asc);
  }

  QueryBuilder<ShoppingList, ShoppingList, QAfterSortBy>
      thenByInsertTimestampDesc() {
    return addSortByInternal('insertTimestamp', Sort.desc);
  }

  QueryBuilder<ShoppingList, ShoppingList, QAfterSortBy> thenByInternalId() {
    return addSortByInternal('internalId', Sort.asc);
  }

  QueryBuilder<ShoppingList, ShoppingList, QAfterSortBy>
      thenByInternalIdDesc() {
    return addSortByInternal('internalId', Sort.desc);
  }

  QueryBuilder<ShoppingList, ShoppingList, QAfterSortBy> thenByName() {
    return addSortByInternal('name', Sort.asc);
  }

  QueryBuilder<ShoppingList, ShoppingList, QAfterSortBy> thenByNameDesc() {
    return addSortByInternal('name', Sort.desc);
  }

  QueryBuilder<ShoppingList, ShoppingList, QAfterSortBy>
      thenByUpdateTimestamp() {
    return addSortByInternal('updateTimestamp', Sort.asc);
  }

  QueryBuilder<ShoppingList, ShoppingList, QAfterSortBy>
      thenByUpdateTimestampDesc() {
    return addSortByInternal('updateTimestamp', Sort.desc);
  }
}

extension ShoppingListQueryWhereDistinct
    on QueryBuilder<ShoppingList, ShoppingList, QDistinct> {
  QueryBuilder<ShoppingList, ShoppingList, QDistinct> distinctById(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('id', caseSensitive: caseSensitive);
  }

  QueryBuilder<ShoppingList, ShoppingList, QDistinct>
      distinctByInsertTimestamp() {
    return addDistinctByInternal('insertTimestamp');
  }

  QueryBuilder<ShoppingList, ShoppingList, QDistinct> distinctByInternalId() {
    return addDistinctByInternal('internalId');
  }

  QueryBuilder<ShoppingList, ShoppingList, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('name', caseSensitive: caseSensitive);
  }

  QueryBuilder<ShoppingList, ShoppingList, QDistinct>
      distinctByUpdateTimestamp() {
    return addDistinctByInternal('updateTimestamp');
  }
}

extension ShoppingListQueryProperty
    on QueryBuilder<ShoppingList, ShoppingList, QQueryProperty> {
  QueryBuilder<ShoppingList, String?, QQueryOperations> idProperty() {
    return addPropertyNameInternal('id');
  }

  QueryBuilder<ShoppingList, int, QQueryOperations> insertTimestampProperty() {
    return addPropertyNameInternal('insertTimestamp');
  }

  QueryBuilder<ShoppingList, int?, QQueryOperations> internalIdProperty() {
    return addPropertyNameInternal('internalId');
  }

  QueryBuilder<ShoppingList, String?, QQueryOperations> nameProperty() {
    return addPropertyNameInternal('name');
  }

  QueryBuilder<ShoppingList, int, QQueryOperations> updateTimestampProperty() {
    return addPropertyNameInternal('updateTimestamp');
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShoppingList _$ShoppingListFromJson(Map json) => ShoppingList(
      id: json['_id'] as String?,
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => ShoppingListItem.fromJson(
                  Map<String, dynamic>.from(e as Map)))
              .toList() ??
          [],
      name: json['name'] as String?,
    );

Map<String, dynamic> _$ShoppingListToJson(ShoppingList instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('_id', instance.id);
  val['items'] = instance.items.map((e) => e.toJson()).toList();
  writeNotNull('name', instance.name);
  return val;
}

ShoppingListItem _$ShoppingListItemFromJson(Map json) => ShoppingListItem(
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
