import 'package:flutter/foundation.dart';

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

abstract class Originator<T extends Cloneable<T>>
    implements Saveable<T>, Revertable<T> {
  T _backup, _original;

  bool _edited;

  Originator(T original) {
    _original = original;
    _backup = _original.clone();
    _edited = false;
  }

  @override
  T save() {
    _original = _backup;
    _backup = _original.clone();
    _edited = false;
    return _original;
  }

  @override
  T revert() {
    _backup = _original.clone();
    _edited = false;
    return _backup;
  }

  @protected
  T get instance => _backup;

  void setEdited() => _edited = true;

  bool get isEdited => _edited;
}
