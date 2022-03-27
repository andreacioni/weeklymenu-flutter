import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final synchronizationManagerProvider = Provider((ref) {
  return SynchronizationManager();
});

class SynchronizationManager<T> {}
