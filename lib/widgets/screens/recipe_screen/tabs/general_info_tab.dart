import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../models/enums/difficulty.dart';
import '../../../../models/recipe.dart';
import '../../../../providers/screen_notifier.dart';
import '../../../shared/editable_text_field.dart';
import '../../../shared/number_text_field.dart';

class RecipeGeneralInfoTab extends StatelessWidget {
  const RecipeGeneralInfoTab({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          child: Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: _RecipeInformationTiles(),
          ),
        ),
      ],
    );
  }
}

class _RecipeInformationTiles extends HookConsumerWidget {
  _RecipeInformationTiles();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(recipeScreenNotifierProvider.notifier);

    final editEnabled =
        ref.watch(recipeScreenNotifierProvider.select((n) => n.editEnabled));

    final servs = ref.watch(recipeScreenNotifierProvider
        .select((n) => n.recipeOriginator.instance.servs));
    final estimatedPreparationTime = ref.watch(recipeScreenNotifierProvider
        .select((n) => n.recipeOriginator.instance.estimatedPreparationTime));
    final estimatedCookingTime = ref.watch(recipeScreenNotifierProvider
        .select((n) => n.recipeOriginator.instance.estimatedCookingTime));
    final rating = ref.watch(recipeScreenNotifierProvider
        .select((n) => n.recipeOriginator.instance.rating));
    final cost = ref.watch(recipeScreenNotifierProvider
        .select((n) => n.recipeOriginator.instance.cost));
    final difficulty = ref.watch(recipeScreenNotifierProvider
        .select((n) => n.recipeOriginator.instance.difficulty));

    Widget _buildDifficultyDropdown(BuildContext context) {
      return !editEnabled
          ? Text(
              difficulty ?? '-',
              style: const TextStyle(fontSize: 18),
            )
          : DropdownButton<String>(
              value: difficulty,
              hint: const Text('Choose'),
              iconSize: 24,
              elevation: 16,
              style: const TextStyle(color: Colors.black, fontSize: 18),
              onChanged: (String? newValue) =>
                  notifier.updateDifficulty(newValue),
              items: Difficulties.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            );
    }

    return Column(
      children: <Widget>[
        EditableInformationTile(
          servs?.toDouble(),
          "Servings",
          minValue: 1,
          icon: Icon(
            Icons.people,
            color: Colors.black,
          ),
          editingEnabled: editEnabled,
          suffix: "ppl",
          onChanged: () => {}, //_recipe.setEdited(),
          onSaved: (newValue) => notifier.updateServings(newValue.truncate()),
        ),
        EditableInformationTile(
          estimatedPreparationTime?.toDouble(),
          "Preparation time",
          icon: Icon(
            Icons.timer,
            color: Colors.blueAccent,
          ),
          editingEnabled: editEnabled,
          suffix: "min",
          minValue: 1,
          onChanged: () => {}, //_recipe.setEdited(),
          onSaved: (newValue) =>
              notifier.updateEstimatedPreparationTime(newValue.truncate()),
        ),
        EditableInformationTile(
          estimatedCookingTime?.toDouble(),
          "Cooking time",
          icon: Icon(
            Icons.timelapse,
            color: Colors.blue,
          ),
          editingEnabled: editEnabled,
          suffix: "min",
          minValue: 1,
          onChanged: () => {}, //_recipe.setEdited(),
          onSaved: (newValue) =>
              notifier.updateEstimatedCookingTime(newValue.truncate()),
        ),
        ListTile(
          title: Text("Difficulty"),
          leading: Icon(Icons.work, color: Colors.brown.shade400),
          trailing: _buildDifficultyDropdown(context),
        ),
        _RecipeInformationLevelSelect(
          "Affinity",
          Icon(Icons.favorite, color: Colors.red.shade300),
          rating,
          editEnabled: editEnabled,
          inactiveColor: Colors.grey.withOpacity(0.3),
          activeColor: Colors.red,
          onLevelUpdate: (newLevel) => notifier.updateAffinity(rating),
        ),
        _RecipeInformationLevelSelect(
          "Cost",
          Icon(Icons.attach_money, color: Colors.green.shade300),
          cost,
          editEnabled: editEnabled,
          inactiveColor: Colors.grey.withOpacity(0.5),
          activeColor: Colors.green,
          onLevelUpdate: (newLevel) => notifier.updateCost(newLevel),
        ),
      ],
    );
  }
}

class _RecipeInformationLevelSelect extends StatefulWidget {
  static const LEVELS = 3;

  final int? _initialLevel;
  final String _label;
  final Icon _icon;
  final bool editEnabled;
  final Color activeColor;
  final Color inactiveColor;
  final Function(int) onLevelUpdate;

  _RecipeInformationLevelSelect(this._label, this._icon, this._initialLevel,
      {this.editEnabled = false,
      this.activeColor = Colors.black,
      this.inactiveColor = Colors.grey,
      required this.onLevelUpdate});

  @override
  _RecipeInformationLevelSelectState createState() =>
      _RecipeInformationLevelSelectState(_initialLevel);
}

class _RecipeInformationLevelSelectState
    extends State<_RecipeInformationLevelSelect> {
  int? _level;

  _RecipeInformationLevelSelectState(this._level);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget._label),
      leading: widget._icon,
      trailing: SizedBox(
        width: 200,
        child: Row(
          children: List.generate(
            _RecipeInformationLevelSelect.LEVELS,
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
        color: (_level != null && index < _level!)
            ? widget.activeColor
            : widget.inactiveColor,
      ),
    );
  }

  void updateLevel(int newLevel) {
    setState(() {
      _level = newLevel;
    });
    widget.onLevelUpdate(newLevel);
  }
}

class EditableInformationTile extends StatelessWidget {
  final double? value;
  final double minValue;
  final String title;
  final Icon? icon;
  final String suffix;
  final bool editingEnabled;
  final String hintText;
  final void Function(double) onSaved;
  final void Function() onChanged;

  EditableInformationTile(this.value, this.title,
      {this.icon,
      required this.suffix,
      this.editingEnabled = false,
      required this.onSaved,
      required this.onChanged,
      this.minValue = 0,
      String? hintText})
      : this.hintText = hintText ?? title;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: editingEnabled
          ? NumberFormField(
              initialValue: value,
              fractionDigits: 0,
              labelText: title,
              minValue: minValue,
              onChanged: (_) => onChanged(),
              onSaved: onSaved,
              hintText: hintText,
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
