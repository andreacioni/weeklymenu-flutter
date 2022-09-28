import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

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

    final autoSizeGroup = useMemoized(() => AutoSizeGroup());

    Widget _buildDifficultyDropdown(BuildContext context) {
      return !editEnabled
          ? Text(
              difficulty ?? '-',
              style: const TextStyle(fontSize: 18),
            )
          : DropdownButton<String>(
              value: difficulty,
              hint: const AutoSizeText('Choose'),
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
        _EditableInformationTile(
          servs?.toDouble(),
          "Servings",
          minValue: 1,
          icon: Icon(
            Icons.people,
            color: Colors.black,
          ),
          editingEnabled: editEnabled,
          suffix: "ppl",
          autoSizeGroup: autoSizeGroup,
          onChanged: (newValue) => notifier
              .updateServings(newValue.truncate()), //_recipe.setEdited(),
        ),
        _EditableInformationTile(
          estimatedPreparationTime?.toDouble(),
          "Preparation time",
          icon: Icon(
            Icons.timer,
            color: Colors.blueAccent,
          ),
          editingEnabled: editEnabled,
          suffix: "min",
          autoSizeGroup: autoSizeGroup,
          minValue: 1,
          onChanged: (newValue) =>
              notifier.updateEstimatedPreparationTime(newValue.truncate()),
        ),
        _EditableInformationTile(
          estimatedCookingTime?.toDouble(),
          "Cooking time",
          icon: Icon(
            Icons.timelapse,
            color: Colors.blue,
          ),
          editingEnabled: editEnabled,
          suffix: "min",
          autoSizeGroup: autoSizeGroup,
          minValue: 1,
          onChanged: (newValue) =>
              notifier.updateEstimatedCookingTime(newValue.truncate()),
        ),
        ListTile(
          title: AutoSizeText(
            "Difficulty",
            group: autoSizeGroup,
          ),
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
          autoSizeGroup: autoSizeGroup,
          onChange: (newLevel) => notifier.updateAffinity(newLevel),
        ),
        _RecipeInformationLevelSelect(
          "Cost",
          Icon(Icons.attach_money, color: Colors.green.shade300),
          cost,
          editEnabled: editEnabled,
          inactiveColor: Colors.grey.withOpacity(0.5),
          activeColor: Colors.green,
          autoSizeGroup: autoSizeGroup,
          onChange: (newLevel) => notifier.updateCost(newLevel),
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
  final Function(int) onChange;
  final AutoSizeGroup? autoSizeGroup;

  _RecipeInformationLevelSelect(this._label, this._icon, this._initialLevel,
      {this.editEnabled = false,
      this.activeColor = Colors.black,
      this.inactiveColor = Colors.grey,
      this.autoSizeGroup,
      required this.onChange});

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
      title: AutoSizeText(
        widget._label,
        group: widget.autoSizeGroup,
        maxLines: 1,
      ),
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
    widget.onChange(newLevel);
  }
}

class _EditableInformationTile extends StatelessWidget {
  final double? value;
  final double minValue;
  final String title;
  final Icon? icon;
  final String suffix;
  final bool editingEnabled;
  final String hintText;
  final void Function(double) onChanged;
  final AutoSizeGroup? autoSizeGroup;

  _EditableInformationTile(this.value, this.title,
      {this.icon,
      required this.suffix,
      this.editingEnabled = false,
      required this.onChanged,
      this.minValue = 0,
      this.autoSizeGroup,
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
              onChanged: (v) => onChanged(v),
              hintText: hintText,
            )
          : AutoSizeText(
              title,
              group: autoSizeGroup,
            ),
      leading: icon,
      trailing: !editingEnabled
          ? AutoSizeText(
              "${value?.truncate() ?? '-'} $suffix",
              style: TextStyle(fontSize: 18),
              group: autoSizeGroup,
            )
          : null,
    );
  }
}
