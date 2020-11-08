import 'package:flutter/material.dart';
import 'package:flutter_data/flutter_data.dart' hide Provider;
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:weekly_menu_app/models/menu.dart';

import '../../globals/utils.dart';
import '../../models/recipe.dart';
import '../../models/enums/meals.dart';

class RecipeSuggestionTextField extends StatefulWidget {
  final Recipe value;
  final String hintText;
  final bool autofocus;
  final bool showSuggestions;
  final void Function(Recipe) onRecipeSelected;
  final void Function(dynamic) onSubmitted;
  final Function onTap;
  final Function(bool) onFocusChanged;
  final bool enabled;
  final Meal meal;

  RecipeSuggestionTextField(
    this.meal, {
    this.value,
    this.onRecipeSelected,
    this.onSubmitted,
    this.showSuggestions = true,
    this.onTap,
    this.onFocusChanged,
    this.hintText,
    this.autofocus = false,
    this.enabled = true,
  });

  @override
  _RecipeSuggestionTextFieldState createState() =>
      _RecipeSuggestionTextFieldState();
}

class _RecipeSuggestionTextFieldState extends State<RecipeSuggestionTextField> {
  FocusNode focusNode;

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
      textEditingController.text = widget.value.name;
    }
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
      suggestionsCallback: _suggestionsCallback,
      hideOnEmpty: true,
    );
  }

  void _onSuggestionSelected(Recipe item) {
    if (widget.onRecipeSelected != null) {
      widget.onRecipeSelected(item);
    }
  }

  Future<List<Recipe>> _suggestionsCallback(String pattern) async {
    final recipesProvider =
        Provider.of<Repository<Recipe>>(context, listen: false);
    final dailyMenu = Provider.of<DailyMenu>(context, listen: false);
    final availableRecipes = await recipesProvider.findAll();
    final alreadyPresentRecipes = dailyMenu.getMenuByMeal(widget.meal) == null
        ? <Recipe>[]
        : dailyMenu.getMenuByMeal(widget.meal).recipes;
    final List<Recipe> suggestions = [];

    suggestions.addAll(availableRecipes
        .where((ing) => stringContains(ing.name, pattern))
        .toList());

    if (alreadyPresentRecipes != null && alreadyPresentRecipes.isNotEmpty) {
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
