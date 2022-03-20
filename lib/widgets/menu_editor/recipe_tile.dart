import 'package:flutter/material.dart';

import '../../models/recipe.dart';

class RecipeTile extends StatelessWidget {
  final Recipe _recipe;
  final bool editEnable;
  final bool isChecked;
  final void Function()? onPressed;
  final void Function(bool?)? onCheckChange;
  final Key? key;

  RecipeTile(
    this._recipe, {
    this.editEnable = false,
    this.isChecked = false,
    this.onPressed,
    this.onCheckChange,
    this.key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: ListTile(
        leading: editEnable ? Icon(Icons.drag_handle) : null,
        title: Text(_recipe.name),
        trailing: editEnable
            ? Checkbox(
                value: isChecked,
                onChanged: onCheckChange,
              )
            : null,
      ),
    );
  }
}
