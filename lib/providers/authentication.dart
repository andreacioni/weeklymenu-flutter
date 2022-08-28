import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:weekly_menu_app/providers/local_preferences.dart';

import '../services/auth_service.dart';

final authServiceProvider = FutureProvider((ref) async {
  final localPreferences = await ref.read(localPreferencesProvider.future);
  return AuthService(localPreferences);
});
