import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../services/token_service.dart';
import '../services/auth_service.dart';
import 'bootstrap.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final tokenServiceProvider = Provider<TokenService>((ref) {
  final localPreferences = ref.read(localPreferencesProvider);
  final authService = ref.read(authServiceProvider);
  return TokenService(
      localPreferences: localPreferences, authService: authService);
});
