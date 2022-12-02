import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../widgets/screens/recipe_screen/recipe_screen_state_notifier.dart';
import '../widgets/homepage_screen_notifier.dart';

final recipeScreenNotifierProvider = StateNotifierProvider.autoDispose<
    RecipeScreenStateNotifier,
    RecipeScreenState>((ref) => throw UnimplementedError());

final homepageScreenNotifierProvider = StateNotifierProvider.autoDispose<
    HomepageScreenStateNotifier,
    HomepageScreenState>((ref) => throw UnimplementedError());
