import 'package:flutter/material.dart';

import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:weekly_menu_app/models/recipe.dart';
import 'package:weekly_menu_app/syncronizer/syncro.dart';

class RecipeSelectionTextField extends StatefulWidget {
  final Function onRecipeSelected;
  final List<RecipeOriginator> _availableRecipes;

  RecipeSelectionTextField(this._availableRecipes, {this.onRecipeSelected});

  @override
  _RecipeSelectionTextFieldState createState() =>
      _RecipeSelectionTextFieldState();
}

class _RecipeSelectionTextFieldState extends State<RecipeSelectionTextField> {
  final TextEditingController _typeAheadController =
      new TextEditingController();

  Widget trailingTextFieldButton;

  List<RecipeOriginator> getRecipesSuggestion(String pattern) {
    var suggestions = widget._availableRecipes
        .where((r) =>
            r.name.toLowerCase().trim().contains(pattern.trim().toLowerCase()))
        .toList();

    //Remove recipes already selected
    //suggestions.removeWhere((r) => widget._alreadySelectedRecipes.contains(r));

    if (pattern.trim() != "" &&
        widget._availableRecipes.indexWhere((r) =>
                r.name.trim().toLowerCase() == pattern.trim().toLowerCase()) ==
            -1) {
      suggestions.add(RecipeOriginator(Recipe(Id.newInstance(),
          name: "Add ${_typeAheadController.text} ...")));
    }

    return suggestions.reversed.toList();
  }

  void clearTrailingTextFieldButton() {
    setState(() {
      trailingTextFieldButton = null;
    });
  }

  Widget buildAddRecipeIconButton(RecipeOriginator selectedRecipe) {
    return IconButton(
      icon: Icon(Icons.add),
      onPressed: () {
        _typeAheadController.clear();
        clearTrailingTextFieldButton();
        widget.onRecipeSelected(selectedRecipe);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: TypeAheadField<RecipeOriginator>(
            direction: AxisDirection.up,
            getImmediateSuggestions: true,
            textFieldConfiguration: TextFieldConfiguration(
              controller: _typeAheadController,
              decoration: InputDecoration(
                hintText: "Recipe",
                suffixIcon: trailingTextFieldButton,
              ),
              onChanged: (_) => clearTrailingTextFieldButton(),
            ),
            suggestionsCallback: (pattern) async {
              return getRecipesSuggestion(pattern);
            },
            itemBuilder: (context, recipe) {
              return ListTile(
                trailing: Icon(recipe.id != 'NONE'
                    ? Icons.call_made
                    : Icons.control_point),
                title: Text(recipe.name),
              );
            },
            noItemsFoundBuilder: (_) {
              return ListTile(
                title: Text("Type a new recipe name"),
              );
            },
            onSuggestionSelected: (selectedRecipe) {
              if (selectedRecipe.id == 'NONE') {
                print('Add Recipe: ${selectedRecipe.name}');
                selectedRecipe.updateName(RegExp(r"^Add (.*) \.\.\.")
                    .firstMatch(selectedRecipe.name)
                    .group(1));
                _typeAheadController.clear();
                widget.onRecipeSelected(selectedRecipe);
              } else {
                this._typeAheadController.text = selectedRecipe.name;
                setState(() {
                  trailingTextFieldButton =
                      buildAddRecipeIconButton(selectedRecipe);
                });
              }
            },
          ),
        ),
      ],
    );
  }
}
