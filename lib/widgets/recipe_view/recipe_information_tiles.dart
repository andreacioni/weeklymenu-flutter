import 'package:flutter/material.dart';
import 'package:auto_size_text_field/auto_size_text_field.dart';

import 'package:weekly_menu_app/widgets/recipe_view/number_text_field.dart';

import '../../models/enums/difficulty.dart';
import '../../models/recipe.dart';

class RecipeInformationTiles extends StatelessWidget {
  final RecipeOriginator _recipe;
  final bool editEnabled;
  final GlobalKey formKey;

  RecipeInformationTiles(this._recipe, {this.editEnabled, this.formKey});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        EditableInformationTile(
          _recipe.servs?.toDouble(),
          "Servings",
          minValue: 1,
          icon: Icon(
            Icons.people,
            color: Colors.black,
          ),
          editingEnabled: editEnabled,
          suffix: "ppl",
          onChanged: (newValue) => _recipe.updateServs(newValue.truncate()),
        ),
        EditableInformationTile(
          _recipe.estimatedPreparationTime?.toDouble(),
          "Preparation time",
          icon: Icon(
            Icons.timer,
            color: Colors.blueAccent,
          ),
          editingEnabled: editEnabled,
          suffix: "min",
          onChanged: (newValue) =>
              _recipe.updatePreparationTime(newValue.truncate()),
        ),
        EditableInformationTile(
          _recipe.estimatedCookingTime?.toDouble(),
          "Cooking time",
          icon: Icon(
            Icons.timelapse,
            color: Colors.blue,
          ),
          editingEnabled: editEnabled,
          suffix: "min",
          onChanged: (newValue) =>
              _recipe.updateCookingTime(newValue.truncate()),
        ),
        /* ListTile(
          title: Text("Preparation time"),
          leading: Icon(
            Icons.timer,
            color: Colors.blueAccent,
          ),
          trailing: _buildNumberField(_recipe.estimatedPreparationTime, "min",
              onChanged: (newValue) =>
                  _recipe.updatePreparationTime(newValue.truncate())),
        ),
        ListTile(
          title: Text("Cooking time"),
          leading: Icon(
            Icons.timelapse,
            color: Colors.blue,
          ),
          trailing: _buildNumberField(_recipe.estimatedCookingTime, "min",
              onChanged: (newValue) {
            _recipe.updateCookingTime(newValue.truncate());
          }),
        ),*/
        ListTile(
          title: Text("Difficulty"),
          leading: Icon(Icons.work, color: Colors.brown.shade400),
          trailing: _buildDifficultyDropdown(context),
        ),
        RecipeInformationLevelSelect(
          "Affinity",
          Icon(Icons.favorite, color: Colors.red.shade300),
          _recipe.rating,
          editEnabled: editEnabled,
          inactiveColor: Colors.grey.withOpacity(0.3),
          activeColor: Colors.red,
          onLevelUpdate: (newLevel) => _recipe.updateRating(newLevel),
        ),
        RecipeInformationLevelSelect(
          "Cost",
          Icon(Icons.attach_money, color: Colors.green.shade300),
          _recipe.cost,
          editEnabled: editEnabled,
          inactiveColor: Colors.grey.withOpacity(0.5),
          activeColor: Colors.green,
          onLevelUpdate: (newLevel) => _recipe.updateCost(newLevel),
        ),
      ],
    );
  }

  Widget _buildDifficultyDropdown(BuildContext context) {
    return !editEnabled
        ? Text(
            _recipe.difficulty == null ? '-' : _recipe.difficulty,
            style: const TextStyle(fontSize: 18),
          )
        : DropdownButton<String>(
            value: _recipe.difficulty,
            hint: const Text('Choose'),
            iconSize: 24,
            elevation: 16,
            style: const TextStyle(color: Colors.black, fontSize: 18),
            onChanged: (String newValue) => _recipe.updateDifficulty(newValue),
            items: Difficulties.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          );
  }
}

class RecipeInformationLevelSelect extends StatefulWidget {
  static const LEVELS = 3;

  final int _initialLevel;
  final String _label;
  final Icon _icon;
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
  RecipeInformationLevelSelectState createState() =>
      RecipeInformationLevelSelectState(_initialLevel);
}

class RecipeInformationLevelSelectState
    extends State<RecipeInformationLevelSelect> {
  int _level;

  RecipeInformationLevelSelectState(this._level);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget._label),
      leading: widget._icon,
      trailing: SizedBox(
        width: 200,
        child: Row(
          children: List.generate(
            RecipeInformationLevelSelect.LEVELS,
            (index) => !widget.editEnabled
                ? generateIcon(index)
                : IconButton(
                    icon: generateIcon(index),
                    padding: EdgeInsets.all(0),
                    onPressed: () => updateLevel(index + 1),
                    alignment: Alignment.centerRight,
                  ),
          ),
          mainAxisAlignment: MainAxisAlignment.end,
        ),
      ),
    );
  }

  Widget generateIcon(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Icon(
        widget._icon.icon,
        color: (_level != null && index < _level)
            ? widget.activeColor
            : widget.inactiveColor,
      ),
    );
  }

  void updateLevel(int newLevel) {
    setState(() {
      _level = newLevel;
      widget.onLevelUpdate(newLevel);
    });
  }
}

class EditableInformationTile extends StatelessWidget {
  final double value;
  final double minValue;
  final String title;
  final Icon icon;
  final String suffix;
  final bool editingEnabled;
  final void Function(double) onChanged;

  EditableInformationTile(
    this.value,
    this.title, {
    this.icon,
    this.suffix,
    this.editingEnabled,
    this.onChanged,
    this.minValue = 0,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: editingEnabled
          ? NumberFormField(
              initialValue: value?.toDouble(),
              fractionDigits: 0,
              labelText: title,
              minValue: minValue,
              onChanged: onChanged,
            )
          : Text(title),
      leading: icon,
      trailing: !editingEnabled
          ? Text(
              "${value?.truncate() ?? '-'} $suffix",
              style: TextStyle(fontSize: 18),
            )
          : null,
    );
  }
}
