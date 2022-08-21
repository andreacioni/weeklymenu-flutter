import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:weekly_menu_app/globals/hooks.dart';

import '../../globals/memento.dart';
import '../../main.data.dart';
import '../flutter_data_state_builder.dart';
import '../../globals/errors_handlers.dart';
import '../shared/editable_text_field.dart';
import 'add_ingredient_button.dart';
import 'recipe_ingredient_tile/dismissible_recipe_ingredient.dart';
import 'recipe_information_tiles.dart';
import '../../models/recipe.dart';
import 'recipe_app_bar.dart';
import 'recipe_tags.dart';

class RecipeView extends HookConsumerWidget {
  final Recipe originalRecipeInstance;
  final Object heroTag;

  final RecipeOriginator originator;

  RecipeView(this.originalRecipeInstance, {this.heroTag = const Object()})
      : originator = RecipeOriginator(originalRecipeInstance);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editEnabledNotifier = useState(false);
    final recipe = useStateNotifier(originator);
    final editEnabled = editEnabledNotifier.value;

    void _handleEditToggle(bool newValue) async {
      //When switching from 'editEnabled = true' to 'editEnabled = false' means we must update resource on remote (if needed)

      if (!newValue) {
        if (!_formKey.currentState!.validate()) {
          print("Validation failed");
          return;
        }
        //This call save the form's state not the recipe. This operation must be done
        // here to trigger all the onSaved callback of the form fields
        _formKey.currentState!.save();

        if (originator.isEdited) {
          print("Saving all recipe changes");

          ref.recipes.save(originator.save(), params: {'update': true});
        }
      }

      editEnabledNotifier.value = newValue;
    }

    void _handleBackButton(BuildContext context) async {
      if (originator.isEdited) {
        final wannaSave = await showWannaSaveDialog(context);

        if (wannaSave ?? false) {
          _handleEditToggle(false);
        } else {
          print("Losing all the changes");
          originator.revert();
        }
      } else {
        print("No changes made, not save action is necessary");
      }

      Navigator.of(context).pop();
    }

    Form buildForm() {
      return Form(
        key: _formKey,
        child: CustomScrollView(
          slivers: <Widget>[
            RecipeAppBar(
              originator,
              heroTag: heroTag,
              editModeEnabled: editEnabled,
              onRecipeEditEnabled: (editEnabled) =>
                  _handleEditToggle(editEnabled),
              onBackPressed: () => _handleBackButton(context),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                SizedBox(
                  height: 5,
                ),
                EditableTextField(
                  recipe.description,
                  editEnabled: editEnabled,
                  hintText: "Description",
                  onSaved: (newDescription) => originator.update(originator
                      .instance
                      .copyWith(description: newDescription)),
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
                      originator,
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
                if (recipe.ingredients.isEmpty && !editEnabled)
                  EditableTextField(
                    "",
                    editEnabled: false,
                    hintText: "No ingredients",
                  ),
                if (recipe.ingredients.isNotEmpty)
                  ...recipe.ingredients
                      .map(
                        (recipeIng) => DismissibleRecipeIngredientTile(
                            originator, recipeIng, editEnabled),
                      )
                      .toList(),
                if (editEnabled)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AddIngredientButton(originator),
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
                  onSaved: (text) => originator
                      .update(originator.instance.copyWith(note: text)),
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
              ]),
            ),
          ],
        ),
      );
    }

    return Scaffold(
        body: WillPopScope(
      onWillPop: () async {
        _handleBackButton(context);
        return true;
      },
      child: buildForm(),
    ));
  }
}
