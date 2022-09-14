import 'dart:developer';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:weekly_menu_app/services/local_preferences.dart';

import '../main.data.dart';
import 'local_preferences.dart';

final bootstrapDependenciesProvider = FutureProvider<void>((ref) async {
  log("loading repositoryInitializer");
  await ref.read(repositoryInitializerProvider.future);

  log("loading local preferences");
  await ref.read(localPreferencesProvider.future);
});
