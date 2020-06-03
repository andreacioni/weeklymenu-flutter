import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/recipes_provider.dart';
import '../../models/recipe.dart';

class RecipeTile extends StatefulWidget {
  final bool editEnable;

  RecipeTile({this.editEnable});

  @override
  _RecipeTileState createState() => _RecipeTileState();
}

class _RecipeTileState extends State<RecipeTile> {
  bool isChecked;

  @override
  void initState() {
    isChecked = false;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final recipe = Provider.of<Recipe>(context);

    return ListTile(
      leading: Icon(Icons.drag_handle),
      title: Text(recipe.name),
      trailing: Checkbox(value: isChecked, onChanged: (_) => setState(() => isChecked = !isChecked)),
    );
  }
}
