import 'package:flutter_riverpod/all.dart';

import '../services/auth_service.dart';

final authServiceProvider = Provider((ref) => AuthService());

final jwtTokenProvider = FutureProvider((ref) {
  return ref.read(authServiceProvider).token;
})