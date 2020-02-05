import 'package:flutter/material.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

import '../../models/recipe.dart';

class RecipeSelectionTextField extends StatefulWidget {
  final Function onSelected;
  final List<Recipe> _suggestions;
  final String hintText;
  final Widget Function(BuildContext) noItemsFountBuilder;
  final bool getImmediateSuggestions;
  final AxisDirection suggestionDirection;

  RecipeSelectionTextField(this._suggestions,
      {@required this.onSelected,
      this.hintText,
      this.noItemsFountBuilder,
      this.getImmediateSuggestions = false,
      this.suggestionDirection = AxisDirection.down});

  @override
  _RecipeSelectionTextFieldState createState() =>
      _RecipeSelectionTextFieldState();
}

class _RecipeSelectionTextFieldState extends State<RecipeSelectionTextField> {
  Recipe selectedValue;

  Widget trailingTextFieldButton = null;

  //String get addNewRecipeSuggestion => "Add ${_typeAheadController.text} ...";

  List<String> getRecipesSuggestion(String pattern) {
    List<String> suggestions = widget._suggestions
        .map((r) => r.toString())
        .where((r) =>
            r.toLowerCase().trim().contains(pattern.trim().toLowerCase()))
        .toList();

    if (pattern.trim() != "") {
      //suggestions.add(addNewRecipeSuggestion);
    }

    return suggestions.reversed.toList();
  }

  void clearTrailingTextFieldButton() {
    setState(() {
      trailingTextFieldButton = null;
    });
  }

  Widget buildAddRecipeIconButton(String suggestion) {
    return IconButton(
      icon: Icon(Icons.add),
      onPressed: () {
        clearTrailingTextFieldButton();
        widget.onSelected(suggestion);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var items = List.from(widget._suggestions.map((v) => DropdownMenuItem<Recipe>(child: Text(v.name), value: v,)).toList().add(DropdownMenuItem<Recipe>(child: Text("Add recipe"), value: Recipe(id: "NONE"),)));
    return SearchableDropdown<Recipe>(
     items: items,
     value: selectedValue,
     hint: new Text(
       widget.hintText
     ),
     searchHint: new Text(
       'Create or select a recipe',
       style: new TextStyle(
           fontSize: 20
       ),
     ),
     onChanged: (value) {
       setState(() {
         selectedValue = value;
       });
     },
     isCaseSensitiveSearch: false,
   );
  }
}
