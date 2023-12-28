import 'dart:async';

extension Unique<E, Id> on List<E> {
  List<E> unique([Id Function(E element)? id, bool inplace = true]) {
    final ids = Set();
    var list = inplace ? this : List<E>.from(this);
    list.retainWhere((x) => ids.add(id != null ? id(x) : x as Id));
    return list;
  }
}

extension IsBlankString on String? {
  bool get isBlank => this?.trim().isEmpty ?? true;
  bool get isNotBlank => !isBlank;
}

extension SkipElementMap<E> on List<E> {
  /// allow to return `null` value in `toElement` function. These values are
  /// skipped and not mapped
  List<R> mapNullable<R extends Object>(R? Function(E element) callback) {
    final mappedList = <R>[];
    for (final element in this) {
      final mappedValue = callback(element);
      if (mappedValue != null) {
        mappedList.add(mappedValue);
      }
    }
    return mappedList;
  }
}

extension NoDecimalWhenEqualsToInteger on double {
  String toStringAsFixedOrInt(int digits) {
    final ret = toStringAsFixed(digits);
    final intRet = toStringAsFixed(0);

    if (ret == "$intRet.${'0' * digits}") {
      return intRet;
    }

    return ret;
  }
}


extension FutureFromFutureOr<T> on FutureOr<T> {
  Future<T> toFuture() {
    if(this is Future<T>) {
      return this as Future<T>;
    }

    return Future<T>.value(this);
  }
}