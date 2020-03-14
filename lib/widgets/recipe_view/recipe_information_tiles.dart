import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spinner_input/spinner_input.dart';

import '../../models/ingredient.dart';
import '../../providers/recipes_provider.dart';
import '../../models/recipe.dart';

class RecipeInformationTiles extends StatelessWidget {
  final Recipe _recipe;
  final bool editEnabled;

  RecipeInformationTiles(this._recipe, {this.editEnabled});

  Widget _buildSpinner(double val, String suffix,
      {Function(double) onChange, double minValue = 0.0, double step = 1.0}) {
    return editEnabled
        ? SpinnerInput(
            spinnerValue: val,
            fractionDigits: 0,
            disabledPopup: true,
            minValue: minValue,
            step: step,
            onChange: onChange,
          )
        : Text(
            "${val.toInt()} $suffix",
            style: TextStyle(fontSize: 18),
          );
  }

  Widget _buildDifficultyDropdown(BuildContext context, Recipe recipe) {
    return !editEnabled
        ? Text(
            recipe.difficulty == null ? '-' : recipe.difficulty,
            style: const TextStyle(fontSize: 18),
          )
        : DropdownButton<String>(
            value: recipe.difficulty,
            hint: const Text('Choose'),
            iconSize: 24,
            elevation: 16,
            style: const TextStyle(color: Colors.black, fontSize: 18),
            onChanged: (String newValue) {
              Provider.of<RecipesProvider>(context, listen: false)
                  .updateDifficulty(recipe.id, newValue);
            },
            items: <String>['Easy', 'Intermediate', 'Hard']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text("Servs"),
          leading: Icon(Icons.people),
          trailing: _buildSpinner(
            _recipe.servs.toDouble(),
            "ppl",
            minValue: 1,
            onChange: (newValue) {
              Provider.of<RecipesProvider>(context, listen: false).updateServs(_recipe.id, newValue.truncate());
            }
          ),
        ),
        ListTile(
          title: Text("Preparation time"),
          leading: Icon(Icons.timer),
          trailing: _buildSpinner(
            _recipe.estimatedPreparationTime.toDouble(),
            "min",
            onChange: (newValue) {
              Provider.of<RecipesProvider>(context, listen: false).updatePreparationTime(_recipe.id, newValue.truncate());
            }
          ),
        ),
        ListTile(
          title: Text("Cooking time"),
          leading: Icon(Icons.timelapse),
          trailing: _buildSpinner(
            _recipe.estimatedCookingTime.toDouble(),
            "min",
            onChange: (newValue) {
              Provider.of<RecipesProvider>(context, listen: false).updateCookingTime(_recipe.id, newValue.truncate());
            }
          ),
        ),
        ListTile(
          title: Text("Difficulty"),
          leading: Icon(Icons.work),
          trailing: _buildDifficultyDropdown(context, _recipe),
        ),
        RecipeInformationLevelSelect(
          "Affinity",
          Icons.favorite,
          _recipe.rating,
          editEnabled: editEnabled,
          inactiveColor: Colors.grey.withOpacity(0.3),
          activeColor: Colors.red,
          onLevelUpdate: (newLevel) {
            _recipe.rating = newLevel;
          },
        ),
        RecipeInformationLevelSelect(
          "Cost",
          Icons.attach_money,
          _recipe.cost,
          editEnabled: editEnabled,
          inactiveColor: Colors.grey.withOpacity(0.5),
          activeColor: Colors.green,
          onLevelUpdate: (newLevel) {
            _recipe.cost = newLevel;
          },
        ),
      ],
    );
  }
}

class RecipeInformationLevelSelect extends StatefulWidget {
  static const LEVELS = 3;

  final int _initialLevel;
  final String _label;
  final IconData _icon;
  final bool editEnabled;
  final Color activeColor;
  final Color inactiveColor;
  final Function(int) onLevelUpdate;

  RecipeInformationLevelSelect(this._label, this._icon, this._initialLevel,
      {this.editEnabled = false,
      this.activeColor = Colors.black,
      this.inactiveColor = Colors.grey,
      @required this.onLevelUpdate});

  @override
  _RecipeInformationLevelSelectState createState() =>
      _RecipeInformationLevelSelectState(_initialLevel);
}

class _RecipeInformationLevelSelectState
    extends State<RecipeInformationLevelSelect> {
  int _level;

  _RecipeInformationLevelSelectState(this._level);

  Widget generateIcon(int index) => Icon(
        widget._icon,
        color: index < _level ? widget.activeColor : widget.inactiveColor,
      );

  void updateLevel(int newLevel) {
    setState(() {
      _level = newLevel;
      widget.onLevelUpdate(newLevel);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget._label),
      leading: Icon(widget._icon),
      trailing: SizedBox(
        width: 200,
        child: Row(
          children: List.generate(
            RecipeInformationLevelSelect.LEVELS,
            (index) => !widget.editEnabled
                ? generateIcon(index)
                : IconButton(
                    icon: generateIcon(index),
                    onPressed: () => updateLevel(index + 1),
                    alignment: Alignment.centerRight,
                  ),
          ),
          mainAxisAlignment: MainAxisAlignment.end,
        ),
      ),
    );
  }
}
