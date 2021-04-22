import 'package:flutter_riverpod/all.dart';
import 'package:weekly_menu_app/models/recipe.dart';

import '../models/menu.dart';
import '../services/auth_service.dart';

final authServiceProvider = Provider((ref) => AuthService());

final jwtTokenProvider = FutureProvider.autoDispose((ref) {
  return ref.read(authServiceProvider).token;
});

final dailyMenuScopedProvider = ScopedProvider<DailyMenu>(null);

final recipeFutureProvider =
    FutureProvider.autoDispose.family<Recipe, String>((ref, recipeId) {
  final recipeRepo = ref.read(recipesRepositoryProvider);
  return recipeRepo.findOne(recipeId);
});
final recipeOriginatorProvider = ChangeNotifierProvider.autoDispose
    .family<RecipeOriginator, String>((ref, recipeId) {
  final asyncRecipe = ref.watch(recipeFutureProvider(recipeId));
  final recipe = asyncRecipe.data?.value;
  return recipe != null ? RecipeOriginator(recipe) : null;
});
