import 'package:flutter/material.dart';
import 'package:flutter_data/flutter_data.dart' hide Provider;
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:objectid/objectid.dart';

import '../../../models/ingredient.dart';

class IngredientSelectionTextField extends StatefulWidget {
  final Function(Ingredient) onIngredientSelected;
  //final Function(String) onSubmitted;
  final Ingredient? value;
  final bool enabled;
  final bool autofocus;

  IngredientSelectionTextField(
      {required this.onIngredientSelected,
      //this.onSubmitted,
      this.value,
      this.enabled = true,
      this.autofocus = false});

  @override
  _IngredientSelectionTextFieldState createState() =>
      _IngredientSelectionTextFieldState();
}

class _IngredientSelectionTextFieldState
    extends State<IngredientSelectionTextField> {
  static const TEMP_ID = 'f4k3id';
  final TextEditingController _typeAheadController =
      new TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (widget.value != null) {
      _typeAheadController.text = widget.value!.name;
    }

    return Consumer(builder: (context, ref, _) {
      return TypeAheadField<Ingredient>(
        direction: AxisDirection.down,
        textFieldConfiguration: TextFieldConfiguration(
            autofocus: widget.autofocus,
            enabled: widget.enabled,
            controller: _typeAheadController,
            decoration: InputDecoration(
              labelText: "Ingredient",
              enabled: widget.enabled,
            ),
            onSubmitted: (text) {}),
        suggestionsCallback: (pattern) async {
          return getIngredientsSuggestion(ref, pattern);
        },
        itemBuilder: (context, ingredient) {
          return ListTile(
            trailing:
                Icon(ingredient.id == TEMP_ID ? Icons.add : Icons.call_made),
            title: Text(ingredient.name),
          );
        },
        noItemsFoundBuilder: (_) {
          return ListTile(
            title: Text("Type a new ingredient name"),
          );
        },
        onSuggestionSelected: (selectedIngredient) {
          if (selectedIngredient.id == TEMP_ID) {
            selectedIngredient = selectedIngredient.copyWith(
                id: ObjectId().hexString,
                name: RegExp(r'^Add "(.*)" \.\.\.')
                    .firstMatch(selectedIngredient.name)!
                    .group(1)!);
            selectedIngredient.save();
            print('ingredient: ${selectedIngredient.name} created');
          } else {
            this._typeAheadController.text = selectedIngredient.name;
          }

          widget.onIngredientSelected(selectedIngredient);
        },
      );
    });
  }

  Future<List<Ingredient>> getIngredientsSuggestion(
      WidgetRef ref, String pattern) async {
    final availableIngredients =
        await ref.read(ingredientsRepositoryProvider).findAll(remote: false);

    var suggestions = availableIngredients
        .where((r) =>
            r.name.toLowerCase().trim().contains(pattern.trim().toLowerCase()))
        .toList();

    if (pattern.trim() != "" &&
        availableIngredients.indexWhere((r) =>
                r.name.trim().toLowerCase() == pattern.trim().toLowerCase()) ==
            -1) {
      suggestions.add(Ingredient(
          id: TEMP_ID, name: 'Add "${_typeAheadController.text}" ...'));
    }

    return suggestions;
  }

  Widget buildAddIngredientIconButton(Ingredient selectedIngredient) {
    return IconButton(
      icon: Icon(Icons.add),
      onPressed: () {
        _typeAheadController.clear();
        widget.onIngredientSelected(selectedIngredient);
      },
    );
  }
}
