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
    with ChangeNotifier
    implements Saveable<T>, Revertable<T> {
  T _backup, _original;

  bool _edited;

  Originator(T original) : assert(original != null) {
    _original = original;
    _backup = _original.clone();
    _edited = false;
  }

  T update(T newValue) {
    assert(newValue != null);
    _backup = newValue;
    setEdited();
    notifyListeners();
    return _backup;
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

  T get instance => _backup;

  @protected
  void setEdited() => _edited = true;

  bool get isEdited => _edited;
}
