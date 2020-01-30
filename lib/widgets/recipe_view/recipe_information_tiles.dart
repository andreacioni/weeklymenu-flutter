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
  _RecipeInformationLevelSelectState createState() => _RecipeInformationLevelSelectState(_initialLevel);
}

class _RecipeInformationLevelSelectState extends State<RecipeInformationLevelSelect> {
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
                    onPressed: () => updateLevel(index+1),
                    alignment: Alignment.centerRight,
                  ),
          ),
          mainAxisAlignment: MainAxisAlignment.end,
        ),
      ),
    );
  }
}
