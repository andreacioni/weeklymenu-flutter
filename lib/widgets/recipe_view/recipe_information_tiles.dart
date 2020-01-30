import 'package:flutter/material.dart';
import 'package:spinner_input/spinner_input.dart';

import '../../models/recipe.dart';

class RecipeInformationTiles extends StatelessWidget {
  final Recipe _recipe;
  final bool editEnabled;

  RecipeInformationTiles(this._recipe, {this.editEnabled});

  Widget _buildSpinner(double val, String suffix,
      {double minValue = 0.0, double step = 1.0}) {
    return editEnabled
        ? SpinnerInput(
            spinnerValue: val,
            fractionDigits: 0,
            disabledPopup: true,
            minValue: minValue,
            step: step,
            onChange: (newValue) {},
          )
        : Text(
            "${val.toInt()} $suffix",
            style: TextStyle(fontSize: 18),
          );
  }

  Widget _buildDifficultyDropdown() {
    return !editEnabled
        ? Text(
            "Easy",
            style: TextStyle(fontSize: 18),
          )
        : DropdownButton<String>(
            value: "Easy",
            //icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.black, fontSize: 18),
            onChanged: (String newValue) {
              //setState(() {
              //dropdownValue = newValue;
              //});
            },
            items: <String>['Easy', 'Two', 'Free', 'Four']
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
          ),
        ),
        ListTile(
          title: Text("Preparation time"),
          leading: Icon(Icons.timer),
          trailing: _buildSpinner(
            _recipe.estimatedPreparationTime.toDouble(),
            "min",
          ),
        ),
        ListTile(
          title: Text("Cooking time"),
          leading: Icon(Icons.timelapse),
          trailing: _buildSpinner(
            _recipe.estimatedCookingTime.toDouble(),
            "min",
          ),
        ),
        ListTile(
          title: Text("Difficulty"),
          leading: Icon(Icons.work),
          trailing: _buildDifficultyDropdown(),
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
