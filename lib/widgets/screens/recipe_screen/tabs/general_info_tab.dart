import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:weekly_menu_app/widgets/shared/base_dialog.dart';

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
        Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: _RecipeInformationTiles(),
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

    return Column(
      children: <Widget>[
        SizedBox(height: 20),
        _RecipeTitle(),
        SizedBox(height: 20),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          height: 2,
          width: double.maxFinite,
          decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.1),
              borderRadius: BorderRadius.all(Radius.circular(20))),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Icon(Icons.schedule, size: 25, color: Colors.amber.shade400),
                SizedBox(height: 9),
                Text('50 min', style: Theme.of(context).textTheme.labelMedium)
              ],
            ),
            Column(
              children: [
                Icon(Icons.people_outline,
                    size: 25, color: Colors.amber.shade400),
                SizedBox(height: 9),
                Text('2 servs.', style: Theme.of(context).textTheme.labelMedium)
              ],
            ),
            Column(
              children: [
                Icon(
                  Icons.favorite_border_outlined,
                  size: 25,
                  color: Colors.amber.shade400,
                ),
                SizedBox(height: 9),
                Text('70 %', style: Theme.of(context).textTheme.labelMedium)
              ],
            )
          ],
        ),
        SizedBox(height: 20),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          height: 2,
          width: double.maxFinite,
          decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.1),
              borderRadius: BorderRadius.all(Radius.circular(20))),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}

class _RecipeTitle extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(recipeScreenNotifierProvider.notifier);

    final editEnabled =
        ref.watch(recipeScreenNotifierProvider.select((n) => n.editEnabled));
    final recipeName = ref.watch(recipeScreenNotifierProvider
        .select((n) => n.recipeOriginator.instance.name));

    void openEditRecipeNameModal() async {
      final textController = TextEditingController(text: recipeName);
      String? newRecipeName = await showDialog<String>(
        context: context,
        builder: (_) => BaseDialog<String?>(
          title: 'Name',
          children: [
            TextField(controller: textController),
          ],
          onDoneTap: () {
            var text = textController.text.trim();
            if (text.isNotEmpty) {
              Navigator.of(context).pop(text);
            }
          },
        ),
      );

      if (newRecipeName != null) {
        notifier.updateRecipeName(newRecipeName);
      }
    }

    return Row(
      children: [
        Flexible(
          child: AutoSizeText(
            recipeName,
            maxLines: 2,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        if (editEnabled) ...[
          SizedBox(width: 10),
          IconButton(
            onPressed: openEditRecipeNameModal,
            icon: Icon(Icons.edit),
            splashRadius: 15,
          ),
        ]
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
