import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:weekly_menu_app/services/local_preferences.dart';

final localPreferencesProvider = FutureProvider<LocalPreferences>(
    (_) async => await LocalPreferences.getInstance());
