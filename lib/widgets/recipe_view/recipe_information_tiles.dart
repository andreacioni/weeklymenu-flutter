import 'package:flutter/material.dart';
import 'package:spinner_input/spinner_input.dart';

import '../../models/recipe.dart';

class RecipeInformationTiles extends StatelessWidget {
  final Recipe _recipe;
  final bool editEnabled;

  RecipeInformationTiles(this._recipe, {this.editEnabled});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text("Servs"),
          leading: Icon(Icons.people),
          trailing: editEnabled
              ? SpinnerInput(
                  spinnerValue: _recipe.servs.toDouble(),
                  disabledPopup: true,
                  onChange: (newValue) {},
                )
              : Text(
                  "${_recipe.servs} min",
                  style: TextStyle(fontSize: 18),
                ),
        ),
        ListTile(
          title: Text("Preparation time"),
          leading: Icon(Icons.timer),
          trailing: Text(
            "${_recipe.estimatedPreparationTime} min",
            style: TextStyle(fontSize: 18),
          ),
        ),
        ListTile(
          title: Text("Cooking time"),
          leading: Icon(Icons.timelapse),
          trailing: Text(
            "${_recipe.estimatedCookingTime} min",
            style: TextStyle(fontSize: 18),
          ),
        ),
        ListTile(
          title: Text("Difficulty"),
          leading: Icon(Icons.work),
          trailing: Text(
            "Easy",
            style: TextStyle(fontSize: 18),
          ),
        ),
        RecipeInformationThreeLevelSelect(
          "Affinity",
          Icons.favorite,
          _recipe.rating,
          editEnabled: editEnabled,
          inactiveColor: Colors.grey.withOpacity(0.3),
          activeColor: Colors.red,
        ),
        RecipeInformationThreeLevelSelect(
          "Cost",
          Icons.attach_money,
          _recipe.cost,
          editEnabled: editEnabled,
          inactiveColor: Colors.grey.withOpacity(0.5),
          activeColor: Colors.green,
        ),
      ],
    );
  }
}

class RecipeInformationThreeLevelSelect extends StatelessWidget {
  static const LEVELS = 3;

  final String _label;
  final IconData _icon;
  final int _level;
  final bool editEnabled;
  final Color activeColor;
  final Color inactiveColor;

  RecipeInformationThreeLevelSelect(this._label, this._icon, this._level,
      {this.editEnabled = false,
      this.activeColor = Colors.black,
      this.inactiveColor = Colors.grey});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(_label),
      leading: Icon(_icon),
      trailing: SizedBox(
        width: 200,
        child: Row(
          children: List.generate(
            LEVELS,
            (index) => Icon(
              _icon,
              color: index < _level ? activeColor : inactiveColor,
            ),
          ),
          mainAxisAlignment: MainAxisAlignment.end,
        ),
      ),
    );
  }
}
