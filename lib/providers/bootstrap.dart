import 'dart:developer';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:weekly_menu_app/services/local_preferences.dart';

import '../main.data.dart';
import 'local_preferences.dart';

final _localPreferencesFutureProvider = FutureProvider<LocalPreferences>(
    (_) async => await LocalPreferences.getInstance());

final localPreferencesProvider = Provider<LocalPreferences>((ref) {
  return ref.watch(_localPreferencesFutureProvider).when(
      data: (localPreferences) => localPreferences,
      error: (_, __) =>
          throw StateError('dependency not initialized in bootsrap phase?'),
      loading: () =>
          throw StateError('dependency not initialized in bootsrap phase?'));
});

final bootstrapDependenciesProvider = FutureProvider<void>((ref) async {
  log("loading repositoryInitializer");
  await ref.read(repositoryInitializerProvider.future);

  log("loading local preferences");
  await ref.read(_localPreferencesFutureProvider.future);
});
