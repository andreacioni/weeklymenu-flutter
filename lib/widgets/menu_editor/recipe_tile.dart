import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/recipe.dart';

class RecipeTile extends StatelessWidget {
  final bool editEnable;
  final bool isChecked;
  final void Function() onPressed;
  final void Function(bool) onCheckChange;
  final Key key;

  RecipeTile({
    this.editEnable,
    this.isChecked,
    this.onPressed,
    this.onCheckChange,
    this.key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final recipe = Provider.of<Recipe>(context);

    return InkWell(
      onTap: onPressed,
      child: ListTile(
        leading: editEnable ? Icon(Icons.drag_handle) : null,
        title: Text(recipe.name),
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
