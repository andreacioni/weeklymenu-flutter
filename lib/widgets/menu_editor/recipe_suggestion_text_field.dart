import 'package:flutter/material.dart';
import 'package:flutter_data/flutter_data.dart' hide Provider;
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/enums/meal.dart';
import '../../models/menu.dart';
import '../../globals/utils.dart';
import '../../models/recipe.dart';

class RecipeSuggestionTextField extends StatefulWidget {
  final Recipe? value;
  final DailyMenu dailyMenu;
  final String? hintText;
  final bool autofocus;
  final bool showSuggestions;
  final void Function(Recipe)? onRecipeSelected;
  final void Function(dynamic)? onSubmitted;
  final Function()? onTap;
  final Function(bool) onFocusChanged;
  final bool enabled;
  final Meal meal;

  RecipeSuggestionTextField(
    this.meal, {
    this.value,
    required this.dailyMenu,
    this.onRecipeSelected,
    this.onSubmitted,
    this.showSuggestions = true,
    this.onTap,
    required this.onFocusChanged,
    this.hintText,
    this.autofocus = false,
    this.enabled = true,
  });

  @override
  _RecipeSuggestionTextFieldState createState() =>
      _RecipeSuggestionTextFieldState();
}

class _RecipeSuggestionTextFieldState extends State<RecipeSuggestionTextField> {
  late FocusNode focusNode;

  @override
  void initState() {
    focusNode = FocusNode();
    focusNode.addListener(() => widget.onFocusChanged(focusNode.hasFocus));
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController textEditingController = TextEditingController();
    if (widget.value != null) {
      textEditingController.text = widget.value!.name;
    }
    return HookConsumer(builder: (context, ref, _) {
      final recipeRepository = ref.read(recipesRepositoryProvider);

      return TypeAheadField<Recipe>(
        textFieldConfiguration: TextFieldConfiguration(
          controller: textEditingController,
          enabled: widget.enabled,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: widget.hintText,
          ),
          onSubmitted: widget.onSubmitted,
          onTap: focusNode.hasFocus ? widget.onTap : null,
          focusNode: focusNode,
          autofocus: widget.autofocus,
        ),
        itemBuilder: _itemBuilder,
        onSuggestionSelected: _onSuggestionSelected,
        suggestionsCallback: (pattern) =>
            _suggestionsCallback(pattern, widget.dailyMenu, recipeRepository),
        hideOnEmpty: true,
        autoFlipDirection: true,
      );
    });
  }

  void _onSuggestionSelected(Recipe item) {
    if (widget.onRecipeSelected != null) {
      widget.onRecipeSelected!(item);
    }
  }

  Future<List<Recipe>> _suggestionsCallback(String pattern, DailyMenu dailyMenu,
      Repository<Recipe> recipesRepository) async {
    final availableRecipes = await recipesRepository.findAll();
    final alreadyPresentRecipes =
        dailyMenu.getMenuByMeal(widget.meal)?.recipes ?? [];
    final List<Recipe> suggestions = [];

    suggestions.addAll(availableRecipes
        .where((ing) => stringContains(ing.name, pattern))
        .toList());

    if (alreadyPresentRecipes.isNotEmpty) {
      suggestions.removeWhere(
          (suggestion) => (alreadyPresentRecipes.contains(suggestion.id)));
    }

    return suggestions;
  }

  Widget _itemBuilder(BuildContext buildContext, Recipe recipe) {
    return ListTile(
      title: Text(recipe.name),
      trailing: Icon(Icons.check_box),
    );
  }
}
