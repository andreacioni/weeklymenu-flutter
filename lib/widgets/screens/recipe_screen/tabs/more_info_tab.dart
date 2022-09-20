import 'package:flutter/material.dart';

import '../../../../models/recipe.dart';
import '../../../shared/editable_text_field.dart';
import '../../recipe_Screen/recipe_tags.dart';

class RecipeMoreInfoTab extends StatelessWidget {
  final bool editEnabled;
  final RecipeOriginator originator;

  const RecipeMoreInfoTab({
    Key? key,
    required this.originator,
    this.editEnabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final recipe = originator.instance;
    return Column(
      children: [
        SizedBox(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.all(3.0),
          child: Text(
            "Prepation",
            style: TextStyle(
              fontFamily: 'Rubik',
              fontSize: 18,
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        EditableTextField(
          recipe.preparation,
          editEnabled: editEnabled,
          hintText: "Add preparation steps...",
          maxLines: 1000,
          onSaved: (text) => originator
              .update(originator.instance.copyWith(preparation: text)),
        ),
        SizedBox(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.all(3.0),
          child: Text(
            "Notes",
            style: TextStyle(
              fontFamily: 'Rubik',
              fontSize: 18,
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        EditableTextField(
          recipe.note,
          editEnabled: editEnabled,
          hintText: "Add note...",
          maxLines: 1000,
          onSaved: (text) =>
              originator.update(originator.instance.copyWith(note: text)),
        ),
        SizedBox(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.all(3.0),
          child: Text(
            "Tags",
            style: TextStyle(
              fontFamily: 'Rubik',
              fontSize: 18,
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        RecipeTags(
          recipe: originator,
          editEnabled: editEnabled,
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
