import 'package:flutter/material.dart';

import '../../models/recipe.dart';

class RecipeAppBar extends StatelessWidget {
  final bool editModeEnabled;
  final Recipe _recipe;
  final Object heroTag;
  final Function(bool) onRecipeEditEnabled;

  RecipeAppBar(this._recipe,
      {this.heroTag, this.editModeEnabled, this.onRecipeEditEnabled});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: _recipe.imgUrl != null ? 200.0 : null,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Row(
          children: <Widget>[
            Container(
              color: Colors.black.withOpacity(0.4),
              padding: EdgeInsets.all(3),
              child: Text(
                _recipe.name,
                style: TextStyle(color: Colors.white),
              ),
            ),
            if (editModeEnabled)
              SizedBox(
                width: 10,
              ),
            if (editModeEnabled)
              InkWell(
                borderRadius: BorderRadius.circular(20),
                child: Icon(
                  Icons.edit,
                ),
                onTap: () => _openEditRecipeNameModal(context),
              )
          ],
        ),
        background: _recipe.imgUrl != null
            ? Hero(
                tag: heroTag,
                child: Image.network(
                  _recipe.imgUrl,
                  fit: BoxFit.fitWidth,
                ),
              )
            : null,
      ),
      actions: <Widget>[
        if (!editModeEnabled)
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => onRecipeEditEnabled(!editModeEnabled),
          ),
        if (editModeEnabled)
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: () => _showUpdateImageDialog(context),
          ),
        if (editModeEnabled)
          IconButton(
              icon: Icon(Icons.save),
              onPressed: () => onRecipeEditEnabled(!editModeEnabled)),
      ],
    );
  }

  void _showUpdateImageDialog(BuildContext context) async {
    final textController = TextEditingController();
    textController.text = _recipe.imgUrl;
    String newUrl = await showDialog<String>(
        context: context,
        builder: (_) => AlertDialog(
              title: Text('Image URL'),
              content: TextField(
                decoration: InputDecoration(hintText: 'URL'),
                controller: textController,
              ),
              actions: <Widget>[
                FlatButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('CANCEL')),
                FlatButton(
                    onPressed: () =>
                        Navigator.of(context).pop(textController.text),
                    child: Text('OK'))
              ],
            ));

    if (newUrl != null) {
      _recipe.updateImgUrl(newUrl);
    }
  }

  void _openEditRecipeNameModal(BuildContext context) async {
    final textController = TextEditingController(text: _recipe.name);
    String newRecipeName = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        content: TextField(
          controller: textController,
          decoration: InputDecoration(hintText: 'Recipe name'),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('CANCEL'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          FlatButton(
            child: Text('ADD'),
            onPressed: () {
              var text = textController.text.trim();
              if (text.isNotEmpty) {
                Navigator.of(context).pop(text);
              }
            },
          )
        ],
      ),
    );

    if(newRecipeName != null) {
      _recipe.updateName(newRecipeName);
    }
  }
}
