import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:common/configuration.dart';
import 'package:data/configuration/local_preferences.dart';
import 'package:data/configuration/remote_config.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:data/repositories.dart';

import '../firebase_options.dart';

final bootstrapDependenciesProvider = FutureProvider<void>((ref) async {
  final cfg = ref.read(bootstrapConfigurationProvider);

  log("loading repositoryInitializer");
  await ref.read(repositoryInitializerProvider.future);

  log("loading local preferences");
  await ref.read(localPreferencesFutureProvider.future);

  log("initializing firebase core");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  log("initializing remote config");
  await ref.read(remoteConfigProvider).initialize();
  if (cfg.debug) {
    await ref.read(remoteConfigProvider).reload();
  }
  ref.read(remoteConfigProvider).logCurrentConfiguration();

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
