import 'package:flutter_riverpod/all.dart';
import 'package:weekly_menu_app/models/recipe.dart';

import '../models/menu.dart';
import '../services/auth_service.dart';

final authServiceProvider = Provider((ref) => AuthService());

final jwtTokenProvider = FutureProvider.autoDispose((ref) {
  return ref.read(authServiceProvider).token;
});

final dailyMenuScopedProvider =
    ScopedProvider<DailyMenu>((_) => throw UnimplementedError());

final recipeOriginatorScopedProvider =
    ScopedProvider<RecipeOriginator>((_) => throw UnimplementedError());
