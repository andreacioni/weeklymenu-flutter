import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:common/configuration.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:data/repositories.dart';

import '../firebase_options.dart';
import '../services/local_preferences.dart';
import '../services/remote_config.dart';

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
  final cfg = ref.read(bootstrapConfigurationProvider);

  log("loading repositoryInitializer");
  await ref.read(repositoryInitializerProvider.future);

  log("loading local preferences");
  await ref.read(_localPreferencesFutureProvider.future);

  log("initializing firebase core");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  log("initializing remote config");
  await ref.read(remoteConfigProvider).initialize();

  if (cfg.debug) {
    CachedNetworkImage.logLevel = CacheManagerLogLevel.verbose;
  }

  if (cfg.clear) {
    log("clearing local repositories");
    final repos = ref.read(repositoryProviders);
    for (final r in repos) {
      await ref.read(r).clear();
    }
  }

  log("initialization done");
});
