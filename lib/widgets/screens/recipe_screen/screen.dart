import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../globals/constants.dart';
import '../../../globals/hooks.dart';
import '../../../main.data.dart';
import '../../../globals/errors_handlers.dart';
import '../../shared/editable_text_field.dart';
import 'add_ingredient_button.dart';
import 'recipe_ingredient_tile/dismissible_recipe_ingredient.dart';
import 'recipe_information_tiles.dart';
import '../../../models/recipe.dart';
import 'recipe_app_bar.dart';
import 'recipe_tags.dart';

const RECIPE_TABS = [
  Tab(
      //child: Text('Info'),
      icon: Icon(
    Icons.info_outline,
  )),
  Tab(
    //text: 'Ingredients',
    icon: Icon(Icons.list),
  ),
  Tab(
    //text: 'More',
    icon: Icon(Icons.more_horiz_rounded),
  ),
];

class RecipeScreen extends HookConsumerWidget {
  final Recipe originalRecipeInstance;
  final Object heroTag;

  final RecipeOriginator originator;

  RecipeScreen(this.originalRecipeInstance, {this.heroTag = const Object()})
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

          ref.recipes.save(originator.save(), params: {UPDATE_PARAM: true});
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
            SliverAppBar(
              pinned: true,
              automaticallyImplyLeading: false,
              stretch: false,
              //floating: true,
              expandedHeight: originator.instance.imgUrl != null ? 200.0 : null,
              flexibleSpace: FlexibleSpaceBar(
                //centerTitle: false,
                collapseMode: CollapseMode.pin,
                title: originator.instance.imgUrl != null
                    ? Hero(
                        tag: heroTag,
                        child: Image(
                          image: CachedNetworkImageProvider(
                              originator.instance.imgUrl!),
                          fit: BoxFit.fitWidth,
                        ),
                      )
                    : null,
              ),
              bottom: TabBar(
                labelColor: Colors.red,
                unselectedLabelColor: Colors.redAccent,
                tabs: RECIPE_TABS,
              ),
            ),
            /* SliverPersistentHeader(
              delegate: _SliverAppBarDelegate(
                TabBar(
                  tabs: RECIPE_TABS,
                ),
              ),
              pinned: true,
            ), */
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
      child:
          DefaultTabController(length: RECIPE_TABS.length, child: buildForm()),
    ));
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final primaryColor = Theme.of(context).primaryColor;
    return Material(
      elevation: 3,
      child: Container(
        color: primaryColor,
        child: _tabBar,
      ),
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
