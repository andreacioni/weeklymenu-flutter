import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../globals/memento.dart';
import '../../main.data.dart';
import '../flutter_data_state_builder.dart';
import '../../globals/errors_handlers.dart';
import 'add_ingredient_button.dart';
import 'recipe_ingredient_tile/dismissible_recipe_ingredient.dart';
import 'recipe_information_tiles.dart';
import '../../models/recipe.dart';
import 'recipe_app_bar.dart';
import 'recipe_tags.dart';
import 'editable_text_field.dart';

final _recipeOriginatorProvider = StateNotifierProvider.autoDispose
    .family<RecipeOriginator, Recipe, Recipe>(
        (_, recipe) => RecipeOriginator(recipe));

class RecipeView extends HookConsumerWidget {
  final Recipe originalRecipeInstance;
  final Object heroTag;

  RecipeView(this.originalRecipeInstance, {this.heroTag = const Object()});

  final _log = Logger();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editEnabledNotifier = useState(false);
    final editEnabled = editEnabledNotifier.value;

    final recipeOriginator =
        ref.watch(_recipeOriginatorProvider(originalRecipeInstance).notifier);

    void _handleEditToggle(
        WidgetRef ref, RecipeOriginator recipe, bool newValue) async {
      if (!_formKey.currentState!.validate()) {
        _log.w("Validation faield");
        return;
      }

      //This call save the form's state not the recipe. This operation must be done
      // here to trigger all the onSaved callback of the form fields
      _formKey.currentState!.save();

      if (!newValue && recipe.isEdited) {
        //When switching from 'editEnabled = true' to 'editEnabled = false' means we must update resource on remote (if needed)

        _log.i("Saving all recipe changes");

        showProgressDialog(context);

        try {
          await ref.recipes.save(recipe.save());
        } catch (e) {
          showAlertErrorMessage(context);
          return;
        } finally {
          hideProgressDialog(context);
        }
      }
      editEnabledNotifier.value = newValue;
    }

    void _handleBackButton(
        WidgetRef ref, BuildContext context, RecipeOriginator recipe) async {
      if (recipe.isEdited) {
        final wannaSave = await showWannaSaveDialog(context);

        if (wannaSave ?? false) {
          _handleEditToggle(ref, recipe, false);
        } else {
          _log.i("Losing all the changes");
          recipe.revert();
        }
      } else {
        _log.d("No changes made, not save action is necessary");
      }

      Navigator.of(context).pop();
    }

    Form buildForm(WidgetRef ref, RecipeOriginator recipe) {
      return Form(
        key: _formKey,
        child: CustomScrollView(
          slivers: <Widget>[
            RecipeAppBar(
              recipe,
              heroTag: heroTag,
              editModeEnabled: editEnabled,
              onRecipeEditEnabled: (editEnabled) =>
                  _handleEditToggle(ref, recipe, editEnabled),
              onBackPressed: () => _handleBackButton(ref, context, recipe),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                SizedBox(
                  height: 5,
                ),
                EditableTextField(
                  recipe.instance.description,
                  editEnabled: editEnabled,
                  hintText: "Description",
                  onSubmitted: (newDescription) => recipe.update(
                      recipe.instance.copyWith(description: newDescription)),
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(
                    "Information",
                    style: TextStyle(
                      fontFamily: 'Rubik',
                      fontSize: 18,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Card(
                  child: Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: RecipeInformationTiles(
                      recipe,
                      editEnabled: editEnabled,
                      formKey: _formKey,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(
                    "Ingredients",
                    style: TextStyle(
                      fontFamily: 'Rubik',
                      fontSize: 18,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                if (recipe.instance.ingredients.isEmpty && !editEnabled)
                  EditableTextField(
                    "",
                    editEnabled: false,
                    hintText: "No ingredients",
                  ),
                if (recipe.instance.ingredients.isNotEmpty)
                  ...recipe.instance.ingredients
                      .map(
                        (recipeIng) => DismissibleRecipeIngredientTile(
                            recipe, recipeIng, editEnabled),
                      )
                      .toList(),
                if (editEnabled)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AddIngredientButton(recipe),
                  ),
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
                  recipe.instance.preparation,
                  editEnabled: editEnabled,
                  hintText: "Add preparation steps...",
                  maxLines: 1000,
                  onChanged: (text) => recipe
                      .update(recipe.instance.copyWith(preparation: text)),
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
                  recipe.instance.note,
                  editEnabled: editEnabled,
                  hintText: "Add note...",
                  maxLines: 1000,
                  onChanged: (text) =>
                      recipe.update(recipe.instance.copyWith(note: text)),
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
                  recipe: recipe,
                  editEnabled: editEnabled,
                ),
                SizedBox(
                  height: 5,
                ),
              ]),
            ),
          ],
        ),
      );
    }

    return Scaffold(
        body: WillPopScope(
      onWillPop: () async {
        _handleBackButton(ref, context, recipeOriginator);
        return true;
      },
      child: buildForm(ref, recipeOriginator),
    ));
  }
}
