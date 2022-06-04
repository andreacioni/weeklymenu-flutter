import 'package:flutter/material.dart';
import 'package:flutter_data/flutter_data.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../globals/utils.dart';
import '../../models/enums/meal.dart';
import '../../models/recipe.dart';
import '../base_dialog.dart';

class RecipeSelectionDialog extends StatefulWidget {
  final String title;
  const RecipeSelectionDialog({Key? key, required this.title})
      : super(key: key);

  @override
  State<RecipeSelectionDialog> createState() => _RecipeSelectionDialogState();
}

class _RecipeSelectionDialogState extends State<RecipeSelectionDialog> {
  String recipeText;
  Recipe? recipe;
  Meal? meal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BaseDialog<Recipe>(
      title: title,
      subtitle: 'Add recipe to meal',
      children: [
        RecipeSuggestionTextField(
          value: recipe,
          autofocus: true,
          onRecipeSelected: (recipe) => setState(() => this.recipe = recipe),
          hintText: 'Recipe',
        ),
        SizedBox(height: 20),
        Text(
          'Meal',
          style: theme.textTheme.subtitle1,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: Meal.values
              .map((m) => Row(children: [
                    Radio(
                        value: m,
                        groupValue: meal,
                        onChanged: (checked) => setState(() => meal = m)),
                    Icon(m.icon,
                        color: m == meal
                            ? theme.radioTheme.fillColor!
                                .resolve(Set()..add(MaterialState.selected))
                            : Colors.black),
                  ]))
              .toList(),
        )
      ],
    );
  }
}

class RecipeSuggestionTextField extends StatelessWidget {
  final Recipe? value;
  final String? hintText;
  final bool autofocus;
  final bool showSuggestions;
  final void Function(Recipe)? onRecipeSelected;
  final void Function(dynamic)? onSubmitted;
  final Function()? onTap;
  final bool enabled;

  RecipeSuggestionTextField({
    this.value,
    this.onRecipeSelected,
    this.onSubmitted,
    this.showSuggestions = true,
    this.onTap,
    this.hintText,
    this.autofocus = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController textEditingController = TextEditingController();
    if (value != null) {
      textEditingController.text = value!.name;
    }
    return HookConsumer(builder: (context, ref, _) {
      final recipeRepository = ref.read(recipesRepositoryProvider);

      return TypeAheadField<Recipe>(
        textFieldConfiguration: TextFieldConfiguration(
          controller: textEditingController,
          enabled: enabled,
          decoration: InputDecoration(
            hintText: hintText,
          ),
          maxLines: 1,
          onSubmitted: onSubmitted,
          autofocus: autofocus,
        ),
        itemBuilder: _itemBuilder,
        onSuggestionSelected: _onSuggestionSelected,
        suggestionsCallback: (pattern) =>
            _suggestionsCallback(pattern, recipeRepository),
        hideOnEmpty: true,
        autoFlipDirection: true,
        hideOnLoading: true,
        hideSuggestionsOnKeyboardHide: false,
        minCharsForSuggestions: 1,
      );
    });
  }

  void _onSuggestionSelected(Recipe item) {
    if (onRecipeSelected != null) {
      onRecipeSelected!(item);
    }
  }

  Future<List<Recipe>> _suggestionsCallback(
      String pattern, Repository<Recipe> recipesRepository) async {
    final availableRecipes = await recipesRepository.findAll();
    final List<Recipe> suggestions = [];

    suggestions.addAll(availableRecipes
        .where((ing) => stringContains(ing.name, pattern))
        .toList());

    return suggestions;
  }

  Widget _itemBuilder(BuildContext buildContext, Recipe recipe) {
    return ListTile(
      title: Text(recipe.name),
      trailing: Icon(Icons.check_box),
    );
  }
}
