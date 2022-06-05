import 'package:flutter/material.dart';
import 'package:flutter_data/flutter_data.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

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
  String? recipeTitle;
  Recipe? recipe;
  Meal? meal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    dynamic initialValue = recipe ?? recipeTitle;

    final recipeSelected =
        ((recipeTitle != null && recipeTitle!.isNotEmpty) || recipe != null);

    final mealSelected = meal != null;

    return BaseDialog(
      title: widget.title,
      subtitle: 'Add recipe to meal',
      doneButtonText: 'ADD',
      onDoneTap: recipeSelected && mealSelected
          ? () => Navigator.pop(context,
              {'recipe': recipe, 'recipeTitle': recipeTitle, 'meal': meal})
          : null,
      children: [
        _RecipeSuggestionTextField(
          value: initialValue,
          autofocus: true,
          onRecipeSelected: (recipe) => setState(() {
            this.recipe = recipe;
            this.recipeTitle = null;
          }),
          onTextChanged: (recipeTitle) => setState(() {
            this.recipeTitle = recipeTitle;
            this.recipe = null;
          }),
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

class _RecipeSuggestionTextField extends HookConsumerWidget {
  final dynamic value;
  final String? hintText;
  final bool autofocus;
  final bool showSuggestions;
  final void Function(Recipe)? onRecipeSelected;
  final void Function(String)? onTextChanged;
  final Function()? onTap;
  final bool enabled;

  _RecipeSuggestionTextField({
    this.value,
    this.onRecipeSelected,
    this.onTextChanged,
    this.showSuggestions = true,
    this.onTap,
    this.hintText,
    this.autofocus = false,
    this.enabled = true,
  }) : assert(value == null || value is String || value is Recipe);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textEditingController = useTextEditingController();
    if (value != null) {
      if (value is Recipe)
        textEditingController.text = value!.name;
      else if (value is String) textEditingController.text = value;

      textEditingController.selection =
          TextSelection.collapsed(offset: textEditingController.text.length);
    }
    final recipeRepository = ref.read(recipesRepositoryProvider);
    return TypeAheadField<Recipe>(
      textFieldConfiguration: TextFieldConfiguration(
        controller: textEditingController,
        enabled: enabled,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(6.0),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          labelText: hintText,
        ),
        maxLines: 1,
        onChanged: onTextChanged,
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
  }

  void _onSuggestionSelected(Recipe item) {
    if (onRecipeSelected != null) {
      onRecipeSelected!(item);
    }
  }

  Future<List<Recipe>> _suggestionsCallback(
      String pattern, Repository<Recipe> recipesRepository) async {
    final availableRecipes = await recipesRepository.findAll(remote: false);
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
