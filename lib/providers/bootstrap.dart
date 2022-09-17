import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:weekly_menu_app/services/local_preferences.dart';

import '../globals/constants.dart';
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

  log("set logging level");
  for (final repositoryProvider in repositoryProviders.values) {
    ref.read(repositoryProvider).logLevel = debug ? 2 : 0;
  }

  if (debug) {
    CachedNetworkImage.logLevel = CacheManagerLogLevel.verbose;
  }
});
