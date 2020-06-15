import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weekly_menu_app/models/menu.dart';

import '../../providers/recipes_provider.dart';
import '../../models/recipe.dart';

class RecipeTile extends StatefulWidget {
  final bool editEnable;
  final bool isChecked;
  final void Function() onPressed;
  final void Function(bool) onCheckChange;
  final Key key;

  RecipeTile({this.editEnable, this.isChecked, this.onPressed, this.onCheckChange, this.key});

  @override
  _RecipeTileState createState() => _RecipeTileState();
}

class _RecipeTileState extends State<RecipeTile> {
  bool isChecked;

  @override
  void initState() {
    isChecked = widget.isChecked;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final recipe = Provider.of<Recipe>(context);

    return InkWell(
      onTap: widget.onPressed,
      child: ListTile(
        leading: widget.editEnable ? Icon(Icons.drag_handle) : null,
        title: Text(recipe.name),
        trailing: widget.editEnable
            ? Checkbox(
                value: isChecked,
                onChanged: (checked) => _handleCheckChange(checked),
              )
            : null,
      ),
    );
  }

  void _handleCheckChange(bool checked) {
    setState(() => isChecked = !isChecked);
    widget.onCheckChange(checked);
  }
}
