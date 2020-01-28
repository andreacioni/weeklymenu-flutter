import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:flutter_tags/tag.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:spinner_input/spinner_input.dart';

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
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: Text("Servs"),
                        leading: Icon(Icons.people),
                        trailing: _editEnabled
                            ? SpinnerInput(
                                spinnerValue: widget._recipe.servs.toDouble(),
                                disabledPopup: true,
                                onChange: (newValue) {},
                              )
                            : Text(
                                "${widget._recipe.servs} min",
                                style: TextStyle(fontSize: 18),
                              ),
                      ),
                      ListTile(
                        title: Text("Preparation time"),
                        leading: Icon(Icons.timer),
                        trailing: Text(
                          "${widget._recipe.estimatedPreparationTime} min",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      ListTile(
                        title: Text("Cooking time"),
                        leading: Icon(Icons.timelapse),
                        trailing: Text(
                          "${widget._recipe.estimatedCookingTime} min",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      ListTile(
                        title: Text("Affinity"),
                        leading: Icon(Icons.favorite),
                        trailing: SizedBox(
                          width: 200,
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.favorite,
                                color: Colors.red,
                              ),
                              Icon(
                                Icons.favorite,
                                color: Colors.red,
                              ),
                              Icon(
                                Icons.favorite,
                                color: Colors.grey.withOpacity(0.3),
                              ),
                            ],
                            mainAxisAlignment: MainAxisAlignment.end,
                          ),
                        ),
                      ),
                      ListTile(
                        title: Text("Cost"),
                        leading: Icon(Icons.attach_money),
                        trailing: SizedBox(
                          width: 200,
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.attach_money,
                                color: Colors.green,
                              ),
                              Icon(
                                Icons.attach_money,
                                color: Colors.grey.withOpacity(0.5),
                              ),
                              Icon(
                                Icons.attach_money,
                                color: Colors.grey.withOpacity(0.5),
                              ),
                            ],
                            mainAxisAlignment: MainAxisAlignment.end,
                          ),
                        ),
                      ),
                    ],
                  ),
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
                    (ing) => Dismissible(
                      key: UniqueKey(),
                      child: Card(
                        child: ListTile(
                          leading: Padding(
                            padding: EdgeInsets.all(8),
                            child: Image.asset("assets/icons/supermarket.png"),
                          ),
                          title: Text(ing.name),
                          trailing: _editEnabled
                              ? IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {},
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      ing.quantity.toStringAsFixed(0),
                                      style: TextStyle(
                                        fontSize: 27,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      ing.unitOfMeasure,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
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
