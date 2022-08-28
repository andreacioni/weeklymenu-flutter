import 'dart:ui';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:collection/collection.dart';
import '../models/user_preferences.dart';
import '../main.data.dart';

final userPreferenceProvider = Provider<UserPreference?>((ref) {
  final userPref = ref.userPreferences.watchAll();
  return userPref.hasModel && (userPref.model?.isNotEmpty ?? false)
      ? userPref.model![0]
      : null;
});

final supermarketSectionProvider = Provider<List<SupermarketSection>?>((ref) {
  return ref.watch(userPreferenceProvider)?.supermarketSections;
});

final supermarketSectionByNameProvider =
    Provider.family<SupermarketSection?, String?>(((ref, arg) {
  final sections = ref.watch(supermarketSectionProvider);

  return sections?.firstWhereOrNull((s) => s.name == arg);
}));

final unitOfMeasuresProvider = Provider<List<String>>((ref) {
  final userPrefs = ref.watch(userPreferenceProvider);
  return userPrefs?.unitsOfMeasure ?? STANDARD_UNIT_OF_MEASURE;
});
