import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

abstract class Saveable<T> {
  T save();
}

abstract class Cloneable<T> {
  T clone();
}

abstract class Revertable<T> {
  T revert();
}

abstract class CloneableAndSaveable<T> implements Cloneable<T>, Saveable<T> {}

abstract class Originator<T extends Cloneable<T>> extends StateNotifier<T>
    implements Saveable<T>, Revertable<T> {
  T _backup;

  bool _edited;

  Originator(T original)
      : _backup = original.clone(),
        _edited = false,
        super(original);

  T update(T newValue) {
    state = newValue;
    setEdited();
    return state;
  }

  @override
  T save() {
    _backup = state.clone();
    _edited = false;
    return state;
  }

  @override
  T revert() {
    state = _backup;
    _edited = false;
    return _backup;
  }

  T get instance => state;

  @protected
  void setEdited() => _edited = true;

  bool get isEdited => _edited;
}
