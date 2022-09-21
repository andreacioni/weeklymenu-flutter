import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final recipeScreenNotifierProvider =
    StateNotifierProvider((_) => RecipeScreenStateNotifier());

@immutable
@CopyWith()
class RecipeScreenState {
  final bool editEnabled;

  RecipeScreenState({this.editEnabled = false});
}

class RecipeScreenStateNotifier extends StateNotifier<RecipeScreenState> {
  RecipeScreenStateNotifier([RecipeScreenState? state])
      : super(state ?? RecipeScreenState());
}
