import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:weekly_menu_app/widgets/shared/empty_page_placeholder.dart';

import '../../../../models/recipe.dart';
import '../../../../providers/screen_notifier.dart';
import '../../../shared/editable_text_field.dart';
import '../../recipe_Screen/recipe_tags.dart';

class RecipeStepsTab extends HookConsumerWidget {
  const RecipeStepsTab({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preparationSteps = ref.watch(recipeScreenNotifierProvider
        .select((n) => n.recipeOriginator!.instance.preparationSteps));
    return Column(
      children: [
        if (preparationSteps.isEmpty)
          EmptyPagePlaceholder(
            icon: Icons.add_circle_outline_sharp,
            text: 'No steps defined',
            sizeRate: 0.8,
            margin: EdgeInsets.only(top: 100),
          ),
        /* SizedBox(
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
        ), */
      ],
    );
  }
}
