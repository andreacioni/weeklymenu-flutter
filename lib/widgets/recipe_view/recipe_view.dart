import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:flutter_tags/tag.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:weekly_menu_app/widgets/recipe_view/recipe_information_tiles.dart';

import '../../widgets/recipe_view/recipe_ingredient_list_tile.dart';
import '../../models/recipe.dart';
import './expandable_widget.dart';
import './recipe_app_bar.dart';
import './editable_text_field.dart';
import '../../globals/utils.dart';

class RecipeView extends StatefulWidget {
  final Recipe _recipe;

  RecipeView(this._recipe);

  @override
  _RecipeViewState createState() => _RecipeViewState();
}

class _RecipeViewState extends State<RecipeView> {
  bool _editEnabled = false;
  double spinner = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          RecipeAppBar(
            widget._recipe,
            editModeEnabled: _editEnabled,
            onRecipeEditEnabled: (editEnabled) => setState(() {
              _editEnabled = editEnabled;
            }),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(
                height: 5,
              ),
              EditableTextField(
                widget._recipe.description,
                editEnabled: _editEnabled,
                hintText: "Description",
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "Information",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Card(
                child: Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: RecipeInformationTiles(widget._recipe, editEnabled: _editEnabled),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "Ingredients",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              ...widget._recipe.ingredients
                  .map(
                    (recipeIng) => _editEnabled
                        ? Dismissible(
                            key: UniqueKey(),
                            child: RecipeIngredientListTile(
                              recipeIng,
                              editEnabled: _editEnabled,
                            ))
                        : RecipeIngredientListTile(
                            recipeIng,
                          ),
                  )
                  .toList(),
              if (_editEnabled)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {},
                    child: DottedBorder(
                      child: Center(
                          child: const Text(
                        "+ ADD RECIPE",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      )),
                      strokeWidth: 5,
                      dashPattern: [4, 10],
                      color: Colors.grey,
                      padding: EdgeInsets.all(10),
                      borderType: BorderType.RRect,
                      radius: Radius.circular(9),
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                ),
              SizedBox(
                height: 5,
              ),
              Text(
                "Prepation",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              EditableTextField(
                "",
                editEnabled: _editEnabled,
                hintText: "Add preparation steps...",
                maxLines: 1000,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "Notes",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              EditableTextField(
                "",
                editEnabled: _editEnabled,
                hintText: "Add note...",
                maxLines: 1000,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "Tags",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Tags(
                itemBuilder: (index) => ItemTags(
                  image: ItemTagsImage(
                    child: Icon(
                      Icons.local_offer,
                      color: Colors.white,
                    ),
                  ),
                  title: widget._recipe.tags[index],
                  activeColor: getColorForString(widget._recipe.tags[index]),
                  combine: ItemTagsCombine.withTextAfter,
                  index: index,
                  pressEnabled: false,
                  textScaleFactor: 1.5,
                ),
                itemCount: widget._recipe.tags.length,
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
}
